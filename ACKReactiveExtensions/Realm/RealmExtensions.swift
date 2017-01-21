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

public struct RealmError : Error {
    let underlyingError: NSError
    init(underlyingError: NSError){
        self.underlyingError = underlyingError
    }
}

public enum Change<T> {
    typealias Element = T
    
    case initial(T)
    case update(T, deletions: [Int], insertions: [Int], modifications: [Int])
}

public extension Reactive where Base: RealmCollection {
    
    public var changes: SignalProducer<Change<Base>, RealmError> {
        var notificationToken: NotificationToken? = nil
        
        let producer: SignalProducer<Change<Base>, RealmError> = SignalProducer { sink, d in
            notificationToken = self.base.addNotificationBlock { (changes) in
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
            notificationToken?.stop()
            notificationToken = nil
        }, disposed: {
            notificationToken?.stop()
            notificationToken = nil
        })
        
        return producer
    }
    
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
    
    public var property: ReactiveSwift.Property<Base> {
        return ReactiveSwift.Property(initial: self.base, then: values.ignoreError().skip(first: 1) )
    }
}

