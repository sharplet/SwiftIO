import Foundation

@_exported import struct ExitError.ExitError
public typealias ExitErrorCode = ExitError.Code

extension ExitError {
  public static let argumentsErrorKey = "Arguments"
  public static let commandErrorKey = "Command"
  public static let processErrorKey = "Process"

  public init(status: Int32, userInfo: [String: Any]? = nil) {
    let code = ExitErrorCode(status: status)
    if let userInfo = userInfo {
      self.init(code, userInfo: userInfo)
    } else {
      self.init(code)
    }
  }
}

extension ExitErrorCode {
  public init(status: Int32) {
    self.init(rawValue: Int(status))!
  }
}

extension ExitError: CustomStringConvertible {
  public var description: String {
    String(describing: self as NSError)
  }
}

extension ExitErrorCode {
  public static var success: ExitErrorCode { .EXIT_SUCCESS }
  public static var failure: ExitErrorCode { .EXIT_FAILURE }
}

extension ExitErrorCode {
  public static var EXIT_SUCCESS: ExitErrorCode {
    ExitErrorCode(status: Foundation.EXIT_SUCCESS)
  }

  public static var EXIT_FAILURE: ExitErrorCode {
    ExitErrorCode(status: Foundation.EXIT_FAILURE)
  }

  public static var EX__BASE: ExitErrorCode {
    ExitErrorCode(status: Foundation.EX__BASE)
  }

  public static var EX__MAX: ExitErrorCode {
    ExitErrorCode(status: Foundation.EX__MAX)
  }
}
