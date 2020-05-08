// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SwiftIO",
  platforms: [
    // FIXME: Remove this
    .macOS(.v10_15),
  ],
  products: [
    .library(name: "IO", targets: ["IO"]),
  ],
  targets: [
    .target(name: "IO", dependencies: ["ExitError"]),
    .target(name: "ExitError"),

    .testTarget(name: "IOTests", dependencies: ["Support", "exec-test"]),
    .target(name: "exec-test", dependencies: ["IO"], path: "Tests/exec-test"),
    .target(name: "Support", path: "Tests/Support"),
  ]
)
