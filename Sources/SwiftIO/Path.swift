import Foundation

public struct Path: RawRepresentable {
  public private(set) var rawValue: String

  public private(set) var components: [Substring] = []
  private var extensionRange: Range<String.Index>?

  public init(rawValue: String) {
    if rawValue.isEmpty {
      self.rawValue = "."
    } else {
      self.rawValue = rawValue
    }
    updateRanges()
  }

  public init<S: StringProtocol>(_ string: S) {
    self.init(rawValue: String(string))
  }

  private init<C: Collection>(
    components: C,
    includeTrailingSlash: Bool = false
  ) where C.Element == Substring {
    var rawValue = components.first == "/"
      ? "/" + components.dropFirst().joined(separator: "/")
      : components.joined(separator: "/")
    if includeTrailingSlash {
      rawValue += "/"
    }
    self.init(rawValue: rawValue)
  }

  public var basename: Substring {
    components.last ?? "."
  }

  public var directory: Path {
    guard let rawValue = strdup(self.rawValue) else { return self }
    defer { free(rawValue) }
    guard let dirname = dirname(rawValue) else { return self }
    return Path(rawValue: String(cString: dirname))
  }

  public var `extension`: Substring {
    get {
      extensionRange.map { rawValue[$0] } ?? ""
    }
    set {
      if let range = extensionRange {
        rawValue.replaceSubrange(range, with: newValue)
      } else {
        let end = components.last?.endIndex ?? rawValue.endIndex
        rawValue.replaceSubrange(end ..< end, with: ".\(newValue)")
      }
      updateRanges()
    }
  }

  public mutating func appendComponent<S: StringProtocol>(_ component: S) {
    guard !component.isEmpty else { return }
    var start = rawValue.endIndex
    if rawValue.last != "/" {
      rawValue += "/"
    }
    rawValue += component.drop(while: { $0 == "/" })
    rawValue.formIndex(after: &start)
    components.append(rawValue[start...])
    extensionRange = computeExtensionRange()
  }

  public mutating func deleteExtension() {
    let target = components.last ?? Substring(rawValue)
    let end = target.endIndex
    let separator = target.lastIndex(of: ".") ?? target.endIndex
    rawValue.removeSubrange(separator ..< end)
    updateRanges()
  }
}

extension Path {
  public static func + <S: StringProtocol>(lhs: Path, rhs: S) -> Path {
    lhs + Path(rhs)
  }

  public static func + (lhs: Path, rhs: Path) -> Path {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  public static func += <S: StringProtocol>(lhs: inout Path, rhs: S) {
    lhs += Path(rhs)
  }

  public static func += (lhs: inout Path, rhs: Path) {
    for component in rhs.components where component != "/" {
      lhs.appendComponent(component)
    }
    if rhs.rawValue.hasSuffix("/") {
      lhs.rawValue += "/"
    }
  }
}

private extension Path {
  mutating func updateRanges() {
    components = computeComponents()
    extensionRange = computeExtensionRange()
  }

  private func computeComponents() -> [Substring] {
    var components = rawValue.split(separator: "/", omittingEmptySubsequences: true)
    if let range = rawValue.range(of: "/", options: .anchored) {
      components.insert(rawValue[range], at: 0)
    }
    return components
  }

  private mutating func computeExtensionRange() -> Range<String.Index>? {
    guard let basename = components.last,
      var separator = basename.lastIndex(of: ".")
      else { return nil }

    _ = basename.formIndex(
      &separator,
      offsetBy: 1,
      limitedBy: basename.endIndex
    )

    return separator ..< basename.endIndex
  }
}

extension Path: CustomStringConvertible {
  public var description: String {
    rawValue
  }
}

extension Path: CustomDebugStringConvertible {
  public var debugDescription: String {
    "Path(\(rawValue))"
  }
}

extension Path: Equatable {
  public static func == (lhs: Path, rhs: Path) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

extension Path: ExpressibleByStringLiteral {
  public init(stringLiteral value: StringLiteralType) {
    self.init(rawValue: value)
  }
}
