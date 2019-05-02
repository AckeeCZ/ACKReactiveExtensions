//
//  UITableViewExtensions.swift
//  UIKit
//
//  Created by Jakub Olejník on 15/04/2018.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: UITableView {
    /// Reactively set `tableHeaderView`
    @available(*, deprecated, message: "Use [\\.tableHeaderView] instead")
    public var tableHeaderView: BindingTarget<UIView?> {
        return self[\.tableHeaderView]
    }
    
    /// Reactively set `tableFooterView`
    @available(*, deprecated, message: "Use [\\.tableFooterView] instead")
    public var tableFooterView: BindingTarget<UIView?> {
        return self[\.tableFooterView]
    }
}
