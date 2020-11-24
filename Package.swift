// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WineCellar",
    platforms: [
        .macOS(.v10_15)//, .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WineCellar",
            targets: ["WineCellar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/yaslab/CSV.swift", from: "2.4.3"),
        .package(url: "https://github.com/Cosmo/ISO8859.git", from: "1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WineCellar",
            dependencies: [.product(name: "CSV", package: "CSV.swift"),
                           .product(name: "ISO8859", package: "ISO8859")]),
        .testTarget(
            name: "WineCellarTests",
            dependencies: ["WineCellar"]),
    ]
)
