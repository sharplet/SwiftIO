import Foundation

/// Wraps a `struct stat` value and allows querying information about a file
/// as returned by `stat(2)`.
public struct FileInfo {
  private var info = stat()

  /// Create a `FileInfo` by calling `stat(2)` with the provided path.
  ///
  /// - Throws: `POSIXError.errno` if the call returns a value other than 0.
  public init(path: Path) throws {
    if stat(path.rawValue, &info) != 0 {
      throw POSIXError.errno
    }
  }

  /// Return `true` if the path references a directory.
  ///
  /// - Note: This property is equivalent to using the `S_ISDIR` macro on the
  ///   `st_mode` field of `struct stat`.
  public var isDirectory: Bool {
    info.st_mode & S_IFMT == S_IFDIR
  }

  /// Return `true` if the path references a regular file.
  ///
  /// - Note: This property is equivalent to using the `S_ISREG` macro on the
  ///   `st_mode` field of `struct stat`.
  public var isRegularFile: Bool {
    // S_ISREG(info.st_mode)
    info.st_mode & S_IFMT == S_IFREG
  }

  /// Return `true` if the path references a symbolic link.
  ///
  /// - Note: This property is equivalent to using the `S_ISLNK` macro on the
  ///   `st_mode` field of `struct stat`.
  public var isSymbolicLink: Bool {
    info.st_mode & S_IFMT == S_IFLNK
  }
}

extension FileInfo {
  /// Create a `FileInfo` for the provided path and return the value of its
  /// `isRegularFile` property.
  ///
  /// - Returns: `true` if the path points to a regular file, or `false` for
  ///   other kinds of file. Also returns `false` if an error occurs.
  public static func isRegularFile(at path: Path) -> Bool {
    do {
      return try FileInfo(path: path).isRegularFile
    } catch {
      return false
    }
  }

  /// Create a `FileInfo` for the provided path and return the value of its
  /// `isDirectory` property.
  ///
  /// - Returns: `true` if the path points to a directory, or `false` for
  ///   other kinds of file. Also returns `false` if an error occurs.
  public static func isDirectory(at path: Path) -> Bool {
    do {
      return try FileInfo(path: path).isDirectory
    } catch {
      return false
    }
  }

  /// Create a `FileInfo` for the provided path and return the value of its
  /// `isSymbolicLink` property.
  ///
  /// - Returns: `true` if the path points to a symbolic link, or `false` for
  ///   other kinds of file. Also returns `false` if an error occurs.
  public static func isSymbolicLink(at path: Path) -> Bool {
    do {
      return try FileInfo(path: path).isSymbolicLink
    } catch {
      return false
    }
  }
}
