import Foundation

extension POSIXError {
  public static var errno: POSIXError {
    let code = POSIXErrorCode(rawValue: Foundation.errno)!
    return POSIXError(code)
  }
}
