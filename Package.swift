// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Commendable",
    products: [
        .library(
            name: "Commendable",
            targets: ["Commendable"]),
    ],
    targets: [
        .target(
            name: "Commendable",
            dependencies: []),
        .testTarget(
            name: "CommendableTests",
            dependencies: ["Commendable"]),
    ]
)
