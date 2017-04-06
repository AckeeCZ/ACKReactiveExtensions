//
//  ArgoMappingTests.swift
//  ACKReactiveExtensions
//
//  Created by Jakub Olejník on 06/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Argo
import Curry
import Runes
import XCTest
import Result
import ReactiveSwift
import ACKReactiveExtensions

struct ErrorStub: MappingError {
    let decodeError: DecodeError
    
    static func createDecodeError(_ decodeError: DecodeError) -> ErrorStub {
        return ErrorStub(decodeError: decodeError)
    }
}

struct ModelStub: Decodable, Equatable {
    let value: Int
    
    var dictionary: [String: Any] {
        return ["value": value]
    }
    
    var invalidDictionary: [String: Any] {
        return ["val": value]
    }
    
    static func decode(_ json: JSON) -> Decoded<ModelStub> {
        return curry(self.init)
            <^> json <| "value"
    }
    
    static func==(lhs: ModelStub, rhs: ModelStub) -> Bool {
        return lhs.value == rhs.value
    }
}

class ArgoMappingTests: XCTestCase {
    
    // MARK: Tests
    
    func testObjectIsMapped() {
        let object = createObject()
        
        // producer completes synchronously
        producer(for: object)
            .mapResponseArgo()
            .startWithResult { (result: Result<ModelStub, ErrorStub>) in
                XCTAssertEqual(result.value, object)
                XCTAssertNil(result.error)
        }
    }
    
    func testArrayOfObjectsIsMapped() {
        let numberOfObjects = Int(arc4random() % 20) + 10
        let objects = (0...numberOfObjects).map { _ in createObject() }
        
        // producer completes synchronously
        producer(for: objects)
            .mapResponseArgo()
            .startWithResult { (result: Result<[ModelStub], ErrorStub>) in
                XCTAssertEqual(result.value!, objects)
                XCTAssertNil(result.error)
        }
    }
    
    func testArrayOfObjectsError() {
        let numberOfObjects = Int(arc4random() % 20) + 10
        let objects = (0...numberOfObjects).map { _ in createObject() }
        
        // producer completes synchronously
        invalidProducer(for: objects)
            .mapResponseArgo()
            .startWithResult { (result: Result<[ModelStub], ErrorStub>) in
                XCTAssertNil(result.value)
                XCTAssertNotNil(result.error)
        }
    }
    
    func testObjectError() {
        let object = createObject()
        
        // producer completes synchronously
        invalidProducer(for: object)
            .mapResponseArgo()
            .startWithResult { (result: Result<ModelStub, ErrorStub>) in
                XCTAssertNil(result.value)
                XCTAssertNotNil(result.error)
        }
    }
    
    func testObjectWithRootKeyIsMapped() {
        let object = createObject()
        let key = "key"
        
        producer(for: object)
            .map { [key: $0] }
            .mapResponseArgo(rootKey: key)
            .startWithResult { (result: Result<ModelStub, ErrorStub>) in
                XCTAssertEqual(result.value, object)
                XCTAssertNil(result.error)
        }
    }
    
    func testArrayOfObjectsWithRootKeyIsMapped() {
        let numberOfObjects = Int(arc4random() % 20) + 10
        let objects = (0...numberOfObjects).map { _ in createObject() }
        let key = "key"
        
        // producer completes synchronously
        producer(for: objects)
            .map { [key: $0] }
            .mapResponseArgo(rootKey: key)
            .startWithResult { (result: Result<[ModelStub], ErrorStub>) in
                XCTAssertEqual(result.value!, objects)
                XCTAssertNil(result.error)
        }
    }
    
    func testObjectWithRootKeyError() {
        let object = createObject()
        let key = "key"
        
        invalidProducer(for: object)
            .map { [key: $0] }
            .mapResponseArgo(rootKey: key)
            .startWithResult { (result: Result<ModelStub, ErrorStub>) in
                XCTAssertNil(result.value)
                XCTAssertNotNil(result.error)
        }
    }
    
    func testArrayOfObjectsWithRootKeyError() {
        let numberOfObjects = Int(arc4random() % 20) + 10
        let objects = (0...numberOfObjects).map { _ in createObject() }
        let key = "key"
        
        // producer completes synchronously
        invalidProducer(for: objects)
            .map { [key: $0] }
            .mapResponseArgo(rootKey: key)
            .startWithResult { (result: Result<[ModelStub], ErrorStub>) in
                XCTAssertNil(result.value)
                XCTAssertNotNil(result.error)
        }
    }

    
    // MARK: Private helpers
    
    private func createObject() -> ModelStub {
        return ModelStub(value: Int(arc4random()))
    }
    
    private func producer(for object: ModelStub) -> SignalProducer<Any, ErrorStub> {
        return producer(for: [object]).map { ($0 as! [Any]).first! }
    }
    
    private func producer(for objects: [ModelStub]) -> SignalProducer<Any, ErrorStub> {
        return SignalProducer(value: objects.map{ $0.dictionary })
    }
    
    private func invalidProducer(for object: ModelStub) -> SignalProducer<Any, ErrorStub> {
        return invalidProducer(for: [object]).map { ($0 as! [Any]).first! }
    }
    
    private func invalidProducer(for objects: [ModelStub]) -> SignalProducer<Any, ErrorStub> {
        return SignalProducer(value: objects.map{ $0.invalidDictionary })
    }
}
