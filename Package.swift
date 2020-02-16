// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Madog",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "Madog", targets: ["Madog"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Madog",
            path: "Source"
        ),
        .testTarget(
            name: "MadogTests",
            dependencies: ["Madog"],
            path: "Tests"
        ),
    ]
)
