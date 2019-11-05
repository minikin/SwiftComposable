// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftComposable",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SwiftComposable",
            targets: ["SwiftComposable"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftComposable",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftComposableTests",
            dependencies: ["SwiftComposable"]
        ),
    ]
)
