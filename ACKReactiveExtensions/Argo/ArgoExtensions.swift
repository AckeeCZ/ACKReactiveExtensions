//
//  ArgoExtensions.swift
//  Pixm8
//
//  Created by Jakub Olejník on 01/12/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Argo

public func rac_decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<T, DecodeError> {
    return SignalProducer { sink, disposable in

        let decoded: Decoded<T> = decode(object)
        switch decoded {
        case .Success(let box):
            sink.sendNext(box)
            sink.sendCompleted()
        case .Failure(let e):
            sink.sendFailed(e)
        }
    }
}



public func rac_decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<[T], DecodeError> {
    return SignalProducer { sink, disposable in

        let decoded: Decoded<[T]> = decode(object)
        switch decoded {
        case .Success(let box):
            sink.sendNext(box)
            sink.sendCompleted()
            break
        case .Failure(let e):
            sink.sendFailed(e)
        }
    }

}

public func rac_decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, object: AnyObject) -> SignalProducer<[T], DecodeError> {
    return SignalProducer { sink, disposable in

        let decoded: Decoded<[T]> = decodeWithRootKey(rootKey, object)
        switch decoded {
        case .Success(let box):
            sink.sendNext(box)
            sink.sendCompleted()
            break
        case .Failure(let e):
            sink.sendFailed(e)
        }
    }

}

public func rac_decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, object: AnyObject) -> SignalProducer<T, DecodeError> {
    return SignalProducer { sink, disposable in

        let decoded: Decoded<T> = decodeWithRootKey(rootKey, object)
        switch decoded {
        case .Success(let box):
            sink.sendNext(box)
            sink.sendCompleted()
        case .Failure(let e):
            sink.sendFailed(e)
        }
    }
}

public func rac_decodeByOne<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<T, DecodeError> {
    return SignalProducer { sink, disposable in

        let decoded: Decoded<[T]> = decode(object)
        switch decoded {
        case .Success(let box):
            for value in box {
                sink.sendNext(value)
            }
            sink.sendCompleted()
        case .Failure(let e):
            sink.sendFailed(e)
            break
        }

    }
}
