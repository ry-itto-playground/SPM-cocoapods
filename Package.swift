// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Sample",
    products: [
        .library(
            name: "SampleLib",
            type: .dynamic,
            targets: ["SampleLib"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SampleLib",
            dependencies: [
                .target(name: "RxSwift"),
            ]),
        .testTarget(
            name: "SampleTests",
            dependencies: ["SampleLib"]),
        .binaryTarget(
            name: "RxSwift",
            path: "build/RxSwift.xcframework"
        )
    ]
)
