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
