// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftExtractor",
    platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftExtractor",
            targets: ["SwiftExtractor"]),
        .executable(
            name: "autotest",
            targets: ["SwiftExtractorExecutable"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "508.0.0"),
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/syedqamara/core_architecture.git", from: "1.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftExtractor",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                .product(name: "core_architecture", package: "core_architecture")
            ]),
        .executableTarget(
                    name: "SwiftExtractorExecutable",
                    dependencies: ["SwiftExtractor"]
                ),
        .testTarget(
            name: "SwiftExtractorTests",
            dependencies: [
                "SwiftExtractor",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
            ]),
    ]
)
