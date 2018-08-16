// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let package = Package(
    name: "swift-avr",
    dependencies: [],
    targets: [
        .target(
            name: "swift-avr",
            dependencies: []),
        .testTarget(
            name: "swift-avrTests",
            dependencies: ["swift-avr"])
    ]
)
