//
//  Reachability+RAC.swift
//  AudioGuide
//
//  Created by Petr Šíma on Sep/15/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Result
import Reachability
import ReactiveSwift

#if !COCOAPODS
    import ACKReactiveExtensionsCore
#endif

extension Reactive where Base: Reachability {
    /// Current network status property
    public var status: Property<Reachability.Connection> {
        return Property(initial: base.connection, then: statusSignal)
    }
    
    private var statusSignal: SignalProducer<Reachability.Connection, NoError> {
        return lazyAssociatedProperty(base, &AssociationKeys.statusSignalKey) {
            SignalProducer<Reachability.Connection, NoError> { [unowned base = self.base] observer, _ in
                let oldReachableBlock = base.whenReachable
                base.whenReachable = { reachability in
                    oldReachableBlock?(reachability)
                    observer.send(value: reachability.connection)
                }
                
                let oldUnreachableBlock = base.whenUnreachable
                base.whenUnreachable = { reachability in
                    oldUnreachableBlock?(reachability)
                    observer.send(value: reachability.connection)
                }
                }.on(started: { [weak base = self.base] in try? base?.startNotifier() },
                     terminated: { [weak base = self.base] in base?.stopNotifier() })
        }
    }
}

private struct AssociationKeys {
    static var statusKey: UInt8 = 0
    static var statusSignalKey: UInt8 = 1
}
