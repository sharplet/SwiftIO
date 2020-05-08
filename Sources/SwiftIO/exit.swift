import Foundation

public func exit(_ code: ExitErrorCode = .success) -> Never {
  let status = Int32(code.rawValue)
  exit(status)
}
