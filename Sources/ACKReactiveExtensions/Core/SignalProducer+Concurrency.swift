import ReactiveSwift

@available(iOS 13.0, *)
public extension SignalProducer {
    /// Run async operation as SignalProducer
    /// - Parameter operation: Operation to be run
    init(operation: @escaping () async -> Result<Value, Error>) {
        self.init { observer, lifetime in
            let task = Task {
                switch await operation() {
                case .success(let value):
                    observer.send(value: value)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error)
                }
            }

            lifetime.observeEnded {
                task.cancel()
            }
        }
    }

    /// Run async operation as SignalProducer
    /// - Parameter operation: Operation to be run
    init(operation: @escaping () async -> Value) where Error == Never {
        self.init { observer, lifetime in
            let task = Task {
                observer.send(value: await operation())
                observer.sendCompleted()
            }

            lifetime.observeEnded {
                task.cancel()
            }
        }
    }
}
