// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MadogCore",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16)],
    products: [
        .library(name: "MadogCoreDynamic", type: .dynamic, targets: ["MadogCore"]),
        .library(name: "MadogCoreTestContainers", targets: ["MadogCoreTestContainers"]),
        .library(name: "MadogCoreTestUtilities", targets: ["MadogCoreTestUtilities"])
    ],
    dependencies: [
        .package(url: "https://github.com/cerihughes/provident", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/kif-framework/KIF", .upToNextMajor(from: "3.8.0"))
    ],
    targets: [
        .target(
            name: "MadogCore",
            dependencies: [
                .product(name: "Provident", package: "provident")
            ],
            path: "MadogCore"
        ),
        .target(
            name: "MadogCoreTestContainers",
            dependencies: [
                "MadogCore",
            ],
            path: "MadogCoreTestContainers"
        ),
        .target(
            name: "MadogCoreTestUtilities",
            dependencies: [
                "MadogCore",
                "MadogCoreTestContainers",
                .product(name: "KIF", package: "KIF", condition: .when(platforms: [.iOS]))
            ],
            path: "MadogCoreTestUtilities"
        ),
        .testTarget(
            name: "MadogCoreTests",
            dependencies: ["MadogCore", "MadogCoreTestContainers"],
            path: "MadogCoreTests"
        ),
        .testTarget(
            name: "MadogCoreKIFTests",
            dependencies: [
                "MadogCore",
                "MadogCoreTestUtilities",
                .product(name: "KIF", package: "KIF", condition: .when(platforms: [.iOS]))
            ],
            path: "MadogCoreKIFTests"
        )
    ]
)
