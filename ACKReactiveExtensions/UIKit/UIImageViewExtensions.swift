//
//  UIImageViewExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 06/09/2018.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: UIImageView {
    public var imageSignal: Signal<UIImage?, Never> {
        return signal(forKeyPath: "image").map { $0 as? UIImage }
    }
}
