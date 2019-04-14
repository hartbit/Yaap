# Yaap

Yaap is Yet Another (Swift) Argument Parser that supports:

* Strongly-typed argument and option parsing
* Automatic help and usage message generation
* Multiple command routing
* Smart error messages with suggestion on typos

Command are defined using subclasses of the `Command` class and argument and options are defined as properties:

```swift
import Yaap

class RandomCommand: Command {
    let documentation = "Generates a random integer in a certain interval"
    let maximum = Argument<Int>(
        documentation: "Exclusive upper-bound of the generated number")
    let minimum = Option<Int>(
        defaultValue: 0,
        documentation: "Inclusive lower-bound of the generated number")
    let help = Help()
    let version = Version("1.0")

    func run() throws {
        print(Int.random(in: minimum.value..<maximum.value))
    }
}

let command = Command()
command.parseAndRun()
```

## Installation

## Usage

### Arguments

### Options

### Sub-commands

### Help

### Version

## Thanks

I'd like to thank [SwiftCLI](https://github.com/jakeheis/SwiftCLI) for being a major influence in designing Yaap.
