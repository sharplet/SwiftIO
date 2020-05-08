import SwiftIO
import XCTest

final class ExitErrorTests: XCTestCase {
  func testItCanSwitchOverUnknownCases() {
    switch ExitErrorCode.EXIT_FAILURE {
    case .EX_OK, .EX_USAGE, .EX_DATAERR, .EX_NOINPUT, .EX_NOUSER, .EX_NOHOST,
         .EX_UNAVAILABLE, .EX_SOFTWARE, .EX_OSERR, .EX_OSFILE, .EX_CANTCREAT,
         .EX_IOERR, .EX_TEMPFAIL, .EX_PROTOCOL, .EX_NOPERM, .EX_CONFIG:
      XCTFail("Expected EXIT_FAILURE not to match a known case")
    @unknown default:
      break
    }
  }
}
