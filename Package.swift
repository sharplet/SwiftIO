// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SwiftIO",
  products: [
    .library(name: "SwiftIO", targets: ["SwiftIO"]),
  ],
  targets: [
    .target(name: "SwiftIO", dependencies: ["ExitError", "SwiftIOFoundation"]),
    .target(name: "SwiftIOFoundation", cSettings: [
      .headerSearchPath("include/SwiftIOFoundation"),
    ]),
    .target(name: "ExitError"),

    .testTarget(name: "IOTests", dependencies: ["Support", "exec-test"]),
    .target(name: "exec-test", dependencies: ["SwiftIO"], path: "Tests/exec-test"),
    .target(name: "Support", path: "Tests/Support"),
  ]
)
