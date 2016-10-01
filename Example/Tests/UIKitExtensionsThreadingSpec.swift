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
                let setter: (Bool) -> () = { new in
                    expect(Thread.current.isMainThread).to(beTrue())
                    host.isHidden = new
                }
                let getter: (Void) -> Bool = { return host.isHidden }

                it("called from main thread") {
                    expect(Thread.current.isMainThread).to(beTrue())

                    let property = lazyMutablePropertyUiKit(host, &key, setter, getter)

                    property.value = !host.isHidden
                }

                it("called from background thread") {
                    let property = lazyMutablePropertyUiKit(host, &key, setter, getter)
                    let newValue = !host.isHidden
                    
                    DispatchQueue.global().async {
                        expect(Thread.current.isMainThread).to(beFalse())
                        
                        property.value = newValue
                    }

                    expect(property.value).toEventually(be(newValue))
                }
            }
        }
    }
}
