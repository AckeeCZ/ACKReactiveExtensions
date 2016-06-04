//
//  Core.swift
//  Pods
//
//  Created by Jan Mísař on 04.06.16.
//
//

import Foundation
import ReactiveCocoa

import enum Result.NoError
public typealias NoError = Result.NoError

extension SignalProducerType {
    public func ignoreError() -> SignalProducer<Value, NoError> {
        return flatMapError { _ in SignalProducer.empty }
    }
}

public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    let producers = SignalProducer<SignalProducer<T, E>, E>(values: signals)
    return producers.flatten(.Merge)
}

//MARK: Disposing

private struct AssociationKey {
    static var lifecycleObject: UInt8 = 1
}

protocol Disposing: class {
    var rac_willDeallocSignal: Signal<(), NoError> { get }
}

extension NSObject {
    var rac_willDeallocSignal: Signal<(), NoError> {
        var extractedSignal: Signal<(), NoError>!
        self.rac_willDeallocSignal().toSignalProducer().ignoreError().map { _ in() }
            .startWithSignal { signal, _ in
                extractedSignal = signal
        }
        return extractedSignal
    }
}

extension Disposing {
    private var lifecycleObject: NSObject {
        return lazyAssociatedProperty(self, &AssociationKey.lifecycleObject, factory: {
            NSObject()
        })
    }

    var rac_willDeallocSignal: Signal<(), NoError> {
        return lifecycleObject.rac_willDeallocSignal
    }
}