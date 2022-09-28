// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let rangeInputFeature = "RangeInputFeature"
let rangeInputFeatureTests = "RangeInputFeatureTests"

let package = Package(
    name: "JSONPlaceholderTCA",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: rangeInputFeature,
            targets: [rangeInputFeature]),
    ],
    dependencies: [
        //Architecture Framework
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.40.0")
    ],
    targets: [
        .target(
            name: rangeInputFeature,
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .testTarget(
            name: rangeInputFeatureTests,
            dependencies: [
                .byName(name: rangeInputFeature)
            ]),
    ]
)
