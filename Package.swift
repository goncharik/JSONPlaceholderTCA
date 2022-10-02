// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let commentsClient = "CommentsClient"
let commentsClientTests = "CommentsClientTests"
let commentsListFeature = "CommentsListFeature"
let commentsListFeatureTests = "CommentsListFeatureTests"
let models = "Models"
let rangeInputFeature = "RangeInputFeature"
let rangeInputFeatureTests = "RangeInputFeatureTests"

let package = Package(
    name: "JSONPlaceholderTCA",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: commentsClient, targets: [commentsClient]),
        .library(name: commentsListFeature, targets: [commentsListFeature]),
        .library(name: models, targets: [models]),
        .library(name: rangeInputFeature, targets: [rangeInputFeature]),
    ],
    dependencies: [
        //Architecture Framework
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.40.0"),
        
        //A library of data structures for working with collections of identifiable elements in an ergonomic, performant way.
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.3.2"),
    ],
    targets: [
        .target(name: commentsClient, dependencies: [
            .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
            .byName(name: models),
        ]),
        .testTarget(name: commentsClientTests, dependencies: [.byName(name: commentsClient)]),
        
        .target(name: commentsListFeature, dependencies: [
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            .byName(name: commentsClient)
        ]),
        .testTarget(name: commentsListFeatureTests, dependencies: [.byName(name: commentsListFeature)]),
        
        .target(name: models),
        
        .target(
            name: rangeInputFeature,
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                
                .byName(name: commentsClient),
                .byName(name: commentsListFeature),
                .byName(name: models),                
            ]),
        .testTarget(
            name: rangeInputFeatureTests,
            dependencies: [
                .byName(name: rangeInputFeature)
            ]),
    ]
)
