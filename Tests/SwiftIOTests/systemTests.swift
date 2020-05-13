import SwiftIO
import SwiftIOFoundation
import XCTest

final class SystemTests: XCTestCase {
  func testItReturnsOnExitSuccess() {
    XCTAssertNoThrow(try system("true"))
  }

  func testItThrowsOnExitFailure() {
    XCTAssertThrowsError(try system("false"))
  }
}