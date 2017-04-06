//
//  ArgoMapping.swift
//  ACKReactiveExtensions
//
//  Created by Jakub Olejník on 06/04/2017.
//  Ackee
//

import Argo
import Result
import ReactiveSwift

/**
 * Protocol that allows creation of custom Decode errors
 */
public protocol DecodeErrorCreatable: Error {
    
    /**
     * Create error containing passed `DecodeError`
     * 
     * - parameter decodeError: `DecodeError` which should be wrapped
     */
    static func createDecodeError(_ decodeError: DecodeError) -> Self
}

extension DecodeError: DecodeErrorCreatable {
    public static func createDecodeError(_ decodeError: DecodeError) -> DecodeError {
        return decodeError
    }
}

extension SignalProtocol where Value == Any, Error: DecodeErrorCreatable {
    
    /**
     * Map value as `Decodable` object
     *
     * - parameter rootKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseArgo<ResultType: Decodable>(rootKey: String? = nil) -> Signal<ResultType, Error> where ResultType.DecodedType == ResultType {
        return attemptMap { data in
            let decoded: Decoded<ResultType> = rootKey.map {
            let dict = data as? [String: Any] ?? [:]
            return decode(dict, rootKey: $0)
            } ?? decode(data)
            
            switch decoded {
            case .success(let box):
                return Result.success(box)
            case .failure(let error):
                return Result.failure(Error.createDecodeError(error))
            }
        }
    }
    
    /**
     * Map values as `Decodable` objects
     *
     * - parameter rootKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseArgo<ResultType: Decodable>(rootKey: String? = nil) -> Signal<[ResultType], Error> where ResultType.DecodedType == ResultType {
        return attemptMap { data in
            let decoded: Decoded<[ResultType]> = rootKey.map {
                let dict = data as? [String: Any] ?? [:]
                return decode(dict, rootKey: $0)
                } ?? decode(data)
            
            switch decoded {
            case .success(let box):
                return Result.success(box)
            case .failure(let error):
                return Result.failure(Error.createDecodeError(error))
            }
        }
    }
}

extension SignalProducerProtocol where Value == Any, Error: DecodeErrorCreatable {
    
    /**
     * Map value as `Decodable` object
     *
     * - parameter rootKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseArgo<ResultType: Decodable>(rootKey: String? = nil) -> SignalProducer<ResultType, Error> where ResultType.DecodedType == ResultType {
        return lift { $0.mapResponseArgo(rootKey: rootKey) }
    }
    
    /**
     * Map values as `Decodable` objects
     *
     * - parameter rootKey: If your objects are contained within dictionary pass the key here
     */
    public func mapResponseArgo<ResultType: Decodable>(rootKey: String? = nil) -> SignalProducer<[ResultType], Error> where ResultType.DecodedType == ResultType {
        return lift { $0.mapResponseArgo(rootKey: rootKey) }
    }
}
