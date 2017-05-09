//
//  ConfigurationTests.swift
//  ACKReactiveExtensions
//
//  Created by Jakub Olejník on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import ACKReactiveExtensions

class ConfigurationTests: XCTestCase {
    
    func testMainThreadMappingIsAllowedByDefault() {
        XCTAssert(ACKReactiveExtensionsConfiguration.allowMappingOnMainThread)
    }
    
}

