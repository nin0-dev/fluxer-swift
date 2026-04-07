// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "fluxer-swift",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "FluxerSwift",
            targets: ["FluxerSwift"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.16.1"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "FluxerSwift",
            dependencies: [
                .product(name: "WebSocketKit", package: "websocket-kit")
            ]
        ),
        .executableTarget(
            name: "Example",
            dependencies: ["FluxerSwift"]
        )
    ]
)
