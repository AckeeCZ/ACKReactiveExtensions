import Quick
import Nimble
import ReactiveCocoa
@testable import ACKReactiveExtensions

class UIKitExtensionsThreadingSpec: QuickSpec {

    override func spec() {
        let host = UIView()
        var key: UInt8 = 1

        describe("check whether property setters are called on main thread") {
            let property: MutableProperty<Bool> = lazyMutablePropertyUiKit(host, &key, { _ in
                expect(NSThread.currentThread().isMainThread).to(beTrue())
            }) { _ in
                expect(NSThread.currentThread().isMainThread).to(beTrue())
                return true
            }

            context("if") {
                it("it called from main thread") {
                    if NSThread.currentThread().isMainThread {
                        property.value = !property.value
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue()) {
                            property.value = !property.value
                            expect(true).to(beTrue())
                        }
                    }
                }
            }

            it("if called from background thread") {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    expect(NSThread.currentThread().isMainThread).to(beFalse())
                    property.value = !property.value
                }
            }
        }
    }
}
