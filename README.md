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
    let maximum = Argument<Int>()
    let minimum = Option<Int>(defaultValue: 0)

    func run() throws {
        print(Int.random(in: minimum.value..<maximum.value))
    }
}

let tool = Tool(name: "rand", version: "1.0", command: RandomCommand())
tool.run()
```

## Thanks

I'd like to thank [SwiftCLI](https://github.com/jakeheis/SwiftCLI) for being a major influence in designing Yaap.
