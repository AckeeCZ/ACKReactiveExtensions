//
//  MarshalMapping.swift
//  ACKReactiveExtensions
//
//  Created by Jakub Olejník on 06/04/2017.
//  Ackee
//

import Marshal
import ReactiveSwift

#if !COCOAPODS
    import ACKReactiveExtensionsCore
#endif

/**
 * Protocol that allows creation of custom Marshal errors
 */
public protocol MarshalErrorCreatable: Error {

    /**
     * Create error containing passed `MarshalError`
     *
     * - parameter marshalError: `MarshalError` which should be wrapped
     */
    static func createMarshalError(_ marshalError: MarshalError) -> Self
}

extension MarshalError: MarshalErrorCreatable {
    public static func createMarshalError(_ marshalError: MarshalError) -> MarshalError {
        return marshalError
    }
}

extension Signal where Value == Any, Error: MarshalErrorCreatable {

    /**
     * Map value as `Unmarshaling` object
     *
     * - parameter forKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<Model>(forKey key: KeyType? = nil) -> Signal<Model, Error> where Model: Unmarshaling {
        return attemptMap { json in
            Result(catching: {
                if ACKReactiveExtensionsConfiguration.allowMappingOnMainThread == false {
                    assert(Thread.current.isMainThread == false, "Mapping should not be performed on main thread!")
                }

                guard let marshaledJSON = json as? MarshaledObject
                    else {
                        throw MarshalError.typeMismatch(expected: MarshaledObject.self, actual: type(of: json))
                }
                if let key = key {
                    return try marshaledJSON.value(for: key)
                } else {
                    return try Model.init(object: marshaledJSON)
                }
            })
                // swiftlint:disable:next force_cast
                .mapError { Error.createMarshalError($0 as! MarshalError) }
        }
    }

    /**
     * Map value as `Unmarshaling` object
     *
     * - parameter forKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<Model>(forKey key: KeyType? = nil) -> Signal<[Model], Error> where Model: Unmarshaling {
        return signal.attemptMap { json in
            return Result(catching: {
                if ACKReactiveExtensionsConfiguration.allowMappingOnMainThread == false {
                    assert(Thread.current.isMainThread == false, "Mapping should not be performed on main thread!")
                }

                do {
                    if let key = key, let marshaledJSON = json as? MarshaledObject {
                        return try marshaledJSON.value(for: key)
                    }
                    else if let marshaledArray = json as? [MarshaledObject] {
                        return try marshaledArray.map(Model.init)
                    }
                    else {
                        throw MarshalError.typeMismatch(expected: MarshaledObject.self, actual: type(of: json))
                    }
                }
            })
                // swiftlint:disable:next force_cast
                .mapError { Error.createMarshalError($0 as! MarshalError) }
        }
    }

    /**
     * Map value as `ValueType`
     *
     * - parameter forKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<Model>(forKey key: KeyType) -> Signal<Model, Error> where Model: ValueType {
        return signal.attemptMap { json in
            Result(catching: {
                if ACKReactiveExtensionsConfiguration.allowMappingOnMainThread == false {
                    assert(Thread.current.isMainThread == false, "Mapping should not be performed on main thread!")
                }

                guard let marshaledJSON = json as? MarshaledObject
                    else {
                        throw MarshalError.typeMismatch(expected: MarshaledObject.self, actual: type(of: json))
                }
                return try marshaledJSON.value(for: key)
            })
                // swiftlint:disable:next force_cast
                .mapError { Error.createMarshalError($0 as! MarshalError) }
        }
    }
}

extension SignalProducer where Value == Any, Error: MarshalErrorCreatable {
    /**
     * Map value as `Unmarshaling` object
     *
     * - parameter forKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<Model>(forKey key: KeyType? = nil) -> SignalProducer<Model, Error> where Model: Unmarshaling {
        return lift { $0.mapResponse(forKey: key) }
    }

    /**
     * Map value as `Unmarshaling` object
     *
     * - parameter forKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<Model>(forKey key: KeyType? = nil) -> SignalProducer<[Model], Error> where Model: Unmarshaling {
        return lift { $0.mapResponse(forKey: key) }
    }

    /**
     * Map value as `ValueType`
     *
     * - parameter forKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<Model>(forKey key: KeyType) -> SignalProducer<Model, Error> where Model: ValueType {
        return lift { $0.mapResponse(forKey: key) }
    }
}
