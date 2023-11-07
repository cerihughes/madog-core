// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MadogCore",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16)],
    products: [
        .library(name: "MadogCore", targets: ["MadogCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/cerihughes/provident", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(
            name: "MadogCore",
            dependencies: [
                .product(name: "Provident", package: "provident")
            ],
            path: "MadogCore"
        ),
        .testTarget(name: "MadogCoreTests", dependencies: ["MadogCore"], path: "MadogCoreTests")
    ]
)
