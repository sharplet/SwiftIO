import Foundation

public struct FileOutputStream: TextOutputStream {
  var handle: UnsafeMutablePointer<FILE>

  public func write(_ string: String) {
    fputs(string, handle)
  }
}

public var standardError = FileOutputStream(handle: stderr)
public var standardOutput = FileOutputStream(handle: stdout)
