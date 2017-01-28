import WebKit
import ReactiveSwift
import ReactiveCocoa
import ACKReactiveExtensions

extension Reactive where Base: WKWebView {
    public var estimatedProgress: Property<CGFloat> {
        return Property(base.rac_estimatedProgress.map { $0 ?? 0 })
    }
}

private enum WebKitKeys {
    static var estimatedProgress = UInt8(0)
}

extension WKWebView {

    /**
     * Property which observes estimated progress of request load.
     */
    @available(*, deprecated, renamed: "reactive.estimatedProgress")
    public var rac_estimatedProgress: DynamicProperty<CGFloat> {
        return lazyAssociatedProperty(self, &WebKitKeys.estimatedProgress, factory: { [unowned self] _ in
            return DynamicProperty<CGFloat>(object: self, keyPath: "estimatedProgress")
        })
    }
}
