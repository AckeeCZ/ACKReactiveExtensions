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

public protocol MappingError: Error {
    static func createDecodeError(_ decodeError: DecodeError) -> Self
}

extension DecodeError: MappingError {
    public static func createDecodeError(_ decodeError: DecodeError) -> DecodeError {
        return decodeError
    }
}

extension SignalProtocol where Value == Any, Error: MappingError {
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

extension SignalProducerProtocol where Value == Any, Error: MappingError {
    public func mapResponseArgo<ResultType: Decodable>(rootKey: String? = nil) -> SignalProducer<ResultType, Error> where ResultType.DecodedType == ResultType {
        return lift { $0.mapResponseArgo(rootKey: rootKey) }
    }
    
    public func mapResponseArgo<ResultType: Decodable>(rootKey: String? = nil) -> SignalProducer<[ResultType], Error> where ResultType.DecodedType == ResultType {
        return lift { $0.mapResponseArgo(rootKey: rootKey) }
    }
}
