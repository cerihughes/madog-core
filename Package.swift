// swift-tools-version:5.3
import PackageDescription

let package = Package(name: "Madog",
                      platforms: [.iOS(.v13)],
                      products: [
                          .library(name: "Madog", targets: ["Madog"])
                      ],
                      dependencies: [
                          .package(url: "https://github.com/cerihughes/provident", .exact("4.0.0"))
                      ],
                      targets: [
                          .target(name: "Madog",
                                  dependencies: [.product(name: "Provident", package: "provident")],
                                  path: "Source"),
                          .testTarget(name: "MadogTests",
                                      dependencies: ["Madog"],
                                      path: "Tests")
                      ])
