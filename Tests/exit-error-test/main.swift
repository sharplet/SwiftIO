import Foundation
import SwiftIO

func main() throws {
  var arguments = CommandLine.arguments.dropFirst()
  var showDebugMessages = false
  guard !arguments.isEmpty else { throw ExitError(.EX_USAGE) }

  if let index = arguments.firstIndex(of: "--debug") ?? arguments.firstIndex(of: "-d") {
    showDebugMessages = true
    arguments.remove(at: index)
  }

  for argument in arguments {
    guard let code = Int32(argument).map(ExitErrorCode.init(status:)) else {
      throw ExitError(.EX_USAGE, userInfo: [
        NSLocalizedFailureReasonErrorKey:
          "'\(argument)' is not a valid exit code.",
      ])
    }

    let error = ExitError(code)

    if showDebugMessages {
      print(error)
    } else {
      print(error.localizedDescription)
    }
  }
}

do {
  try main()
} catch {
  let code = (error as? ExitError)?.code ?? .failure
  errorPrint("Error:", error)
  exit(code)
}
