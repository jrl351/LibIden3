// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibPolygonID",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LibPolygonID",
            targets: ["BabyJubjub", "LibPolygonID", "WitnessCalc", "Rapidsnark"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(name: "LibPolygonID",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.5/libpolygonid.zip",
                      checksum: "83d826d7d22bd6de032ff4193975a04d17d3ab2bbdb6e4fe7e5feb5996a62c8a"),
        .binaryTarget(name: "BabyJubjub",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.5-bjj/babyjubjub.zip",
                      checksum: "2e9df23e9f10b116974cbfd02fa923ac231b08ff4573fe28b11e13f620a2b1c6"),
        .binaryTarget(name: "WitnessCalc",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.5-witness/witnesscalc.zip",
                      checksum: "938efe7217930008d39b5ef88c08845f4f002a4443526b8c56297f237aeae588"),
        .binaryTarget(name: "Rapidsnark",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.5-rs/rapidsnark.zip",
                      checksum: "e4004df31851a761a7d716da91259739c114f626e0444b0c0ab04aa430052797"),
    ]
)
