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
    dependencies: [
        .package(url: "https://github.com/WeTransfer/Mocker.git", from: "3.0.1")
    ],
    targets: [
        .target(name: "NetworkExtensions", path: "Sources"),
        .testTarget(name: "NetworkExtensionsTests", dependencies: ["NetworkExtensions", "Mocker"], path: "Tests")
    ]
)
