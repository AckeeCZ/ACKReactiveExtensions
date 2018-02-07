import WebKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: WKWebView {
    /// Property which observes `estimatedProgress` of webView
    public var estimatedProgress: Property<CGFloat> {
        return Property(initial: CGFloat(base.estimatedProgress), then: signal(forKeyPath: "estimatedProgress").map { $0 as? CGFloat ?? 0 })
    }
    
    /// Property which observes `isLoading` of webView
    public var isLoading: Property<Bool> {
        return Property(initial: base.isLoading, then: signal(forKeyPath: "loading").filterMap { $0 as? Bool })
    }
}
