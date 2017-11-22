//
//  RealmExtensions.swift
//  Realm
//
//  Created by Tomáš Kohout on 01/12/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift

/// Error return in case of Realm operation failure
public struct RealmError : Error {
    public let underlyingError: NSError
    public init(underlyingError: NSError){
        self.underlyingError = underlyingError
    }
}

/// Enum which represents RealmCollectionChange
public enum Change<T> {
    typealias Element = T
    
    /// Initial value
    case initial(T)
    
    /// RealmCollection was updated
    case update(T, deletions: [Int], insertions: [Int], modifications: [Int])
}

public extension Reactive where Base: RealmCollection {
    
    /// SignalProducer that sends changes as they happen
    public var changes: SignalProducer<Change<Base>, RealmError> {
        var notificationToken: NotificationToken? = nil
        
        let producer: SignalProducer<Change<Base>, RealmError> = SignalProducer { sink, d in
            notificationToken = self.base.observe { (changes) in
                switch changes {
                case .initial(let initial):
                    sink.send(value: Change.initial(initial))
                case .update(let updates, let deletions, let insertions, let modifications):
                    sink.send(value: Change.update(updates, deletions: deletions, insertions: insertions, modifications: modifications))
                case .error(let e):
                    sink.send(error: RealmError(underlyingError: e as NSError))
                }
            }
        }.on(terminated: {
            notificationToken?.invalidate()
            notificationToken = nil
        }, disposed: {
            notificationToken?.invalidate()
            notificationToken = nil
        })
        
        return producer
    }
    
    /// SignalProducer that sends the latest value
    public var values: SignalProducer<Base, RealmError> {
        return self.changes.map { changes -> Base in
            switch changes {
            case .initial(let initial):
                return initial
            case .update(let updates, _, _, _):
                return updates
            }
        }
    }
    
    /// Property which represents the latest value
    public var property: ReactiveSwift.Property<Base> {
        return ReactiveSwift.Property(initial: self.base, then: values.ignoreError().skip(first: 1) )
    }
}

//MARK: Saving
public extension Reactive where Base: Object {
    
    /**
     * Reactive save Realm object
     *
     * - parameter update: Realm should find existing object using primaryKey() and update it if it exists otherwise create new object
     * - parameter writeBlock: Closure which allows custom Realm operation instead of default add
     */
    public func save(update: Bool = true, writeBlock: ((Realm)->Void)? = nil) -> SignalProducer<Base, RealmError>{
        return SignalProducer<Base, RealmError> { sink, d in
            do {
                let realm = try Realm()
                try realm.write {
                    if let writeBlock = writeBlock {
                        writeBlock(realm)
                    } else {
                        realm.add(self.base, update: update)
                    }
                }
                sink.send(value: self.base)
                sink.sendCompleted()
            } catch (let e) {
                sink.send(error: RealmError(underlyingError: e as NSError) )
            }
        }
        
    }
    
    /**
     * Reactively delete object
     */
    public func delete() -> SignalProducer<(), RealmError> {
        return SignalProducer { sink, d in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.base)
                }
                sink.send(value: ())
                sink.sendCompleted()
            } catch (let e) {
                sink.send(error: RealmError(underlyingError: e as NSError) )
            }
        }
    }
    
}


//MARK: Table view


/// Protocol which allows UITableView to be reloaded automatically when database changes happen
public protocol RealmTableViewReloading {
    associatedtype Element: Object
    var tableView: UITableView! { get set }
}

public extension Reactive where Base: UIViewController, Base: RealmTableViewReloading {
    
    /// Binding target which updates tableView according to received changes
    public var changes: BindingTarget<Change<Results<Base.Element>>> {
        return makeBindingTarget { vc, changes in
            guard let tableView = vc.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            }
        }
    }
}


//MARK: PrimaryKeyEquatable

protocol PrimaryKeyEquatable: class {
    static func primaryKey() -> String?
    subscript(key: String) -> Any? { get set }
}

extension Object: PrimaryKeyEquatable {}

precedencegroup PrimaryKeyEquative {
    associativity: left
}

infix operator ~== : PrimaryKeyEquative

func ~==(lhs: PrimaryKeyEquatable, rhs: PrimaryKeyEquatable) -> Bool {
    //Super ugly but can't find nicer way to assert same types
    guard "\(type(of: lhs))" == "\(type(of: rhs))" else {
        assertionFailure("Trying to compare different types \(type(of: lhs)) and \(type(of: rhs))");
        return false
    }
    
    guard let primaryKey = type(of: lhs).primaryKey(), let lValue = lhs[primaryKey],
    let rValue = rhs[primaryKey] else {
        assertionFailure("Trying to compare object that has no primary key");
        return false
    }
    
    if let l = lValue as? String, let r = rValue as? String {
        return l == r
    } else if let l = lValue as? Int, let r = rValue as? Int {
        return l == r
    } else if let l = lValue as? Int8, let r = rValue as? Int8 {
        return l == r
    } else if let l = lValue as? Int16, let r = rValue as? Int16 {
        return l == r
    } else if let l = lValue as? Int32, let r = rValue as? Int32 {
        return l == r
    } else if let l = lValue as? Int64, let r = rValue as? Int64 {
        return l == r
    } else {
        assertionFailure("Unsupported primary key")
        return false
    }
}

//MARK: Orphaned Object

extension Realm {
    
    /// Add objects and delete non-present objects from the orphan query
    public func add<S: Sequence>(_ objects: S, update: Bool = true, deleteOrphanedQuery: Results<S.Iterator.Element>) where S.Iterator.Element: Object {
        let allObjects = deleteOrphanedQuery.map { $0 }
        //This could be faster with set, but we can't redefine hashable
        let objectsToDelete = allObjects.filter { old in
            !objects.contains(where: {
                old ~== $0
            })
        }
        self.delete(objectsToDelete)
        self.add(objects, update: update)
    }
}

