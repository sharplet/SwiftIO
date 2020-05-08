public struct ProcessOptions: OptionSet {
  public var rawValue: UInt

  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }

  public static let requireAbsolutePath = ProcessOptions(rawValue: 1)
}
