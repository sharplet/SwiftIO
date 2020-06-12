import Foundation

public struct FileHandle {
  public struct Options: OptionSet {
    public var rawValue: UInt

    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }

    public static let binary = Options(rawValue: 1 << 0)
  }

  public static func open(
    _ path: Path,
    mode: Mode = .read,
    options: Options = []
  ) throws -> FileHandle {
    var mode = mode.rawValue
    if options.contains(.binary) {
      mode += "b"
    }
    guard let handle = fopen(path.rawValue, mode) else {
      throw POSIXError.errno
    }
    return FileHandle(handle: handle)
  }

  public static func open<Result>(
    _ path: Path,
    mode: Mode = .read,
    options: Options = [],
    fileHandler: (inout FileHandle) throws -> Result
  ) throws -> Result {
    var file = try open(path, mode: mode, options: options)
    do {
      let result = try fileHandler(&file)
      try file.closeIfNeeded()
      return result
    } catch {
      try file.closeIfNeeded()
      throw error
    }
  }

  private let handle: UnsafeMutablePointer<FILE>
  private var isKnownClosed = false
  private var isKnownInvalid = false

  public var writeErrorHandler: ((POSIXError) -> Void)?

  public mutating func close() throws {
    precondition(!isKnownClosed)

    defer { isKnownInvalid = true }

    if fclose(handle) == 0 {
      isKnownClosed = true
    } else {
      throw POSIXError.errno
    }
  }

  private mutating func closeIfNeeded() throws {
    guard !isKnownClosed else { return }
    try close()
  }

  public func readLine(strippingNewline: Bool = true) throws -> String? {
    precondition(!isKnownInvalid, "Attempted to read an invalid file stream.")

    var count = 0
    guard let pointer = fgetln(handle, &count) else {
      if ferror(handle) != 0 {
        throw POSIXError.errno
      } else {
        return nil
      }
    }

    let utf8 = UnsafeRawPointer(pointer).assumingMemoryBound(to: UInt8.self)
    let buffer = UnsafeBufferPointer(start: utf8, count: count)
    var end = buffer.endIndex

    if strippingNewline {
      strip: while end > buffer.startIndex {
        let index = buffer.index(before: end)
        switch Unicode.Scalar(buffer[index]) {
        case "\r", "\n":
          end = index
        default:
          break strip
        }
      }
    }

    return String(decoding: buffer[..<end], as: UTF8.self)
  }

  public func write<Bytes: Sequence>(_ bytes: Bytes) throws where Bytes.Element == UInt8 {
    var count = 0

    var countWritten = bytes.withContiguousStorageIfAvailable { buffer -> Int in
      count = buffer.count
      precondition(count > 0)
      return fwrite(buffer.baseAddress, 1, count, handle)
    }

    if countWritten == nil {
      let array = Array(bytes)
      count = array.count
      precondition(count > 0)
      countWritten = fwrite(array, 1, count, handle)
    }

    if countWritten != count {
      throw POSIXError.errno
    }
  }
}

extension FileHandle {
  public enum Mode: String {
    case read = "r"
    case readWrite = "r+"
    case truncate = "w"
    case readTruncate = "w+"
    case new = "wx"
    case readWriteNew = "w+x"
    case append = "a"
    case readAppend = "a+"
  }
}

extension FileHandle {
  public mutating func read<I: BinaryInteger>(_: I.Type) throws -> I? {
    var i = I.zero
    let size = MemoryLayout.size(ofValue: i)
    precondition(size != 0, "fread(3): cannot read value of size 0")
    if fread(&i, size, 1, handle) < 1 {
      if ferror(handle) > 0 {
        throw POSIXError.errno
      } else {
        precondition(feof(handle) > 0, "fread(3): read fewer than expected items before EOF")
        return nil
      }
    } else {
      return i
    }
  }
}

extension FileHandle: TextOutputStream {
  public func write(_ string: String) {
    precondition(!isKnownInvalid, "Attempted to write to an invalid file stream.")
    if fputs(string, handle) == EOF, let errorHandler = writeErrorHandler {
      errorHandler(.errno)
    }
  }
}
