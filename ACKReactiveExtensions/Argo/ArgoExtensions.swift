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

public func rac_decode < T: Decodable where T == T.DecodedType > (object: AnyObject) -> SignalProducer<T, DecodeError> {
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

public func rac_decode < T: Decodable where T == T.DecodedType > (object: AnyObject) -> SignalProducer<[T], DecodeError> {
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

public func rac_decodeWithRootKey < T: Decodable where T == T.DecodedType > (rootKey: String, object: AnyObject) -> SignalProducer<[T], DecodeError> {
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

public func rac_decodeWithRootKey < T: Decodable where T == T.DecodedType > (rootKey: String, object: AnyObject) -> SignalProducer<T, DecodeError> {
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

public func rac_decodeByOne < T: Decodable where T == T.DecodedType > (object: AnyObject) -> SignalProducer<T, DecodeError> {
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
