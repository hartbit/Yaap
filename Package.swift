// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Yaap",
    platforms: [.macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)],
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
