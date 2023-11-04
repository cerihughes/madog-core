// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MadogCore",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "MadogCore", targets: ["MadogCore"])
    ],
    targets: [
        .target(name: "MadogCore", path: "MadogCore"),
        .testTarget(name: "MadogCoreTests", dependencies: ["MadogCore"], path: "MadogCoreTests")
    ]
)
