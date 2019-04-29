import ReactiveSwift

extension SignalProducer {
    /// Ignore errors and return SignalProducer that completes instead of error
    public func ignoreError() -> SignalProducer<Value, Never> {
        return flatMapError { _ in .empty }
    }
    
    /// Create interrupted producer
    public static func interrupted() -> SignalProducer<Value, Never> {
        return SignalProducer<Value, Never> { observer, _ in
            observer.sendInterrupted()
        }
    }
}

extension Signal {
    public static func interrupted() -> Signal<Value, Error> {
        return Signal<Value, Error> { observer, _ in
            observer.sendInterrupted()
        }
    }
}

extension SignalProducer where Value == Void, Error == Never {
    /// Perform side effect
    public static func sideEffect(actions: @escaping () -> ()) -> SignalProducer<(), Never> {
        return SignalProducer<(), Never> { sink, _ in
            actions()
            sink.sendCompleted()
        }
    }
}

extension SignalProducer {
    /**
     * Lazily evaluate a closure when SignalProducer starts
     *
     * The autoclosure can still retain self strongly. The compiler will warn you by requiring `self.`.
     * Dont ignore memory managment! 
     * If you need to capture self weekly (or unowned), you can't use autoclosure and must supply a full closure.
     *
     * - parameter lazyValue: Closure to be evaluated
     */
    public init(lazyValue: @autoclosure @escaping () -> Value) {
        self.init { observer, _ in
            observer.send(value: lazyValue())
            observer.sendCompleted()
        }
    }
}
