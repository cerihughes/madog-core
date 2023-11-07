// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MadogCore",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16)],
    products: [
        .library(name: "MadogCore", targets: ["MadogCore"])
    ],
    dependencies: [
        .package(name: "Provident", url: "https://github.com/cerihughes/provident", .branch("align-with-madog")),
    ],
    targets: [
        .target(name: "MadogCore", dependencies: ["Provident"], path: "MadogCore"),
        .testTarget(name: "MadogCoreTests", dependencies: ["MadogCore"], path: "MadogCoreTests")
    ]
)
