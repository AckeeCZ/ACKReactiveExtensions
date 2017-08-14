//
//  TextFieldBindingTests.swift
//  ACKReactiveExtensions
//
//  Created by Jakub Olejník on 28/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
import ReactiveSwift
import ACKReactiveExtensions

final class TextFieldBindingTests: XCTestCase {
    
    func testTextFieldPropertyBinding() {
        let property = MutableProperty(String.random(length: 10))
        let textField = UITextField()
        
        textField <~> property
        
        XCTAssertEqual(textField.text, property.value)
        
        textField.text = String.random(length: 8)
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.text, property.value)
        
        property.value = String.random(length: 12)
        
        XCTAssertEqual(textField.text, property.value)
    }
    
    func testTextFieldPropertyBindingCommutative() {
        let property = MutableProperty(String.random(length: 10))
        let textField = UITextField()
        
        property <~> textField
        
        XCTAssertEqual(textField.text, property.value)
        
        textField.text = String.random(length: 8)
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.text, property.value)
        
        property.value = String.random(length: 12)
        
        XCTAssertEqual(textField.text, property.value)
    }
    
    func testTextFieldOptionalPropertyBinding() {
        let property = MutableProperty<String?>(String.random(length: 10))
        let textField = UITextField()
        
        textField <~> property
        
        XCTAssertEqual(textField.text, property.value)
        
        textField.text = String.random(length: 8)
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.text, property.value)
        
        property.value = String.random(length: 12)
        
        XCTAssertEqual(textField.text, property.value)
    }
    
    func testTextFieldOptionalPropertyBindingCommutative() {
        let property = MutableProperty<String?>(String.random(length: 10))
        let textField = UITextField()
        
        property <~> textField
        
        XCTAssertEqual(textField.text, property.value)
        
        textField.text = String.random(length: 8)
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.text, property.value)
        
        property.value = String.random(length: 12)
        
        XCTAssertEqual(textField.text, property.value)
    }
    
    func testTextViewPropertyBinding() {
        let property = MutableProperty(String.random(length: 10))
        let textView = UITextView()
        
        textView <~> property
        
        XCTAssertEqual(textView.text, property.value)
        
        textView.text = String.random(length: 8)
        NotificationCenter.default.post(name: .UITextViewTextDidChange, object: textView)
        
        XCTAssertEqual(textView.text, property.value)
        
        property.value = String.random(length: 12)
        
        XCTAssertEqual(textView.text, property.value)
    }
    
    func testTextViewPropertyBindingCommutative() {
        let property = MutableProperty(String.random(length: 10))
        let textView = UITextView()
        
        property <~> textView
        
        XCTAssertEqual(textView.text, property.value)
        
        textView.text = String.random(length: 8)
        NotificationCenter.default.post(name: .UITextViewTextDidChange, object: textView)
        
        XCTAssertEqual(textView.text, property.value)
        
        property.value = String.random(length: 12)
        
        XCTAssertEqual(textView.text, property.value)
    }
    
    func testTextViewOptionalPropertyBinding() {
        let property = MutableProperty<String?>(String.random(length: 10))
        let textView = UITextView()
        
        textView <~> property
        
        XCTAssertEqual(textView.text, property.value)
        
        textView.text = String.random(length: 8)
        NotificationCenter.default.post(name: .UITextViewTextDidChange, object: textView)
        
        XCTAssertEqual(textView.text, property.value)
        
        property.value = String.random(length: 12)
        
        XCTAssertEqual(textView.text, property.value)
    }
    
    func testTextViewOptionalPropertyBindingCommutative() {
        let property = MutableProperty<String?>(String.random(length: 10))
        let textView = UITextView()
        
        property <~> textView
        
        XCTAssertEqual(textView.text, property.value)
        
        textView.text = String.random(length: 8)
        NotificationCenter.default.post(name: .UITextViewTextDidChange, object: textView)
        
        XCTAssertEqual(textView.text, property.value)
        
        property.value = String.random(length: 12)
        
        XCTAssertEqual(textView.text, property.value)
    }
}
