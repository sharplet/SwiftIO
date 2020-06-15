// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SwiftIO",
  platforms: [
    .macOS(.v10_13),
  ],
  products: [
    .library(name: "SwiftIO", targets: ["SwiftIO"]),
  ],
  targets: [
    .target(name: "SwiftIO", dependencies: ["ExitError"]),
    .target(name: "ExitError"),

    .testTarget(name: "SwiftIOTests", dependencies: ["Support", "SwiftIO", "exec-test", "exit-error-test"]),
    .target(name: "exec-test", dependencies: ["SwiftIO"], path: "Tests/exec-test"),
    .target(name: "exit-error-test", dependencies: ["SwiftIO"], path: "Tests/exit-error-test"),
    .target(name: "Support", dependencies: ["SwiftIO"], path: "Tests/Support"),
  ]
)
