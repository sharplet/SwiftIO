import Foundation

public func exec(
  _ command: String,
  _ arguments: String...,
  options: ProcessOptions = []
) throws -> Never {
  try exec(command, arguments: arguments, options: options)
}

public func exec<Arguments: Sequence>(
  _ command: String,
  arguments: Arguments,
  options: ProcessOptions = []
) throws -> Never where Arguments.Element == String {
  let argv = ([command] + Array(arguments)).map { strdup($0) }
  defer { argv.forEach { free($0) } }

  let status: Int32
  if options.contains(.requireAbsolutePath) {
    status = execv(command, argv + [nil])
  } else {
    status = execvp(command, argv + [nil])
  }

  if status == -1 {
    throw POSIXError.errno
  } else {
    fatalError("Unreachable")
  }
}
