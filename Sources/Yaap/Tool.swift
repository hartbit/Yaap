import Foundation

public class Tool {
    public let name: String
    public let version: String
    public let command: Command
    internal var outputStream: TextOutputStream = FileOutputStream.standardOutput
    internal var errorStream: TextOutputStream = FileOutputStream.standardError

    public init(name: String, version: String, command: Command) {
        self.name = name
        self.version = version
        self.command = command
    }

    public func run() {
        do {
            var arguments = Array(CommandLine.arguments.dropFirst())
            try command.parse(arguments: &arguments)
            try command.run()
        } catch {
            let description = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            errorStream.write("error: \(description)")
        }
    }
}
