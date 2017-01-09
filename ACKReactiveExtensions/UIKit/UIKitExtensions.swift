//
//  Util.swift
//  ReactiveTwitterSearch
//
//  Created by Colin Eberhardt on 10/05/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

extension Reactive where Base: UIView {
    public var tintColor: BindingTarget<UIColor?> {
        return makeBindingTarget { $0.tintColor = $1 }
    }
    public var backgroundColor: BindingTarget<UIColor?> {
        return makeBindingTarget { $0.backgroundColor = $1 }
    }
}
extension Reactive where Base: CALayer {
    public var borderWidth: BindingTarget<CGFloat> {
        return makeBindingTarget { $0.borderWidth = $1 }
    }
    public var borderColor: BindingTarget<CGColor> {
        return makeBindingTarget { $0.borderColor = $1 }
    }
}

extension Reactive where Base: UINavigationItem {
    public var title: BindingTarget<String?> {
        return makeBindingTarget { $0.title = $1 }
    }
}

extension Reactive where Base: UITextField {
    public var textColor: BindingTarget<UIColor?> {
        return makeBindingTarget { $0.textColor = $1 }
    }
    //note that this wont fire on programmatic change of .text
    public var containsValidEmail: Property<Bool> {
        return Property(initial: base.text, then: continuousTextValues)
            .map { $0.map { $0.isValidEmail } ?? false }
    }
}

//we have an `containsValidEmail` extension on UITextField, which used to contained this logic. I refactored it out into a String extension, but theres nothing "reactive" about it, so its fileprivate.
extension String {
    fileprivate var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

