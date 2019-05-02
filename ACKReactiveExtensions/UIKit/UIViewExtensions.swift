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
        return Property(initial: base.isHidden, then: signal(for: \.isHidden))
    }
    
    /// Reactively set `transform`
    @available(*, deprecated, message: "Use [\\.transform] instead")
    public var transform: BindingTarget<CGAffineTransform> {
        return self[\.transform]
    }
    
    /// End editing reactively
    public var endEditing: BindingTarget<Void> {
        return makeBindingTarget { base, _ in
            base.endEditing(true)
        }
    }
    
    /// Property that represents `frame`
    public var frame: Property<CGRect> {
        return Property(initial: base.frame, then: signal(for: \.frame))
    }
    
    /// Property that represents `bounds`
    public var bounds: Property<CGRect> {
        return Property(initial: base.bounds, then: signal(for: \.bounds))
    }
}
