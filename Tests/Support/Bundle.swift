import XCTest

extension XCTestCase {
  public static var bundle: Bundle {
    Bundle(for: self)
  }

  public static var bundleURL: URL {
    bundle.bundleURL
  }
}
