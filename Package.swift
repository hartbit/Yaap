// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Commandable",
    products: [
        .library(
            name: "Commandable",
            targets: ["Commandable"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Commandable",
            dependencies: []),
        .testTarget(
            name: "CommandableTests",
            dependencies: ["Commandable"]),
    ]
)
