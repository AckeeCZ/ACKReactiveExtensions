import Foundation

/// Configuration for **ACKReactiveExtensions**
public enum ACKReactiveExtensionsConfiguration {

    /// If `true`, *Marshal* and *Codable* extensions use assert that checks if mapping is done in background
    public static var allowMappingOnMainThread = true

    /// Default decoder that is used for *Codable* extensions
    public static var jsonDecoder = JSONDecoder()
}
