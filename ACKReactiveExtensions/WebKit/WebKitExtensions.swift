import WebKit
import ReactiveCocoa
import ACKReactiveExtensions

private enum WebKitKeys {
    static var estimatedProgress = UInt8(0)
}

extension WKWebView {

    /**
     * Property which observes estimated progress of request load.
     */
    public var rac_estimatedProgress: DynamicProperty {
        return lazyAssociatedProperty(self, &WebKitKeys.estimatedProgress, factory: { [unowned self] _ in
            return DynamicProperty(object: self, keyPath: "estimatedProgress")
        })
    }
}