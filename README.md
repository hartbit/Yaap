# Yaap

Yaap is Yet Another (Swift) Argument Parser that represents executable commands as types and argument and options as properties of those types. It supports:

* Strongly-typed argument and option parsing
* Automatic help and usage message generation
* Multiple command routing
* Smart error messages with suggestion on typos

Here's a self-contained example of a `rand` executable that generates random numbers in a configurable interval to standard output, with everything from `--help` documentation, usage generation, and `--version` printing.

```swift
import Yaap
import Foundation

class RandomCommand: Command {
    let name = "rand"
    let documentation = "Generates a random number that lies in an interval."

    @Argument(documentation: "Exclusive maximum value")
    var maximum: Int

    @Option(shorthand: "m", documentation: "Inclusive minimum value")
    var minimum = 0

    let help = Help()
    let version = Version("0.1.0")

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
        guard maximum.value > minimum.value else {
            throw InvalidIntervalError(minimum: minimum.value, maximum: maximum.value)
        }

        outputStream.write(Int.random(in: minimum.value..<maximum.value).description)
    }
}

struct InvalidIntervalError: LocalizedError {
    let minimum: Int
    let maximum: Int

    var errorDescription: String? {
        return "invalid interval [\(minimum), \(maximum))"
    }
}

RandomCommand().parseAndRun()
```

## Installation

Yaap can be installed as a Swift Package Manager dependency. Here's the declaration for depending on the latest stable version:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/hartbit/Yaap.git", from: "0.1.0")
    ]
)
```

## Usage

### Commands

In Yaap, a command is a self-contained operation defined as a class conforming to the `Command` protocol: arguments (if any) are defined as properties and execution logic is defined in a `run(outputStream:errorStream)` function. Simple programs only need one command but can grow more as necessary.

A command must also define a `name` (the executable name), that will appear in the usage description, and an optional `documentation` property, that will appear in the help output.

```swift
class HelloWorldCommand: Command {
    let name = "hello-world"
    let description = "My first command"

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
        outputStream.write("Hello World")
    }
}
```

Commands can parse command-line arguments and run themselves with the `parseAndRun` function:

```swift
let command = HelloWorldCommand()
command.parseAndRun()
```

Any errors thrown by `run(outputStream:errorStream)` will be caught and reported to the standard error stream.

### Arguments

Mandatory arguments are defined using the generic `Argument` type and are parsed in the order they are declared in the command. They can also be configured with an optional `name` and `documentation` that will show in the help output:

```swift
class SplitCommand: Command {
    let name = "split"

    @Argument(documentation: "The string to split.")
    var string: String
    let sep = Argument<String>(name: "separator", documentation: "The seperator to split the string with.")

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
        outputStream.write(string.value.split(separator: separator.value).joined("\n"))
    }
}
```

```
$ split "The Swift Programming Language" " "
The
Swift
Programming
Language
```

### Options

Optional arguments are defined using the generic `Option` type and must provide a `defaultValue`. The are parsed using the `--option value` or `--option=value` syntax where `option` is the name of the property, which can be customized with an optional `name` parameter. There is also an optional `shorthand` parameter to allow parsing them with a single character syntax of `-o value` or `-o=value`. Again, `documentation` can be provided for the help output:

```swift
class SplitCommand: Command {
    let name = "split"
    let string = Argument<String>()
    let sep = Optional<String>(
        name: "separator",
        shorthand: "s",
        defaultValue: " ",
        documentation: "The seperator to split the string with.")

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
        outputStream.write(string.value.split(separator: sep.value).joined("\n"))
    }
}
```

```
$ split a,b,c,d --separator ,
a
b
c
d
```

### Sub-commands

### Help

Yaap comes with a built-in `Help` property that parses `--help/-h` arguments and prints the command's detailed documentation to standard output. It can be configured with a different name and shorthand syntax. Using the `RandomCommand` example from above:

```swift
class RandomCommand: Command {
    let name = "rand"
    let documentation = "Generates a random number that lies in an interval."
    let maximum = Argument<Int>(documentation: "Exclusive maximum value")
    let minimum = Option<Int>(shorthand: "m", defaultValue: 0, documentation: "Inclusive minimum value")
    let help = Help()

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
        // ...
    }
}

MyCommand().parseAndRun()
```

```
$ rand --help
OVERVIEW: Generates a random number that lies in an interval.

USAGE: rand [options] <maximum>

ARGUMENTS:
  maximum          Exclusive maximum value

OPTIONS:
  --help, -h       Display available options [default: false]
  --minimum, -m    Inclusive minimum value [default: 0]
```

### Version

Yaap also comes with a built-in `Version` property that allows commands to respond to a `--version/-v` argument by printing their version number to standard output. The property can be customized to respond to a different argument name and optional shorthand syntax:

```swift
class MyCommand: Command {
    let version = Version("4.2", name: "ver", shorthand: nil)
}

MyCommand().parseAndRun()
```

```
$ program --ver
4.2
```

## Thanks

I'd like to thank [SwiftCLI](https://github.com/jakeheis/SwiftCLI) for being a major influence in designing Yaap.
