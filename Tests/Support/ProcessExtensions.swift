import Foundation
import SwiftIO

extension Process {
  public static func output(fromRunning command: URL, arguments: [String] = []) throws -> String? {
    let pipe = Pipe()
    let process = Process()
    process.swiftio_executableURL = command
    process.arguments = arguments
    process.standardError = pipe
    process.standardOutput = pipe
    try process.swiftio_run()
    process.waitUntilExit()

    guard process.terminationStatus == EX_OK else {
      throw ExitError(status: process.terminationStatus)
    }

    let data = pipe.fileHandleForReading.readToEndOfFile()
    return String(data: data, encoding: .utf8)
  }
}
