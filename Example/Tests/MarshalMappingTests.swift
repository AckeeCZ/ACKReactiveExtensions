//
//  MarshalMappingTests.swift
//  ACKReactiveExtensions
//
//  Created by Jakub Olejník on 06/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Result
import Marshal
import ReactiveSwift
import ACKReactiveExtensions

extension MarshalMappingTests.ModelStub: Unmarshaling {
    init(object: MarshaledObject) throws {
        value = try object.value(for: "value")
    }
}

class MarshalMappingTests: XCTestCase {
    struct ErrorStub: MarshalErrorCreatable {
        let marshalError: MarshalError
        
        static func createMarshalError(_ marshalError: MarshalError) -> ErrorStub {
            return ErrorStub(marshalError: marshalError)
        }
    }
    
    struct ModelStub: Equatable {
        let value: Int
        
        var dictionary: [String: Any] {
            return ["value": value]
        }
        
        var invalidDictionary: [String: Any] {
            return ["val": value]
        }
        
        static func==(lhs: ModelStub, rhs: ModelStub) -> Bool {
            return lhs.value == rhs.value
        }
    }
    
    // MARK: Tests
    
    func testObjectIsMapped() {
        let object = createObject()
        
        // producer completes synchronously
        producer(for: object)
            .mapResponse()
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
            .mapResponse()
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
            .mapResponse()
            .startWithResult { (result: Result<[ModelStub], ErrorStub>) in
                XCTAssertNil(result.value)
                XCTAssertNotNil(result.error)
        }
    }
    
    func testObjectError() {
        let object = createObject()
        
        // producer completes synchronously
        invalidProducer(for: object)
            .mapResponse()
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
            .mapResponse(forKey: key)
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
            .mapResponse(forKey: key)
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
            .mapResponse(forKey: key)
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
            .mapResponse(forKey: key)
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
