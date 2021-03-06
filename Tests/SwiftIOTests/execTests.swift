import Support
import XCTest

final class ExecTests: XCTestCase {
  func testItThrowsExitError() throws {
    let url = ExecTests.bundleURL
      .deletingLastPathComponent()
      .appendingPathComponent("exec-test", isDirectory: false)

    let pipe = Pipe()
    let process = Process()
    process.executableURL = url
    process.arguments = ["false"]
    process.standardError = pipe
    process.standardOutput = pipe
    try process.run()
    process.waitUntilExit()
    let data = pipe.fileHandleForReading.readToEndOfFile()
    let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)

    XCTAssertEqual(process.terminationStatus, EXIT_FAILURE)
    XCTAssertEqual(output, "")
  }
}
