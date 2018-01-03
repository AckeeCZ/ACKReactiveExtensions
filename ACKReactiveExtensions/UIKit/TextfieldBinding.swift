//
//  TextFieldBinding.swift
//  Pods
//
//  Created by Jakub Olejník on 28/06/2017.
//
//

import UIKit
import ReactiveSwift

infix operator <~> : BindingPrecedence

/// Binds given `property` to continousValues of given `textField`
public func <~> (property: MutableProperty<String?>, textField: UITextField) {
    textField.reactive.text <~ property.producer.skipRepeats()
    property <~ textField.reactive.continuousTextValues
}

/// Binds given `property` to continousValues of given `textField`
public func <~> (textField: UITextField, property: MutableProperty<String?>) {
    textField.reactive.text <~ property.producer.skipRepeats()
    property <~ textField.reactive.continuousTextValues
}

/// Binds given `property` to continousValues of given `textField`
/// If `textField` sends `nil` value then it is mapped to an empty string
public func <~> (property: MutableProperty<String>, textField: UITextField) {
    textField.reactive.text <~ property.producer.skipRepeats()
    property <~ textField.reactive.continuousTextValues.map { $0 ?? "" }
}

/// Binds given `property` to continousValues of given `textField`
/// If `textField` sends `nil` value then it is mapped to an empty string
public func <~> (textField: UITextField, property: MutableProperty<String>) {
    textField.reactive.text <~ property.producer.skipRepeats()
    property <~ textField.reactive.continuousTextValues.map { $0 ?? "" }
}

/// Binds given `property` to continousValues of given `textView`
public func <~> (property: MutableProperty<String?>, textView: UITextView) {
    textView.reactive.text <~ property.producer.skipRepeats()
    property <~ textView.reactive.continuousTextValues
}

/// Binds given `property` to continousValues of given `textView`
public func <~> (textView: UITextView, property: MutableProperty<String?>) {
    textView.reactive.text <~ property.producer.skipRepeats()
    property <~ textView.reactive.continuousTextValues
}

/// Binds given `property` to continousValues of given `textView`
/// If `textView` sends `nil` value then it is mapped to an empty string
public func <~> (textView: UITextView, property: MutableProperty<String>) {
    textView.reactive.text <~ property.producer.skipRepeats()
    property <~ textView.reactive.continuousTextValues.map { $0 ?? "" }
}

/// Binds given `property` to continousValues of given `textView`
/// If `textView` sends `nil` value then it is mapped to an empty string
public func <~> (property: MutableProperty<String>, textView: UITextView) {
    textView.reactive.text <~ property.producer.skipRepeats()
    property <~ textView.reactive.continuousTextValues.map { $0 ?? "" }
}
