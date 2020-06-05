@_exported import struct Foundation.POSIXError
@_exported import enum Foundation.POSIXErrorCode
import var Foundation.errno

extension POSIXError {
  public static var errno: POSIXError {
    let code = POSIXErrorCode(rawValue: Foundation.errno)!
    return POSIXError(code)
  }
}
