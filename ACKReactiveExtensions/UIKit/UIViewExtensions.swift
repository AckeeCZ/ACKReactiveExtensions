//
//  UIViewExtensions.swift
//  Core
//
//  Created by Jakub Olejník on 06/02/2018.
//

import UIKit
import Result
import ReactiveSwift

extension Reactive where Base: UIView {
    /// Property that represents `isHidden`
    public var isHiddenProperty: Property<Bool> {
        return Property(initial: base.isHidden, then: isHiddenSignal)
    }
    
    private var isHiddenSignal: Signal<Bool, NoError> {
        return signal(forKeyPath: "hidden").map { $0 as? Bool }.skipNil()
    }
    
    /// Reactively set `transform`
    public var transform: BindingTarget<CGAffineTransform> {
        return makeBindingTarget { $0.transform = $1 }
    }
}
