public class SubCommand: CommandProperty {
    public let priority: Double = 0.25
    public let commands: [String: Command]
    public private(set) var value: Command?
    private var label: String?

    public var usage: String? {
        return label
    }

    public var help: [ArgumentHelp] {
        return commands
            .sorted(by: { $0.key < $1.key })
            .map({ (label, command) in
                ArgumentHelp(
                    category: "SUBCOMMANDS",
                    label: label,
                    description: command.documentation)
            })
    }

    public init(commands: [String: Command]) {
        self.commands = commands
    }

    public func setup(withLabel label: String) {
        self.label = label
    }

    @discardableResult
    public func parse(arguments: inout [String]) throws -> Bool {
        guard let argument = arguments.first else {
            throw SubCommandMissingArgumentError()
        }

        guard let command = commands[argument] else {
            let suggestion = commands
                .lazy
                .map({ (key: $0.key, distance: $0.key.levenshteinDistance(to: argument)) })
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
}

public struct SubCommandMissingArgumentError: Error, Equatable {
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
