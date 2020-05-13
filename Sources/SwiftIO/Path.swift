import Foundation

public struct Path: RawRepresentable {
  public private(set) var rawValue: String {
    didSet { updateRanges() }
  }

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

  public mutating func deleteExtension() {
    let target = components.last ?? Substring(rawValue)
    let end = target.endIndex
    let separator = target.lastIndex(of: ".") ?? target.endIndex
    rawValue.removeSubrange(separator ..< end)
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
