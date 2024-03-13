import UIKit
import ReactiveSwift

extension Reactive where Base: UIViewController {
    /// End editing on `view` reactively
    public var endEditing: BindingTarget<Void> {
        return base.view.reactive.endEditing
    }
}
