import ReactiveSwift

extension Action {
    /// Runs action with given input.
    ///
    /// If action is already executing it just binds to its values and errors.
    public func run(_ input: Input) -> SignalProducer<Output, Error> {
        return events.dematerialize().producer.on(started: { [weak self] in self?.apply(input).start() })
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
