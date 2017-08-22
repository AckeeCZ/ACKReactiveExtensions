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

extension Signal where Value == Any, Error: DecodeErrorCreatable {
    
    /**
     * Map value as `Decodable` object
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<ResultType: Decodable>(forKey key: String? = nil) -> Signal<ResultType, Error> where ResultType.DecodedType == ResultType {
        return attemptMap { data in
            if ACKReactiveExtensionsConfiguration.allowMappingOnMainThread == false {
                assert(Thread.current.isMainThread == false, "Mapping should not be performed on main thread!")
            }
            
            let decoded: Decoded<ResultType> = key.map {
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
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<ResultType: Decodable>(forKey key: String? = nil) -> Signal<[ResultType], Error> where ResultType.DecodedType == ResultType {
        return attemptMap { data in
            if ACKReactiveExtensionsConfiguration.allowMappingOnMainThread == false {
                assert(Thread.current.isMainThread == false, "Mapping should not be performed on main thread!")
            }
            
            let decoded: Decoded<[ResultType]> = key.map {
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

extension SignalProducer where Value == Any, Error: DecodeErrorCreatable {
    
    /**
     * Map value as `Decodable` object
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<ResultType: Decodable>(forKey key: String? = nil) -> SignalProducer<ResultType, Error> where ResultType.DecodedType == ResultType {
        return lift { $0.mapResponse(forKey: key) }
    }
    
    /**
     * Map values as `Decodable` objects
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    public func mapResponse<ResultType: Decodable>(forKey key: String? = nil) -> SignalProducer<[ResultType], Error> where ResultType.DecodedType == ResultType {
        return producer.lift { $0.mapResponse(forKey: key) }
    }
}
