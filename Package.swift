// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Sample",
    products: [
        .library(
            name: "Sample",
            targets: ["Sample"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Sample",
            dependencies: []),
        .testTarget(
            name: "SampleTests",
            dependencies: ["Sample"]),
    ]
)
