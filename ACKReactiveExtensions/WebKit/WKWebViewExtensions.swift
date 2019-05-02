import WebKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: WKWebView {
    /// Property which observes `estimatedProgress` of webView
    public var estimatedProgress: Property<Double> {
        return Property(initial: base.estimatedProgress, then: signal(for: \.estimatedProgress))
    }
    
    /// Property which observes `isLoading` of webView
    public var isLoading: Property<Bool> {
        return Property(initial: base.isLoading, then: signal(for: \.isLoading))
    }
}
