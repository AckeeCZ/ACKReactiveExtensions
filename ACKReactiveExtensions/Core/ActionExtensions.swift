import ReactiveSwift

extension Action {
    /// Runs action with given input.
    ///
    /// If action is already executing it just binds to its values and errors.
    public func run(_ input: Input) -> SignalProducer<Output, Error> {
        let completed = SignalProducer(self.completed).map { Signal<Output, Error>.Event.completed }.take(first: 1)
        let error = SignalProducer(self.errors).map { Signal<Output, Error>.Event.failed($0) }.take(first: 1)
        let values = SignalProducer(self.values).map { Signal<Output, Error>.Event.value($0) }
        return SignalProducer.merge(values, completed, error).dematerialize()
            .on(started: { [weak self] in self?.apply(input).start() })
    }
}

extension Action where Input == Void {
    /// Runs action.
    ///
    /// If action is already executing it just binds to its values and errors.
    public func run() -> SignalProducer<Output, Error> {
        return run(())
    }
}
