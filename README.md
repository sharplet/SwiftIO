# SwiftIO – Simple Tools for File I/O

SwiftIO aims to provide a small set of useful file input & output capabilities.
Rather than invent significant new paradigms, the goal is to provide the
smallest abstraction necessary to make a nice Swift API, implemented using the
C standard library (or Foundation where appropriate).

Another goal is portability: SwiftIO is distributed via source and Swift
Package Manager, has no external dependencies, and supports Swift Package
Manager's default lowest deployment target.

This is a work in progress, and contributions are welcome!

## Installation

Drop this package declaration into your Package.swift file:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(url: "https://github.com/sharplet/swift-io.git", from: "0.1.0"),
  ]
)
```

## Usage

Add the following import statement to the top of your file to use SwiftIO:

```swift
import IO
```

### `FileOutputStream`

The global variables `standardOutput` and `standardError` are provided for use
with the `print(_:to:)` function:

```swift
print("Oh no!", to: &standardError)
```

Or use the `errorPrint(_:)` functionality, which fits in alongside the standard
library's `debugPrint(_:)` function:

```swift
errorPrint("Oh no!")
```

### Launch processes and shell out

Use the `system` function to run a command. If the exit status is non-zero, an
error is raised.

```swift
do {
  try system("false")
} catch {
  print("Here we are again.")
}
```

Use the `exec` function to replace the currently running process:

```swift
let arguments = Array(CommandLine.arguments.dropFirst())
try exec("xcrun", arguments: ["swift", "run", "mycommand"] + arguments)
```

Both functions accept options. For example, by default the user's PATH will be
searched for matching executables. Disable this behaviour like so:

```swift
// exec-absolute.swift
let command = CommandLine.arguments[1]
try exec(command, options: .requireAbsolutePath)

// exec-absolute foo
// => foo: No such file or directory
```

### Exiting the process

The `exit` function is powered up with a nice enum of exit status codes, as
defined in `sysexits.h`:

```swift
exit(.EX_USAGE) // user error
exit(.EX_SOFTWARE) // programmer error
exit(.failure) // something just went wrong

// these two are the same
exit(.success)
exit()
```

## Prior Art

SwiftIO is fairly similar in role to [swift-tools-support-core](https://github.com/apple/swift-tools-support-core).
It's more mature, and used throughout Swift tooling, so if it works for you
then please use it! This library aims to be community-driven and provide
unopinionated and minimal abstractions atop C.

## License

SwiftIO is Copyright © 2020 Adam Sharp, and is distributed under the
[MIT License](LICENSE).
