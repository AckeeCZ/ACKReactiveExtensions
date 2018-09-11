//
//  UIImageViewExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 06/09/2018.
//

import UIKit
import ReactiveSwift
import enum Result.NoError

extension Reactive where Base: UIImageView {
    public var imageSignal: Signal<UIImage?, NoError> {
        return signal(forKeyPath: "image").map { $0 as? UIImage }
    }
}
