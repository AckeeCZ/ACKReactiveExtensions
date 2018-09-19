//
//  CALayerExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 06/02/2018.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: CALayer {
    /// Binding that represents `borderWidth`
    public var borderWidth: BindingTarget<CGFloat> {
        return makeBindingTarget { $0.borderWidth = $1 }
    }
    
    /// Binding that represents `borderColor`
    public var borderColor: BindingTarget<CGColor> {
        return makeBindingTarget { $0.borderColor = $1 }
    }
    
    /// Binding that represents `cornerRadius`
    public var cornerRadius: BindingTarget<CGFloat> {
        return makeBindingTarget { $0.cornerRadius = $1 }
    }
}
