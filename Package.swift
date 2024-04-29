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
        .package(url: "https://github.com/jrl351/BabyJubjub.git", from: "0.0.5"),
    ],
    targets: [
        .target(
            name: "LibPolygonID",
            dependencies: [
                "BabyJubjub",
                "CPolygonID",
                "WitnessCalc",
            ]),
        .binaryTarget(name: "WitnessCalc",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.6/witnesscalc.zip",
                      checksum: "3ba680a6aa146ebf679a8a923cbb3a220db1eca5c2930b52c0d41ef0f658f509"),
        .binaryTarget(name: "CPolygonID",
                      url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.7/cpolygonid.zip",
                      checksum: "22d1bce838d45578eee1ba4457efa8e77f98a36534addfbae45be496deb38e9a"),
    ]
)
