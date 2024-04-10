// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibPolygonID",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LibPolygonID",
            targets: [ "LibPolygonID" ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jrl351/BabyJubjub.git", from: "0.0.5")
    ],
    targets: [
        .target(
            name: "LibPolygonID",
            dependencies: [
                "BabyJubjub",
                "CPolygonID",
                "WitnessCalc",
                "Rapidsnark",
            ]),
        .binaryTarget(name: "CPolygonID", path: "CPolygonID.xcframework"),
        .binaryTarget(name: "WitnessCalc",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.5-witness/witnesscalc.zip",
                      checksum: "938efe7217930008d39b5ef88c08845f4f002a4443526b8c56297f237aeae588"),
        .binaryTarget(name: "Rapidsnark",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.5-rs/rapidsnark.zip",
                      checksum: "e4004df31851a761a7d716da91259739c114f626e0444b0c0ab04aa430052797"),
    ]
)
