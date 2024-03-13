// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ACKReactiveExtensions",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "ACKReactiveExtensionsCore",
            targets: ["ACKReactiveExtensionsCore"]
        ),
        .library(
            name: "ACKReactiveExtensionsUIKit",
            targets: ["ACKReactiveExtensionsUIKit"]
        ),
        .library(
            name: "ACKReactiveExtensionsWebKit",
            targets: ["ACKReactiveExtensionsWebKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ReactiveCocoa/ReactiveCocoa",
            .upToNextMajor(
                from: "12.0.0"
            )
        ),
        .package(
            url: "https://github.com/ReactiveCocoa/ReactiveSwift",
            .upToNextMajor(
                from: "7.0.0"
            )
        ),
    ],
    targets: [
        .target(
            name: "ACKReactiveExtensionsCore",
            dependencies: [
                .product(
                    name: "ReactiveSwift",
                    package: "ReactiveSwift"
                ),
                .product(
                    name: "ReactiveCocoa",
                    package: "ReactiveCocoa"
                )
            ],
            path: "ACKReactiveExtensions/Core"
        ),
        .target(
            name: "ACKReactiveExtensionsUIKit",
            dependencies: [
                "ACKReactiveExtensionsCore"
            ],
            path: "ACKReactiveExtensions/UIKit"
        ),
        .target(
            name: "ACKReactiveExtensionsWebKit",
            dependencies: [
                "ACKReactiveExtensionsCore"
            ],
            path: "ACKReactiveExtensions/WebKit"
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
