//
//  UIControlExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 06/02/2018.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: UIControl {
    public var valueChanged: Signal<Base, Never> {
        return controlEvents(.valueChanged)
    }
}
