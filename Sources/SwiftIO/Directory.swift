import Foundation

public enum Directory {
  /// Returns the path of the this process's current working directory.
  ///
  /// - Returns: A `Path` holding the current directory, or `nil` for any of
  ///   of the errors specified in `getcwd(3)`. Callers may choose to
  ///   immediately throw `POSIXError.errno` in this case.
  public static var current: Path? {
    guard let path = getcwd(nil, 0) else { return nil }
    return Path(String(cString: path))
  }

  /// Change the current directory to `path`.
  ///
  /// - Throws: `POSIXError`, for any of the errors specified in `chdir(2)`.
  public static func change(to path: Path) throws {
    if chdir(path.rawValue) != 0 {
      throw POSIXError.errno
    }
  }

  /// Executes `block` with the current directory changed to `path`,
  /// then restores the previous directory.
  ///
  /// - Invariant: The original directory is always restored before this
  ///   function returns. If an I/O error or some other fault occurs, this
  ///   function will trap rather than risk the program continuing with an
  ///   unexpected working directory. If this behaviour is unacceptable, you
  ///   should use the non-block-based `Directory.change(to:)` function and
  ///   handle lower-level errors manually.
  ///
  /// - Throws: `POSIXError`, for any of the errors specified in `fopen(3)` or
  ///   `chdir(2)`; errors thrown during execution of `block`.
  public static func change<Result>(
    to path: Path,
    execute block: () throws -> Result
  ) throws -> Result {
    var oldDirectory = try FileHandle.open(".")

    defer {
      do {
        try oldDirectory.close()
      } catch {
        preconditionFailure("Expected to close directory file handle but encountered error: \(error)")
      }
    }

    try change(to: path)

    let result = Swift.Result {
      try block()
    }

    if fchdir(oldDirectory.fileDescriptor) != 0 {
      fatalError("Error \(POSIXError.errno) while restoring previous directory.")
    }

    return try result.get()
  }

  /// Create a directory at the specified `path`.
  ///
  /// - Note: The directory is created with the base mode `a=rwx` (like
  ///  `mkdir(1)`), and restriced by the current process's `umask(2)`.
  ///
  /// - Throws: `POSIXError`, for the errors specified in `mkdir(2)`.
  public static func make(at path: Path) throws {
    if mkdir(path.rawValue, S_IRWXU | S_IRWXG | S_IRWXO) != 0 {
      throw POSIXError.errno
    }
  }

  /// Remove the directory at the specified `path`.
  ///
  /// - Throws: `POSIXError`, for the errors specified in `rmdir(2)`.
  public static func remove(_ path: Path) throws {
    if rmdir(path.rawValue) != 0 {
      throw POSIXError.errno
    }
  }
}
