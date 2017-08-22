//
//  ArgoExtensions.swift
//  Pixm8
//
//  Created by Jakub Olejník on 01/12/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveSwift
import Argo
import Result

/**
 * Reactively decode an object
 *
 * - parameter object: Source object to decode
 * - returns: SignalProducer that sends decoded object
 */
@available(*, deprecated, message: "Use extension mapResponseArgo() on SignalProducer<Any,DecodeErrorCreatable>")
public func rac_decode < T: Decodable> (object: AnyObject) -> SignalProducer<T, DecodeError> where T == T.DecodedType  {
    return SignalProducer { sink, disposable in
        
        let decoded: Decoded<T> = decode(object)
        switch decoded {
        case .success(let box):
            sink.send(value:box)
            sink.sendCompleted()
        case .failure(let e):
            sink.send(error:e)
        }
    }
}

/**
 * Reactively decode array of object
 *
 * - parameter object: Source object to decode
 * - returns: SignalProducer that sends decoded array
 */
@available(*, deprecated, message: "Use extension mapResponseArgo() on SignalProducer<Any,DecodeErrorCreatable>")
public func rac_decode < T: Decodable> (object: AnyObject) -> SignalProducer<[T], DecodeError> where T == T.DecodedType  {
    return SignalProducer { sink, disposable in
        
        let decoded: Decoded<[T]> = decode(object)
        switch decoded {
        case .success(let box):
            sink.send(value: box)
            sink.sendCompleted()
            break
        case .failure(let e):
            sink.send(error: e)
        }
    }
}

/**
 * Reactively decode an array of objects with key in source JSON object
 *
 * - parameter rootKey: Key in source object
 * - parameter object: Source object to decode
 * - returns: SignalProducer that sends decoded array
 */
@available(*, deprecated, message: "Use extension mapResponseArgo() on SignalProducer<Any,DecodeErrorCreatable>")
public func rac_decodeWithRootKey < T: Decodable> (rootKey: String, object: AnyObject) -> SignalProducer<[T], DecodeError> where T == T.DecodedType  {
    return SignalProducer { sink, disposable in
        
        guard let object = object as? [String: AnyObject] else {
            sink.send(error: DecodeError.custom("Invalid format"))
            return
        }
        
        let decoded: Decoded<[T]> = decode(object, rootKey: rootKey)
        switch decoded {
        case .success(let box):
            sink.send(value: box)
            sink.sendCompleted()
            break
        case .failure(let e):
            sink.send(error: e)
        }
    }
}

/**
 * Reactively decode an object with root key
 *
 * - parameter rootKey: Key in source object
 * - parameter object: Source object to decode
 * - returns: SignalProducer that sends decoded object
 */
@available(*, deprecated, message: "Use extension mapResponseArgo() on SignalProducer<Any,DecodeErrorCreatable>")
public func rac_decodeWithRootKey < T: Decodable> (rootKey: String, object: AnyObject) -> SignalProducer<T, DecodeError> where T == T.DecodedType  {
    return SignalProducer { sink, disposable in
        
        guard let object = object as? [String: AnyObject] else {
            sink.send(error: DecodeError.custom("Invalid format"))
            return
        }
        
        let decoded: Decoded<T> = decode(object, rootKey: rootKey)
        switch decoded {
        case .success(let box):
            sink.send(value: box)
            sink.sendCompleted()
        case .failure(let e):
            sink.send(error: e)
        }
    }
}

/**
 * Reactively decode an array of objects with key in source JSON object
 * and send them one after another
 *
 * - parameter rootKey: Key in source object
 * - parameter object: Source object to decode
 * - returns: SignalProducer that sends decoded array one by one
 */
@available(*, deprecated, message: "Use extension mapResponseArgo() on SignalProducer<Any,DecodeErrorCreatable>")
public func rac_decodeByOne < T: Decodable> (object: AnyObject) -> SignalProducer<T, DecodeError> where T == T.DecodedType  {
    return SignalProducer { sink, disposable in
        
        let decoded: Decoded<[T]> = decode(object)
        switch decoded {
        case .success(let box):
            for value in box {
                sink.send(value: value)
            }
            sink.sendCompleted()
        case .failure(let e):
            sink.send(error: e)
            break
        }
    }
}


extension Signal where Value == Any, Error: DecodeErrorCreatable {
    
    /**
     * Map value as `Decodable` object
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    @available(*, renamed: "mapResponse(forKey:)")
    public func mapResponseArgo<ResultType: Decodable>(for key: String? = nil) -> Signal<ResultType, Error> where ResultType.DecodedType == ResultType {
        return mapResponse(forKey: key)
    }
    
    /**
     * Map values as `Decodable` objects
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    @available(*, renamed: "mapResponse(forKey:)")
    public func mapResponseArgo<ResultType: Decodable>(for key: String? = nil) -> Signal<[ResultType], Error> where ResultType.DecodedType == ResultType {
        return mapResponse(forKey: key)
    }
}

extension SignalProducer where Value == Any, Error: DecodeErrorCreatable {
    
    /**
     * Map value as `Decodable` object
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    @available(*, renamed: "mapResponse(forKey:)")
    public func mapResponseArgo<ResultType: Decodable>(for key: String? = nil) -> SignalProducer<ResultType, Error> where ResultType.DecodedType == ResultType {
        return lift { $0.mapResponseArgo(for: key) }
    }
    
    /**
     * Map values as `Decodable` objects
     *
     * - parameter key: If your objects are contained within dictionary pass the key here
     */
    @available(*, renamed: "mapResponse(forKey:)")
    public func mapResponseArgo<ResultType: Decodable>(for key: String? = nil) -> SignalProducer<[ResultType], Error> where ResultType.DecodedType == ResultType {
        return lift { $0.mapResponseArgo(for: key) }
    }
}
