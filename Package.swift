// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibPolygonID",
    platforms: [
        .iOS(.v14),
        .macOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LibPolygonID",
            targets: [ "LibPolygonID" ]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "LibPolygonID",
            dependencies: [
                "CPolygonID",
                "WitnessCalc",
            ]),
        .binaryTarget(name: "WitnessCalc",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.8/witnesscalc.zip",
                      checksum: "293b5073cf33c83b6cf157776762d8676199a1c5b612c3f303f8b2ffe93ee358"),
        .binaryTarget(name: "CPolygonID", path: "CPolygonID.xcframework"),
    ]
)
