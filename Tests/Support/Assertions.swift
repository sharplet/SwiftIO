import XCTest

public func XCTUnwrap<Failure: Error, Value>(_ value: Value?, orThrow error: @autoclosure () -> Failure, file: StaticString = #file, line: UInt = #line) throws -> Value {
  try XCTUnwrap(value, "\(error().localizedDescription)", file: file, line: line)
}
