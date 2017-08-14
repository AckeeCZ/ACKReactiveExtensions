//
//  TestHelpers.swift
//  ACKReactiveExtensions
//
//  Created by Jakub Olejník on 06/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest

extension XCTestCase {
    func async(timeout: TimeInterval = 1.0, testBlock: ((XCTestExpectation) -> ())) {
        let expectation = self.expectation(description: "")
        testBlock(expectation)
        waitForExpectations(timeout: timeout, handler: {
            if let error = $0 { XCTFail(error.localizedDescription) }
        })
    }
}

extension String {
    static func random(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
