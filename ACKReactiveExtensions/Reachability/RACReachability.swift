//
//  Reachability+RAC.swift
//  AudioGuide
//
//  Created by Petr Šíma on Sep/15/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import ObjectiveC
import Reachability

extension Reactive where Base: Reachability {
    /// Current network status property
    public var status: Property<NetworkStatus> {
        return Property(initial: base.currentReachabilityStatus(), then: statusSignal)
    }
    
    private var statusSignal: SignalProducer<NetworkStatus, NoError> {
        return lazyAssociatedProperty(base, &AssociationKeys.statusSignalKey) {
            SignalProducer<NetworkStatus, NoError> { [unowned base = self.base] observer, _ in
                let oldReachableBlock = base.reachableBlock
                base.reachableBlock = { reachability in
                    oldReachableBlock?(reachability)
                    
                    if let reachability = reachability {
                        observer.send(value: reachability.currentReachabilityStatus())
                    }
                }
                
                let oldUnreachableBlock = base.unreachableBlock
                base.unreachableBlock = { reachability in
                    oldUnreachableBlock?(reachability)
                    
                    if let reachability = reachability {
                        observer.send(value: reachability.currentReachabilityStatus())
                    }
                }
                }.on(started: { [weak base = self.base] in base?.startNotifier() },
                     terminated: { [weak base = self.base] in base?.stopNotifier() })
        }
    }
}

private struct AssociationKeys {
    static var statusKey: UInt8 = 0
    static var statusSignalKey: UInt8 = 1
}

extension Reachability {
    /// Current network status SignalProducer
    @available(*, deprecated, renamed: "reactive.status.producer")
    public var rac_status: SignalProducer<NetworkStatus, NoError> {
        if let signalProducer = (objc_getAssociatedObject(self, &AssociationKeys.statusKey) as? SignalProducer<NetworkStatus, NoError>) {
            return signalProducer
        } else {
            let newProducer = SignalProducer<NetworkStatus, NoError>({ (sink, dis) -> () in
                sink.send(value: self.currentReachabilityStatus())
                let oldRBlock = self.reachableBlock
                self.reachableBlock = { r in
                    if let oldRBlock = oldRBlock {
                        oldRBlock(r)
                    }
                    if let r = r {
                        sink.send(value: r.currentReachabilityStatus())
                    }
                }
                let oldUnRBlock = self.unreachableBlock
                self.unreachableBlock = { r in
                    if let oldUnRBlock = oldUnRBlock {
                        oldUnRBlock(r)
                    }
                    if let r = r {
                        sink.send(value: r.currentReachabilityStatus())
                    }
                }
            })
            objc_setAssociatedObject(self, &AssociationKeys.statusKey, newProducer, .OBJC_ASSOCIATION_RETAIN)
            return newProducer
        }
    }
}
