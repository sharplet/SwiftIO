import SwiftIO
import Support
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

  func testItGeneratesAFailureReasonString() throws {
    let url = ExecTests.bundleURL
      .deletingLastPathComponent()
      .appendingPathComponent("exit-error-test", isDirectory: false)

    let codes = (ExitErrorCode.EX__BASE.rawValue ... ExitErrorCode.EX__MAX.rawValue)
    let arguments = ["--debug"] + codes.map(String.init(describing:))
    let output = try Process.output(fromRunning: url, arguments: arguments)?
      .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

    XCTAssertEqual(output, """
    Error Domain=sysexits Code=64 "The command arguments were incorrect."
    Error Domain=sysexits Code=65 "The input data was incorrect."
    Error Domain=sysexits Code=66 "No such file or directory."
    Error Domain=sysexits Code=67 "No such user."
    Error Domain=sysexits Code=68 "No such host."
    Error Domain=sysexits Code=69 "The service was unavailable."
    Error Domain=sysexits Code=70 "An internal error occurred."
    Error Domain=sysexits Code=71 "An internal system error occurred."
    Error Domain=sysexits Code=72 "An error occurred while accessing a system file."
    Error Domain=sysexits Code=73 "The output file could not be created."
    Error Domain=sysexits Code=74 "An unexpected I/O error occurred."
    Error Domain=sysexits Code=75 "A temporary failure occurred; try again later."
    Error Domain=sysexits Code=76 "The remote system returned an incorrect result."
    Error Domain=sysexits Code=77 "Permission denied."
    Error Domain=sysexits Code=78 "A configuration error occurred."
    """)
  }
}
