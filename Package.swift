// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ACKReactiveExtensions",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(name: "ACKReactiveExtensionsCore", targets: ["ACKReactiveExtensionsCore"]),
        .library(name: "ACKReactiveExtensionsUIKit", targets: ["ACKReactiveExtensionsUIKit"]),
        .library(name: "ACKReactiveExtensionsWebKit", targets: ["ACKReactiveExtensionsWebKit"]),
        .library(name: "ACKReactiveExtensionsAlamofireImage", targets: ["ACKReactiveExtensionsAlamofireImage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/AlamofireImage", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa", .upToNextMajor(from: "12.0.0")),
        .package(url: "https://github.com/ReactiveCocoa/ReactiveSwift", .upToNextMajor(from: "7.0.0")),
    ],
    targets: [
        .target(name: "ACKReactiveExtensionsAlamofireImage", dependencies: [
            .target(name: "ACKReactiveExtensionsCore"),
            .product(name: "AlamofireImage", package: "AlamofireImage")], path: "ACKReactiveExtensions/AlamofireImage"),
        .target(name: "ACKReactiveExtensionsCore", dependencies: [
            .product(name: "ReactiveSwift", package: "ReactiveSwift"),
            .product(name: "ReactiveCocoa", package: "ReactiveCocoa")], path: "ACKReactiveExtensions/Core"),
        .target(name: "ACKReactiveExtensionsUIKit", dependencies: [.target(name: "ACKReactiveExtensionsCore")], path: "ACKReactiveExtensions/UIKit"),
        .target(name: "ACKReactiveExtensionsWebKit", dependencies: [.target(name: "ACKReactiveExtensionsCore")], path: "ACKReactiveExtensions/WebKit"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
