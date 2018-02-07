//
//  RealmObjectExtensions.swift
//  Realm
//
//  Created by Jakub Olejník on 06/02/2018.
//

import RealmSwift
import ReactiveSwift

extension Reactive where Base: Object {
    /// Signal with object changes
    ///
    /// Make sure not to subscribe to this signal inside Realm transaction
    var changes: Signal<Base?, RealmError> {
        return Signal { [weak base = base] observer, lifetime in
            guard let base = base else { observer.sendInterrupted(); return }
            
            var notificationToken: NotificationToken? = base.observe { change in
                switch change {
                case .error(let e): observer.send(error: RealmError(underlyingError: e))
                case .deleted:
                    observer.send(value: nil)
                    observer.sendCompleted()
                case .change: observer.send(value: base)
                }
            }
            
            lifetime.observeEnded {
                _ = notificationToken // silence Xcode warning, token needs to be held strongly
                notificationToken = nil
            }
        }
    }
    
    /// Property with current object state
    ///
    /// Make sure not to create this property inside Realm transaction
    var property: ReactiveSwift.Property<Base?> {
        return Property(initial: base, then: changes.flatMapError { _ in SignalProducer(value: nil) })
    }
}
