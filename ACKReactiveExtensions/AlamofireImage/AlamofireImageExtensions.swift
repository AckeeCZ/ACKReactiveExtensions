//
//  AlamofireImageExtensions.swift
//  AlamofireImage
//
//  Created by Jakub Olejník on 15/04/2018.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import AlamofireImage

extension Reactive where Base: UIImageView {
    public var imageURL: BindingTarget<URL> {
        return makeBindingTarget { $0.af_setImage(withURL: $1) }
    }
}
