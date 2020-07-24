import Foundation

extension FileHandle {
  public func readToEndOfFile() -> Data {
    if #available(OSX 10.15.4, *) {
      return (try? readToEnd()) ?? Data()
    } else {
      return readDataToEndOfFile()
    }
  }
}
