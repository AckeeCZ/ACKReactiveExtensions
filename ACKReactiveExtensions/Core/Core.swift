//
//  Core.swift
//  Pods
//
//  Created by Jan Mísař on 04.06.16.
//
//

import Foundation
import ReactiveCocoa
import Result

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

public protocol Disposing: class {
    var rac_willDeallocSignal: Signal<(), NoError> { get }
}

extension NSObject: Disposing {
    public var rac_willDeallocSignal: Signal<(), NoError> {
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

    public var rac_willDeallocSignal: Signal<(), NoError> {
        return lifecycleObject.rac_willDeallocSignal
    }
}

//MARK: Associated properties

// lazily creates a gettable associated property via the given factory
public func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, _ key: UnsafePointer<Void>, factory: () -> T) -> T {
    var associatedProperty = objc_getAssociatedObject(host, key) as? T

    if associatedProperty == nil {
        associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, .OBJC_ASSOCIATION_RETAIN)
    }
    return associatedProperty!
}

public func lazyMutableProperty<T>(host: AnyObject, _ key: UnsafePointer<Void>, _ setter: T -> (), _ getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithNext {
                newValue in
                setter(newValue)
        }
        return property
    }
}