//
//  UIControlExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 06/02/2018.
//

import UIKit
import Result
import ReactiveSwift

extension Reactive where Base: UIControl {
    var valueChanged: Signal<Base, NoError> {
        return controlEvents(.valueChanged)
    }
}
