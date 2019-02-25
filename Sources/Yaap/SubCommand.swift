public class SubCommand: CommandProperty {
    public let priority: Double = 0.25
    public let commands: [Command]
    public private(set) var value: Command?
    private var label: String?

    public var usage: String? {
        return label
    }

    public var info: [PropertyInfo] {
        return commands
            .sorted(by: { $0.name < $1.name })
            .map({ command in
                PropertyInfo(
                    category: "SUBCOMMANDS",
                    label: command.name,
                    documentation: command.documentation)
            })
    }

    public init(commands: [Command]) {
        self.commands = commands
    }

    public func setup(withLabel label: String) {
        self.label = label
    }

    @discardableResult
    public func parse(arguments: inout [String]) throws -> Bool {
        guard let argument = arguments.first else {
            throw SubCommandMissingError()
        }

        guard let command = commands.first(where: { $0.name == argument }) else {
            let suggestion = commands
                .lazy
                .map({ (key: $0.name, distance: $0.name.levenshteinDistance(to: argument)) })
                .filter({ $0.distance < 3 })
                .min(by: { $0.distance < $1.distance })
                .map({ $0.key })

            throw InvalidSubCommandError(command: argument, suggestion: suggestion)
        }

        value = command
        arguments.removeFirst()
        try command.parse(arguments: &arguments)
        return true
    }

    public func validate(
        in commands: [Command],
        outputStream: inout TextOutputStream,
        errorStream: inout TextOutputStream
    ) throws {
        if let command = value {
            try command.validate(in: commands + [command], outputStream: &outputStream, errorStream: &errorStream)
        }
    }
}

public struct SubCommandMissingError: Error, Equatable {
    public var localizedDescription: String {
        return "missing subcommand"
    }
}

public struct InvalidSubCommandError: Error, Equatable {
    public let command: String
    public let suggestion: String?

    public var localizedDescription: String {
        let error =  "unknown subcommand '\(command)'"

        if let suggestion = suggestion {
            return "\(error); did you mean '\(suggestion)'?"
        } else {
            return error
        }
    }
}
