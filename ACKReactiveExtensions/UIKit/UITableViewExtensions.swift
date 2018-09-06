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
    public var tableHeaderView: BindingTarget<UIView?> {
        return makeBindingTarget { $0.tableHeaderView = $1 }
    }
    
    /// Reactively set `tableFooterView`
    public var tableFooterView: BindingTarget<UIView?> {
        return makeBindingTarget { $0.tableFooterView = $1 }
    }
}
