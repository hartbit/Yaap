import Yaap
import Foundation

class RandomCommand: Command {
    let name = "rand"
    let documentation = "Generates a random number that lies in an interval."

    @Argument(documentation: "Exclusive maximum value")
    var maximum: Int

    @Option(shorthand: "m", documentation: "Inclusive minimum value")
    var minimum: Int = 0

    let help = Help()
    let version = Version("0.1.0")

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
        guard maximum > minimum else {
            throw InvalidIntervalError(minimum: minimum, maximum: maximum)
        }

        outputStream.write(Int.random(in: minimum..<maximum).description)
        outputStream.write("\n")
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
