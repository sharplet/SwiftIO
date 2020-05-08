import IO

var arguments = CommandLine.arguments.dropFirst().makeIterator()
guard let command = arguments.next() else {
  errorPrint("fatal: No arguments")
  exit(.EX_USAGE)
}

try exec(command, arguments: arguments)
