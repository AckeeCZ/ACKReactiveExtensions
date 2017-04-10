//
//  MarshalMapping.swift
//  ACKReactiveExtensions
//
//  Created by Jakub Olejník on 06/04/2017.
//  Ackee
//

import Result
import Marshal
import ReactiveSwift

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

extension SignalProtocol where Value == Any, Error: MarshalErrorCreatable {
    
    /**
     * Map value as `Unmarshaling` object
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseMarshal<Model>(forKey key: KeyType? = nil) -> Signal<Model, Error> where Model: Unmarshaling {
        return attemptMap { json in
            Result {
                guard let marshaledJSON = json as? MarshaledObject
                    else {
                        throw MarshalError.typeMismatch(expected: MarshaledObject.self, actual: type(of: json))
                }
                if let key = key {
                    return try marshaledJSON.value(for: key)
                } else {
                    return try Model.init(object: marshaledJSON)
                }
                }
                .mapError { Error.createMarshalError($0) }
        }
    }
    
    /**
     * Map value as `Unmarshaling` object
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseMarshal<Model>(forKey key: KeyType? = nil) -> Signal<[Model], Error> where Model: Unmarshaling {
        return attemptMap { json in
            Result {
                if let key = key, let marshaledJSON = json as? MarshaledObject {
                    return try marshaledJSON.value(for: key)
                }
                else if let marshaledArray = json as? [MarshaledObject] {
                    let dummyKey = "dummyKey"
                    return try [dummyKey: marshaledArray].value(for: dummyKey)
                }
                else {
                    throw MarshalError.typeMismatch(expected: MarshaledObject.self, actual: type(of: json))
                }
                }
                .mapError { Error.createMarshalError($0) }
        }
    }
    
    /**
     * Map value as `ValueType`
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseMarshal<Model>(forKey key: KeyType) -> Signal<Model, Error> where Model: ValueType {
        return attemptMap { json in
            Result {
                guard let marshaledJSON = json as? MarshaledObject
                    else {
                        throw MarshalError.typeMismatch(expected: MarshaledObject.self, actual: type(of: json))
                }
                return try marshaledJSON.value(for: key)
                }
                .mapError { Error.createMarshalError($0) }
        }
    }
}

extension SignalProducerProtocol where Value == Any, Error: MarshalErrorCreatable {
    /**
     * Map value as `Unmarshaling` object
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseMarshal<Model>(forKey key: KeyType? = nil) -> SignalProducer<Model, Error> where Model: Unmarshaling {
        return lift { $0.mapResponseMarshal(forKey: key) }
    }
    
    /**
     * Map value as `Unmarshaling` object
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseMarshal<Model>(forKey key: KeyType? = nil) -> SignalProducer<[Model], Error> where Model: Unmarshaling {
        return lift { $0.mapResponseMarshal(forKey: key) }
    }
    
    /**
     * Map value as `ValueType`
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseMarshal<Model>(forKey key: KeyType) -> SignalProducer<Model, Error> where Model: ValueType {
        return lift { $0.mapResponseMarshal(forKey: key) }
    }
}
