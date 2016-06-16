import Quick
import Nimble
import ReactiveCocoa
@testable import ACKReactiveExtensions

class UIKitExtensionsThreadingSpec: QuickSpec {

    override func spec() {
        describe("check whether property setters are called on main thread") {
            context("if") {
                let host = UIView()
                var key = 0
                let setter: Bool -> () = { new in
                    expect(NSThread.currentThread().isMainThread).to(beTrue())
                    host.hidden = new
                }
                let getter: Void -> Bool = { return host.hidden }

                it("called from main thread") {
                    expect(NSThread.currentThread().isMainThread).to(beTrue())

                    let property = lazyMutablePropertyUiKit(host, &key, setter, getter)

                    property.value = !host.hidden
                }

                it("called from background thread") {
                    let property = lazyMutablePropertyUiKit(host, &key, setter, getter)
                    let newValue = !host.hidden

                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                        expect(NSThread.currentThread().isMainThread).to(beFalse())

                        property.value = newValue
                    }

                    expect(property.value).toEventually(be(newValue))
                }
            }
        }
    }
}
