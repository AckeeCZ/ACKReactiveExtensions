//
//  UITextFieldExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 06/02/2018.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: UITextField {
    /// Binding that represents `textColor`
    @available(*, deprecated, renamed: "[\\.textColor]")
    public var textColor: BindingTarget<UIColor?> {
        return self[\.textColor]
    }
    
    /**
     * Property if field contains valid email
     *
     * Note that this wont fire on programmatic change of `.text`
     */
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
