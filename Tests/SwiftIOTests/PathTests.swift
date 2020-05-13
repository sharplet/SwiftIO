import SwiftIO
import XCTest

final class PathTests: XCTestCase {
  func testExtension() {
    var file: Path = "/foo/bar.baz"
    var directory: Path = "/foo/dir.baz/"
    XCTAssertEqual(file.extension, "baz")
    XCTAssertEqual(directory.extension, "baz")

    file.extension = "what"
    XCTAssertEqual(file, "/foo/bar.what")
    directory.extension = "hey"
    XCTAssertEqual(directory, "/foo/dir.hey/")

    var new: Path = "blah"
    new.extension = "blah"
    XCTAssertEqual(new, "blah.blah")
    var newdir: Path = "dir/"
    newdir.extension = "ext"
    XCTAssertEqual(newdir, "dir.ext/")

    var root: Path = "/"
    root.extension = "notroot"
    XCTAssertEqual(root, "/.notroot")
    root.extension = ""
    XCTAssertEqual(root, "/.")
  }

  func testDeleteExtension() {
    var file: Path = "foo.txt"
    file.deleteExtension()
    XCTAssertEqual(file, "foo")
    file.deleteExtension()
    XCTAssertEqual(file, "foo")

    var dir: Path = "foo.build/"
    dir.deleteExtension()
    XCTAssertEqual(dir, "foo/")
  }

  func testDirectory() {
    var file: Path = "/tmp/foo/bar/baz.db"
    file = file.directory
    XCTAssertEqual(file, "/tmp/foo/bar")
    file = file.directory
    XCTAssertEqual(file, "/tmp/foo")
    file = file.directory
    XCTAssertEqual(file, "/tmp")
    file = file.directory
    XCTAssertEqual(file, "/")
    file = file.directory
    XCTAssertEqual(file, "/")

    var relative: Path = "foo/bar"
    relative = relative.directory
    XCTAssertEqual(relative, "foo")
    relative = relative.directory
    XCTAssertEqual(relative, ".")
  }

  func testBasename() {
    XCTAssertEqual(Path("foo/bar.txt").basename, "bar.txt")
    XCTAssertEqual(Path("/").basename, "/")
    XCTAssertEqual(Path("").basename, ".")
  }

  func testConcatenation() {
    XCTAssertEqual(Path("a") + "b", "a/b")
    XCTAssertEqual(Path("/a") + "b", "/a/b")
    XCTAssertEqual(Path("a") + "b/", "a/b/")
    XCTAssertEqual(Path("/a") + "b/", "/a/b/")
    XCTAssertEqual(Path("/a/") + "b", "/a/b")
    XCTAssertEqual(Path("/a/") + "/b", "/a/b")
  }
}
