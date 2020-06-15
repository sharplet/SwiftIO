import Foundation

public struct ExitErrorCode: RawRepresentable {
  public var rawValue: Int32

  public init(rawValue: Int32) {
    self.rawValue = rawValue
  }

  /// Successful termination
  public static var EX_OK: ExitErrorCode { return ExitErrorCode(rawValue: 0) }

  public static var EX__BASE: ExitErrorCode { return .EX_USAGE }

  /// Command line usage error
  public static var EX_USAGE: ExitErrorCode { return ExitErrorCode(rawValue: 64) }
  /// Data format error
  public static var EX_DATAERR: ExitErrorCode { return ExitErrorCode(rawValue: 65) }
  /// Cannot open input
  public static var EX_NOINPUT: ExitErrorCode { return ExitErrorCode(rawValue: 66) }
  /// Addressee unknown
  public static var EX_NOUSER: ExitErrorCode { return ExitErrorCode(rawValue: 67) }
  /// Host name unknown
  public static var EX_NOHOST: ExitErrorCode { return ExitErrorCode(rawValue: 68) }
  /// Service unavailable
  public static var EX_UNAVAILABLE: ExitErrorCode { return ExitErrorCode(rawValue: 69) }
  /// Internal software error
  public static var EX_SOFTWARE: ExitErrorCode { return ExitErrorCode(rawValue: 70) }
  /// System error (e.g., can't fork)
  public static var EX_OSERR: ExitErrorCode { return ExitErrorCode(rawValue: 71) }
  /// Critical OS file missing
  public static var EX_OSFILE: ExitErrorCode { return ExitErrorCode(rawValue: 72) }
  /// Can't create (user) output file
  public static var EX_CANTCREAT: ExitErrorCode { return ExitErrorCode(rawValue: 73) }
  /// Input/output error
  public static var EX_IOERR: ExitErrorCode { return ExitErrorCode(rawValue: 74) }
  /// Temp failure; user is invited to retry
  public static var EX_TEMPFAIL: ExitErrorCode { return ExitErrorCode(rawValue: 75) }
  /// Remote error in protocol
  public static var EX_PROTOCOL: ExitErrorCode { return ExitErrorCode(rawValue: 76) }
  /// Permission denied
  public static var EX_NOPERM: ExitErrorCode { return ExitErrorCode(rawValue: 77) }
  /// Configuration error
  public static var EX_CONFIG: ExitErrorCode { return ExitErrorCode(rawValue: 78) }

  public static var EX__MAX: ExitErrorCode { return .EX_CONFIG }
}

extension ExitErrorCode {
  public static var success: ExitErrorCode { return .EXIT_SUCCESS }
  public static var failure: ExitErrorCode { return .EXIT_FAILURE }

  public static var EXIT_SUCCESS: ExitErrorCode { return .EX_OK }
  public static var EXIT_FAILURE: ExitErrorCode { return ExitErrorCode(rawValue: 1) }
}

public struct ExitError: _BridgedStoredNSError {
  public static let errorDomain = "sysexits"

  public let _nsError: NSError

  public init(_nsError error: NSError) {
    precondition(error.domain == ExitError.errorDomain)
    self._nsError = error
  }

  public static var _nsErrorDomain: String { return ExitError.errorDomain }

  public typealias Code = ExitErrorCode
}

extension ExitErrorCode: _ErrorCodeProtocol {
  public typealias _ErrorType = ExitError
}

extension ExitError {
  /// Successful termination
  public static var EX_OK: ExitErrorCode { return .EX_OK }
  /// Command line usage error
  public static var EX_USAGE: ExitErrorCode { return .EX_USAGE }
  /// Data format error
  public static var EX_DATAERR: ExitErrorCode { return .EX_DATAERR }
  /// Cannot open input
  public static var EX_NOINPUT: ExitErrorCode { return .EX_NOINPUT }
  /// Addressee unknown
  public static var EX_NOUSER: ExitErrorCode { return .EX_NOUSER }
  /// Host name unknown
  public static var EX_NOHOST: ExitErrorCode { return .EX_NOHOST }
  /// Service unavailable
  public static var EX_UNAVAILABLE: ExitErrorCode { return .EX_UNAVAILABLE }
  /// Internal software error
  public static var EX_SOFTWARE: ExitErrorCode { return .EX_SOFTWARE }
  /// System error (e.g., can't fork)
  public static var EX_OSERR: ExitErrorCode { return .EX_OSERR }
  /// Critical OS file missing
  public static var EX_OSFILE: ExitErrorCode { return .EX_OSFILE }
  /// Can't create (user) output file
  public static var EX_CANTCREAT: ExitErrorCode { return .EX_CANTCREAT }
  /// Input/output error
  public static var EX_IOERR: ExitErrorCode { return .EX_IOERR }
  /// Temp failure; user is invited to retry
  public static var EX_TEMPFAIL: ExitErrorCode { return .EX_TEMPFAIL }
  /// Remote error in protocol
  public static var EX_PROTOCOL: ExitErrorCode { return .EX_PROTOCOL }
  /// Permission denied
  public static var EX_NOPERM: ExitErrorCode { return .EX_NOPERM }
  /// Configuration error
  public static var EX_CONFIG: ExitErrorCode { return .EX_CONFIG }
}

extension ExitError {
  public static let argumentsErrorKey = "Arguments"
  public static let commandErrorKey = "Command"
  public static let processErrorKey = "Process"

  public init(status: Int32, userInfo: [String: Any]? = nil) {
    let code = ExitErrorCode(rawValue: status)
    if let userInfo = userInfo {
      self.init(code, userInfo: userInfo)
    } else {
      self.init(code)
    }
  }
}

extension ExitError: CustomStringConvertible {
  public var description: String {
    return String(describing: _nsError)
  }
}
