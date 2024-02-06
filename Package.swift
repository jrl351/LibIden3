// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibPolygonID",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LibPolygonID",
            targets: ["LibPolygonID"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(
            name: "LibPolygonID",
            url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.1/libpolygonid.zip",
            checksum: "a4e76d7711fc8332b0619cfa3f2880afb1d6ebe6dd2a8fabb10a5fe7e5fe88a1"),
       ]
)
