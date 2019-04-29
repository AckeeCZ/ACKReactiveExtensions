//
//  UIViewExtensions.swift
//  Core
//
//  Created by Jakub Olejník on 06/02/2018.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: UIView {
    /// Property that represents `isHidden`
    public var isHiddenProperty: Property<Bool> {
        return Property(initial: base.isHidden, then: isHiddenSignal)
    }
    
    private var isHiddenSignal: Signal<Bool, Never> {
        return signal(forKeyPath: "hidden").map { $0 as? Bool }.skipNil()
    }
    
    /// Reactively set `transform`
    public var transform: BindingTarget<CGAffineTransform> {
        return makeBindingTarget { $0.transform = $1 }
    }
    
    /// End editing reactively
    public var endEditing: BindingTarget<Void> {
        return makeBindingTarget { base, _ in
            base.endEditing(true)
        }
    }
    
    /// Property that represents `frame`
    public var frame: Property<CGRect> {
        return Property(initial: base.frame, then: frameSignal)
    }
    
    /// Property that represents `bounds`
    public var bounds: Property<CGRect> {
        return Property(initial: base.bounds, then: boundsSignal)
    }
    
    private var frameSignal: Signal<CGRect, Never> {
        return signal(forKeyPath: "frame").filterMap { $0 as? CGRect }
    }
    
    private var boundsSignal: Signal<CGRect, Never> {
        return signal(forKeyPath: "bounds").filterMap { $0 as? CGRect }
    }
}
