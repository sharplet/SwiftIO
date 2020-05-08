import Foundation
import SwiftIOFoundation

extension Process {
  static func _run<Arguments: Sequence>(
    _ url: URL,
    arguments: Arguments,
    terminationHandler: ((Process) -> Void)? = nil
  ) throws -> Process where Arguments.Element == String {
    if #available(OSX 10.13, *) {
      return try run(
        url,
        arguments: Array(arguments),
        terminationHandler: terminationHandler
      )
    } else {
      let process = Process()
      process.swiftio_executableURL = url
      process.arguments = Array(arguments)
      process.terminationHandler = terminationHandler
      try process.swiftio_run()
      return process
    }
  }
}
