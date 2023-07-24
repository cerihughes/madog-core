// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Madog",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Madog", targets: ["MadogCore", "MadogContainers_iOS"])
    ],
    targets: [
        .target(name: "MadogCore", path: "MadogCore"),
        .target(name: "MadogContainers_iOS", dependencies: ["MadogCore"], path: "MadogContainers_iOS"),
        .testTarget(name: "MadogCoreTests", dependencies: ["MadogCore"], path: "MadogCoreTests")
    ]
)
