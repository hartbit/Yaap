// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "CLI",
    products: [
        .library(
            name: "CLI",
            targets: ["CLI"]),
    ],
    targets: [
        .target(
            name: "CLI",
            dependencies: []),
        .testTarget(
            name: "CLITests",
            dependencies: ["CLI"]),
    ]
)
