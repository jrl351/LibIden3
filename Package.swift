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
            url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.2/libpolygonid.zip",
            checksum: "83807727c184eb03a38cc0a4c7ed9eb1cb2df96d80885536f99f1eff936f6938"),
       ]
)
