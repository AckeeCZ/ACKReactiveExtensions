//
//  UIImageViewExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 06/09/2018.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: UIImageView {
    @available(*, deprecated, message: "User signal(for: \\.image) instead")
    public var imageSignal: Signal<UIImage?, Never> {
        return signal(for: \.image)
    }
}
