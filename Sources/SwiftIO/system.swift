import Foundation

public func system(
  _ command: String,
  _ arguments: String...,
  options: ProcessOptions = []
) throws {
  try system(command, arguments: arguments, options: options)
}

public func system<Arguments: Sequence>(
  _ command: String,
  arguments: Arguments,
  options: ProcessOptions = []
) throws where Arguments.Iterator.Element == String {
  let arguments = Array(arguments)
  let process: Process

  if options.contains(.requireAbsolutePath) {
    let command = URL(fileURLWithPath: command)
    process = try Process._run(command, arguments: arguments)
  } else {
    let shell = URL(fileURLWithPath: "/bin/sh")
    let argv = [command] + arguments
    let shellArguments = ["-c", "\(command) \"$@\""] + argv
    process = try Process._run(shell, arguments: shellArguments)
  }

  process.waitUntilExit()

  guard process.terminationStatus == EXIT_SUCCESS else {
    throw ExitError(status: process.terminationStatus, userInfo: [
      ExitError.commandErrorKey: command,
      ExitError.argumentsErrorKey: arguments,
      ExitError.processErrorKey: process,
    ])
  }
}
