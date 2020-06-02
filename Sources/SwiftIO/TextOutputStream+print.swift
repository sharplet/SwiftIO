extension TextOutputStream {
  public mutating func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let print = unsafeBitCast(
      Swift.print(_:separator:terminator:to:) as VPrintFunction<Self>,
      to: PrintFunction<Self>.self
    )
    print(items, separator, terminator, &self)
  }

  public mutating func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let print = unsafeBitCast(
      Swift.debugPrint(_:separator:terminator:to:) as VPrintFunction<Self>,
      to: PrintFunction<Self>.self
    )
    print(items, separator, terminator, &self)
  }
}
