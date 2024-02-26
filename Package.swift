// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibPolygonID",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LibPolygonID",
            targets: ["LibPolygonID", "BabyJubjub", "Rapidsnark", "WitnessCalc"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(name: "LibPolygonID",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.4/libpolygonid.zip",
                      checksum: "17ccb1c8ee24e62ee618565ed804d29d49ae02cb827a8651f8e07454416b0854"),
       ]
)
