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

public protocol MarshalErrorCreatable: Error {
    static func createMarshalError(_ marshalError: MarshalError) -> Self
}

extension SignalProtocol where Value == Any, Error: MarshalErrorCreatable {
    public func mapResponseMarshal<Model>(for key: KeyType? = nil) -> Signal<Model, Error> where Model: Unmarshaling {
        return attemptMap { json in
            Result {
                guard let marshaledJSON = json as? MarshaledObject
                    else {
                        assertionFailure("json isn't any of the known MarshaledObject types (Dictionary or Array)")
                        throw NSError(domain: "", code: 0, userInfo: nil)
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
    
    public func mapResponseMarshal<Model>(for key: KeyType? = nil) -> Signal<[Model], Error> where Model: Unmarshaling {
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
                    assertionFailure("json isn't any of the known MarshaledObject types (Dictionary or Array)")
                    throw NSError(domain: "", code: 0, userInfo: nil)
                }
                }
                .mapError { Error.createMarshalError($0) }
        }
    }
    
    public func mapResponseMarshal<Model>(for key: KeyType) -> Signal<Model, Error> where Model: ValueType {
        return attemptMap { json in
            Result {
                guard let marshaledJSON = json as? MarshaledObject
                    else {
                        assertionFailure("json isn't any of the known MarshaledObject types (Dictionary or Array)")
                        throw NSError(domain: "", code: 0, userInfo: nil)
                }
                return try marshaledJSON.value(for: key)
                }
                .mapError { Error.createMarshalError($0) }
        }
    }
}

extension SignalProducerProtocol where Value == Any, Error: MarshalErrorCreatable {
    public func mapResponseMarshal<Model>(for key: KeyType? = nil) -> SignalProducer<Model, Error> where Model: Unmarshaling {
        return lift { $0.mapResponseMarshal(for: key) }
    }
    
    public func mapResponseMarshal<Model>(for key: KeyType? = nil) -> SignalProducer<[Model], Error> where Model: Unmarshaling {
        return lift { $0.mapResponseMarshal(for: key) }
    }
    
    public func mapResponseMarshal<Model>(for key: KeyType) -> SignalProducer<Model, Error> where Model: ValueType {
        return lift { $0.mapResponseMarshal(for: key) }
    }
}
