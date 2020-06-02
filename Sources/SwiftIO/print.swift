typealias VPrintFunction<S: TextOutputStream> = (Any..., String, String, inout S) -> Void
typealias PrintFunction<S: TextOutputStream> = ([Any], String, String, inout S) -> Void

private let print = unsafeBitCast(
  Swift.print(_:separator:terminator:to:) as VPrintFunction<FileOutputStream>,
  to: PrintFunction<FileOutputStream>.self
)

public func errorPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  print(items, separator, terminator, &standardError)
}
