//
//  Core.swift
//  Pods
//
//  Created by Jan Mísař on 04.06.16.
//
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

//MARK: ReactiveCocoa

extension SignalProducerProtocol {
    public func ignoreError() -> SignalProducer<Value, NoError> {
        return flatMapError { _ in SignalProducer.empty }
    }
}

@available(*, deprecated, message: "Use native SignalProducer.merge()")
public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    let producers = SignalProducer<SignalProducer<T, E>, E>(signals)
    return producers.flatten(.merge)
}

extension SignalProducerProtocol where Value == Void, Error == NoError {
    public static func sideEffect(actions: @escaping () -> ()) -> SignalProducer<(), NoError> {
        return SignalProducer<(), NoError> { sink, _ in
            actions()
            sink.sendCompleted()
        }
    }
}

extension SignalProducer {
    // the autoclosure can still retain self strongly. The compiler will warn you by requiring `self.`.
    // Dont ignore memory managment! If you need to capture self weekly (or unowned), you cant use autoclosure and must supply a full closure.
    public init(lazyValue: @autoclosure(escaping) () -> Value) {
        self.init { observer, _ in
            observer.send(value: lazyValue())
            observer.sendCompleted()
        }
    }
}

//MARK: Disposing

private struct AssociationKey {
    static var lifecycleObject: UInt8 = 1
}

public protocol Disposing: class {
    var rac_lifetime: Lifetime { get }
}

extension NSObject: Disposing { }

extension Disposing where Self: NSObject {
    public var rac_lifetime: Lifetime {
        return (self as NSObject).reactive.lifetime
    }
}

extension Disposing {
    private var lifecycleObject: NSObject {
        return lazyAssociatedProperty(self, &AssociationKey.lifecycleObject, factory: {
            NSObject()
        })
    }

    public var rac_lifetime: Lifetime {
        return lifecycleObject.rac_lifetime
    }
}

//MARK: Associated properties

// lazily creates a gettable associated property via the given factory
public func lazyAssociatedProperty<T: AnyObject>(_ host: AnyObject, _ key: UnsafePointer<Void>, factory: () -> T) -> T {
    var associatedProperty = objc_getAssociatedObject(host, key) as? T

    if associatedProperty == nil {
        associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, .OBJC_ASSOCIATION_RETAIN)
    }
    return associatedProperty!
}

public func lazyMutableProperty<T>(_ host: AnyObject, _ key: UnsafePointer<Void>, _ setter: @escaping (T) -> (), _ getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithValues { setter($0) }
        return property
    }
}
