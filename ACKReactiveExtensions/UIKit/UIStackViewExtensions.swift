//
//  UIStackViewExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 06/02/2018.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

@available(iOS 9.0, *)
extension Reactive where Base: UIStackView {
    
    /// Switch arranged subviews reactively
    public var arrangedSubviews: BindingTarget<[UIView]> {
        return makeBindingTarget { base, views in
            base.arrangedSubviews.forEach {
                base.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            
            views.forEach { base.addArrangedSubview($0) }
        }
    }
}
