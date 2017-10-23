import WebKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: WKWebView {
    /// Property which observes estimated progress of request load
    public var estimatedProgress: Property<CGFloat> {
        return Property(initial: CGFloat(base.estimatedProgress), then: signal(forKeyPath: "estimatedProgress").map { $0 as? CGFloat ?? 0 })
    }
}

private enum WebKitKeys {
    static var estimatedProgress = UInt8(0)
}
