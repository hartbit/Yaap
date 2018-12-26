// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Yaap",
    products: [
        .library(
            name: "Yaap",
            targets: ["Yaap"]),
    ],
    targets: [
        .target(
            name: "Yaap",
            dependencies: []),
        .testTarget(
            name: "YaapTests",
            dependencies: ["Yaap"]),
    ]
)
