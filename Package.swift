// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TTextField",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "TTextField",
            targets: ["TTextField"]),
    ],
    targets: [
        .target(
            name: "TTextField",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "TTextFieldTests",
            dependencies: ["TTextField"]),
    ],
    swiftLanguageVersions: [.v5]
)
