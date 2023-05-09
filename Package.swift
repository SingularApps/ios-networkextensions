// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "NetworkExtensions",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "NetworkExtensions", targets: ["NetworkExtensions"]),
    ],
    targets: [
        .target(name: "NetworkExtensions", path: "Sources"),
        .testTarget(name: "NetworkExtensionsTests", dependencies: ["NetworkExtensions"], path: "Tests")
    ]
)
