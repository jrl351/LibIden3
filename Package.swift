// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibPolygonID",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LibPolygonID",
            targets: ["LibPolygonID", "WitnessCalc", "Rapidsnark"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(name: "LibPolygonID",
                      path: "LibPolygonID.xcframework"),
        .binaryTarget(name: "WitnessCalc",
                      path: "WitnessCalc.xcframework"),
        .binaryTarget(name: "Rapidsnark",
                      path: "Rapidsnark.xcframework"),
    ]
)
