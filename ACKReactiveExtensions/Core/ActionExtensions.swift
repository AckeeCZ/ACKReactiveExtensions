import ReactiveSwift

extension Action {
    /// Runs action with given input.
    ///
    /// If action is already executing it just binds to its values and errors.
    public func run(_ input: Input) -> SignalProducer<Output, Error> {
        let events = self.events
        var disposable: Disposable? = nil
        return Property.combineLatest(isExecuting, isEnabled).producer.take(first: 1)
            .flatMap(.latest) { isExecuting, isEnabled -> SignalProducer<Output, Error> in
                switch (isExecuting, isEnabled) {
                case (true, _): return events.dematerialize().producer
                case (false, false): return SignalProducer<Output, Error>.interrupted()
                case (false, true): return events.dematerialize().producer
                }
            }
            .on(started: { [weak self] in disposable = self?.apply(input).start() },
                disposed: { disposable?.dispose() })
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
