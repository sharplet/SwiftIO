import Foundation

extension Process {
  static func _run(_ command: URL) throws -> Process {
    try _run(command, arguments: [])
  }

  static func _run<Arguments: Sequence>(
    _ command: URL,
    arguments: Arguments
  ) throws -> Process
    where Arguments.Iterator.Element == String
  {
    if #available(OSX 10.13, *) {
      return try run(command, arguments: arguments.map(String.init(_:)))
    } else {
      return launchedProcess(launchPath: command.path, arguments: arguments.map(String.init(_:)))
    }
  }
}
