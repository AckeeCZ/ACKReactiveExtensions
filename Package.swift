// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ACKReactiveExtensions",
    platforms: [
        .iOS(.v11) // Realm requires iOS 11 for SwiftPM distribution 🤷‍♂️
    ],
    products: [
        .library(name: "ACKReactiveExtensionsCore", targets: ["ACKReactiveExtensionsCore"]),
        .library(name: "ACKReactiveExtensionsUIKit", targets: ["ACKReactiveExtensionsUIKit"]),
        .library(name: "ACKReactiveExtensionsWebKit", targets: ["ACKReactiveExtensionsWebKit"]),
        .library(name: "ACKReactiveExtensionsMarshal", targets: ["ACKReactiveExtensionsMarshal"]),
        .library(name: "ACKReactiveExtensionsRealm", targets: ["ACKReactiveExtensionsRealm"]),
        .library(name: "ACKReactiveExtensionsAlamofireImage", targets: ["ACKReactiveExtensionsAlamofireImage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/AlamofireImage", .upToNextMajor(from: "3.3.0")),
        .package(url: "https://github.com/utahiosmac/Marshal", .upToNextMajor(from: "1.2.8")),
        .package(url: "https://github.com/realm/realm-cocoa", .upToNextMajor(from: "10.5.0")),
        .package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa", .upToNextMajor(from: "11.1.0")),
        .package(url: "https://github.com/ReactiveCocoa/ReactiveSwift", .upToNextMajor(from: "6.5.0")),
    ],
    targets: [
        .target(name: "ACKReactiveExtensionsAlamofireImage", dependencies: [
            .target(name: "ACKReactiveExtensionsCore"),
            .product(name: "AlamofireImage", package: "AlamofireImage")], path: "ACKReactiveExtensions/AlamofireImage"),
        .target(name: "ACKReactiveExtensionsCore", dependencies: [
            .product(name: "ReactiveSwift", package: "ReactiveSwift"),
            .product(name: "ReactiveCocoa", package: "ReactiveCocoa")], path: "ACKReactiveExtensions/Core"),
        .target(name: "ACKReactiveExtensionsMarshal", dependencies: [
            .target(name: "ACKReactiveExtensionsCore"),
            .product(name: "Marshal", package: "Marshal")], path: "ACKReactiveExtensions/Marshal"),
        .target(name: "ACKReactiveExtensionsRealm", dependencies: [
            .target(name: "ACKReactiveExtensionsCore"),
            .product(name: "RealmSwift", package: "Realm")], path: "ACKReactiveExtensions/Realm"),
        .target(name: "ACKReactiveExtensionsUIKit", dependencies: [.target(name: "ACKReactiveExtensionsCore")], path: "ACKReactiveExtensions/UIKit"),
        .target(name: "ACKReactiveExtensionsWebKit", dependencies: [.target(name: "ACKReactiveExtensionsCore")], path: "ACKReactiveExtensions/WebKit"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
