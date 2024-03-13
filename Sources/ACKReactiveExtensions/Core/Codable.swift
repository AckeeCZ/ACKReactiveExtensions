import ReactiveSwift
import Foundation

/**
 * Protocol that allows creation of custom Decoding errors
 */
public protocol DecodingErrorCreatable: Error {

    /**
     * Create error containing passed `DecodingError`
     *
     * - parameter decodeError: `DecodingError` which should be wrapped
     */
    static func createDecodeError(_ decodingError: MappingError<DecodingError>) -> Self
}

public extension SignalProducer where Value == Data, Error: DecodingErrorCreatable {
    /// Decodes given `type` from received data using given `decoder`
    ///
    /// By default the `type` is inferred from return value
    func decode<ResultType: Decodable>(type: ResultType.Type = ResultType.self, using decoder: JSONDecoder = ACKReactiveExtensionsConfiguration.jsonDecoder) -> SignalProducer<ResultType, Error> {
        lift { $0.decode(type: type, using: decoder) }
    }
}

public extension Signal where Value == Data, Error: DecodingErrorCreatable {
    /// Decodes given `type` from received data using given `decoder`
    ///
    /// By default the `type` is inferred from return value, if no `decoder` is provided then `ACKReactiveExtensionsConfiguration.jsonDecoder` is used
    func decode<ResultType: Decodable>(type: ResultType.Type = ResultType.self, using decoder: JSONDecoder = ACKReactiveExtensionsConfiguration.jsonDecoder) -> Signal<ResultType, Error> {
        attemptMap { data -> Result<ResultType, Error> in
            if ACKReactiveExtensionsConfiguration.allowMappingOnMainThread == false {
                assert(Thread.current.isMainThread == false, "Mapping should not be performed on main thread!")
            }

            do {
                let decoded = try decoder.decode(ResultType.self, from: data)
                return .success(decoded)
            } catch let error as DecodingError {
                return .failure(Error.createDecodeError(.mapping(error)))
            } catch {
                return .failure(Error.createDecodeError(.generic(error)))
            }
        }
    }
}
