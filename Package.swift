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
        .library(
            name: "FHDiffableViewControllers",
            targets: ["FHDiffableViewControllers"]),
    ],
    targets: [
        .target(
            name: "FHDiffableViewControllers"),
        .testTarget(
            name: "FHDiffableViewControllersTests",
            dependencies: ["FHDiffableViewControllers"]),
    ]
)
