//
//  TextfieldBinding.swift
//  Pods
//
//  Created by Jakub Olejník on 28/06/2017.
//
//

import ReactiveSwift

infix operator <~> : BindingPrecedence

public func <~> (property: MutableProperty<String?>, textField: UITextField) {
    textField.reactive.text <~ property
    property <~ textField.reactive.continuousTextValues
}

public func <~> (textField: UITextField, property: MutableProperty<String?>) {
    textField.reactive.text <~ property
    property <~ textField.reactive.continuousTextValues
}

public func <~> (property: MutableProperty<String>, textField: UITextField) {
    textField.reactive.text <~ property
    property <~ textField.reactive.continuousTextValues.map { $0 ?? "" }
}

public func <~> (textField: UITextField, property: MutableProperty<String>) {
    textField.reactive.text <~ property
    property <~ textField.reactive.continuousTextValues.map { $0 ?? "" }
}

public func <~> (property: MutableProperty<String?>, textField: UITextView) {
    textField.reactive.text <~ property
    property <~ textField.reactive.continuousTextValues
}

public func <~> (textField: UITextView, property: MutableProperty<String?>) {
    textField.reactive.text <~ property
    property <~ textField.reactive.continuousTextValues
}

public func <~> (textField: UITextView, property: MutableProperty<String>) {
    textField.reactive.text <~ property
    property <~ textField.reactive.continuousTextValues.map { $0 ?? "" }
}
