// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Yaap",
    products: [
        .library(
            name: "Yaap",
            targets: ["Yaap"])
    ],
    targets: [
        .target(
            name: "Yaap",
            dependencies: []),
        .target(
            name: "YaapExample",
            dependencies: ["Yaap"]),
        .testTarget(
            name: "YaapTests",
            dependencies: ["Yaap"])
    ],
    swiftLanguageVersions: [.v5]
)
