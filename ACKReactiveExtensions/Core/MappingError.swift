//
//  MappingError.swift
//  Core
//
//  Created by Jakub Olejník on 03.09.2020.
//

import Foundation

/// Error thrown from mapping extensions
///
/// As various mapping frameworks (in our case Marshal and Codable) use different errors,
/// this error should wrap that concrete error
public enum MappingError<MappingErrorType: Error>: Error {
    /// Error occured because in mapping
    case mapping(MappingErrorType)
    /// Other internal error, generally all errors which are not `MappingErrorType`s will match this case
    case generic(Error)
}
