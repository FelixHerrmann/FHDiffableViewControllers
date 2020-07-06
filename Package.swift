// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FHDiffableViewControllers",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "FHDiffableViewControllers",
            targets: ["FHDiffableViewControllers"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/FelixHerrmann/FHExtensions", from: "1.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "FHDiffableViewControllers",
            dependencies: [
                .product(name: "FHExtensions", package: "FHExtensions")
            ]),
        .testTarget(
            name: "FHDiffableViewControllersTests",
            dependencies: ["FHDiffableViewControllers"]),
    ]
)
