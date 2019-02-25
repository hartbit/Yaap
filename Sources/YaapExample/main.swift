import Yaap
import Foundation

class RandomCommand: Command {
    let name = "rand"
    let maximum = Argument<Int>(documentation: "Exlcusive maximum value")
    let minimum = Option<Int>(shorthand: "m", defaultValue: 0, documentation: "Inclusive minimum value")
    let help = Help()

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
        guard maximum.value > minimum.value else {
            throw InvalidIntervalError(minimum: minimum.value, maximum: maximum.value)
        }

        print(Int.random(in: minimum.value..<maximum.value))
    }
}

struct InvalidIntervalError: LocalizedError {
    let minimum: Int
    let maximum: Int

    var errorDescription: String? {
        return "invalid interval [\(minimum), \(maximum))"
    }
}

let rand = RandomCommand()
rand.parseAndRun()
