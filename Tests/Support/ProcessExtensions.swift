import Foundation
import SwiftIO

extension Process {
  public static func output(fromRunning command: URL) throws -> String? {
    try output(fromRunning: command, arguments: [])
  }

  public static func output<Arguments: Sequence>(
    fromRunning command: URL,
    arguments: Arguments
  ) throws -> String?
    where Arguments.Iterator.Element == String
  {
    let pipe = Pipe()
    let process = Process()
    if #available(OSX 10.13, *) {
      process.executableURL = command
    } else {
      process.launchPath = command.path
    }
    process.arguments = arguments.map(String.init(_:))
    process.standardError = pipe
    process.standardOutput = pipe

    if #available(OSX 10.13, *) {
      try process.run()
    } else {
      process.launch()
    }
    process.waitUntilExit()

    guard process.terminationStatus == EX_OK else {
      throw ExitError(status: process.terminationStatus)
    }

    let data = pipe.fileHandleForReading.readToEndOfFile()
    return String(data: data, encoding: .utf8)
  }
}
