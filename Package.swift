// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Yaap",
    platforms: [.macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)],
    products: [
        .library(
            name: "Yaap",
            targets: ["Yaap"]),
        .library(
            name: "YaapBinary", targets: ["YaapBinary"]),
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
            dependencies: ["Yaap"]),
        ._binaryTarget(
            name: "YaapBinary",
            url: "https://user.fm/files/v2-9eeb943dc13e8f38f72997d1e24db5c5/YaapBinary.zip",
            checksum: "c03ee54701fc2e7f6e4eebbec8091c17a3904fa3394c23d37da2325c29b06d5c"),
    ],
    swiftLanguageVersions: [.v5]
)
