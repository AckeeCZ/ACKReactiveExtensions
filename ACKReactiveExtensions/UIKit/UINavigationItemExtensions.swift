//
//  UINavigationItemExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 06/02/2018.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: UINavigationItem {
    /// Binding that represents `rightBarButtonItem`
    public var rightBarButtonItem: BindingTarget<UIBarButtonItem?> {
        return makeBindingTarget { $0.rightBarButtonItem = $1 }
    }
    
    /// Binding that represents `rightBarButtonItems`
    public var rightBarButtonItems: BindingTarget<[UIBarButtonItem]?> {
        return makeBindingTarget { $0.rightBarButtonItems = $1 }
    }
    
    /// Binding that represents `leftBarButtonItem`
    public var leftBarButtonItem: BindingTarget<UIBarButtonItem?> {
        return makeBindingTarget { $0.leftBarButtonItem = $1 }
    }
    
    /// Binding that represents `leftBarButtonItems`
    public var leftBarButtonItems: BindingTarget<[UIBarButtonItem]?> {
        return makeBindingTarget { $0.leftBarButtonItems = $1 }
    }
}
