//
//  Reachability+RAC.swift
//  AudioGuide
//
//  Created by Petr Šíma on Sep/15/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ObjectiveC
import Reachability

private struct AssociationKeys {
 static var statusKey: UInt8 = 0
}

extension Reachability {
	var rac_status: SignalProducer<NetworkStatus, NoError> {
		if let signalProducer = (objc_getAssociatedObject(self, &AssociationKeys.statusKey) as? RACSignal)?.toSignalProducer() {
			return signalProducer
					.map { NetworkStatus(rawValue: ($0 as NSNumber).integerValue)! }
					.ignoreError()
		} else {
			let newProducer = SignalProducer<NetworkStatus, NoError>({ (sink, dis) -> () in
				sink.sendNext(self.currentReachabilityStatus())
				let oldRBlock = self.reachableBlock
				self.reachableBlock = { r in
					if oldRBlock != nil {
						oldRBlock(r)
					}
					sink.sendNext(r.currentReachabilityStatus())
				}
				let oldUnRBlock = self.unreachableBlock
				self.unreachableBlock = { r in
					if oldUnRBlock != nil {
						oldUnRBlock(r)
					}
					sink.sendNext(r.currentReachabilityStatus())
				}
			})
			let racSignal = toRACSignal(newProducer
				.map { NSNumber(integer: $0.rawValue) })
			objc_setAssociatedObject(self, &AssociationKeys.statusKey, racSignal, .OBJC_ASSOCIATION_RETAIN)
			return newProducer
		}
	}
}
