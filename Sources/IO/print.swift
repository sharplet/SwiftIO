private typealias VPrint = (Any..., String, String, inout FileOutputStream) -> Void
private typealias Print = ([Any], String, String, inout FileOutputStream) -> Void

private let print = unsafeBitCast(
  Swift.print(_:separator:terminator:to:) as VPrint,
  to: Print.self
)

public func errorPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  print(items, separator, terminator, &standardError)
}
