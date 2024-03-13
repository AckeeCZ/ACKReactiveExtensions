// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ACKReactiveExtensions",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "ACKReactiveExtensions",
            targets: ["ACKReactiveExtensions"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ReactiveCocoa/ReactiveCocoa",
            from: "12.0.0"
        ),
        .package(
            url: "https://github.com/ReactiveCocoa/ReactiveSwift",
            from: "7.1.1"
        ),
    ],
    targets: [
        .target(
            name: "ACKReactiveExtensions",
            dependencies: [
                .product(
                    name: "ReactiveSwift",
                    package: "ReactiveSwift"
                ),
                .product(
                    name: "ReactiveCocoa",
                    package: "ReactiveCocoa"
                )
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
