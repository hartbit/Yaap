public class SubCommand: CommandProperty {
    public let priority: Double = 0.25
    public let commands: [String: Command]
    public private(set) var value: Command!
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

    public func parse<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw SubCommandMissingArgumentError()
        }

        guard let command = commands[argument] else {
            let proposition = commands
                .lazy
                .map({ (key: $0.key, distance: $0.key.levenshteinDistance(to: argument)) })
                .filter({ $0.distance < 3 })
                .min(by: { $0.distance < $1.distance })
                .map({ $0.key })

            throw InvalidSubCommandError(command: argument, proposition: proposition)
        }

        value = command
        try command.parse(arguments: &arguments)
    }
}

public struct SubCommandMissingArgumentError: Error, Equatable {
    public var localizedDescription: String {
        return "missing subcommand"
    }
}

public struct InvalidSubCommandError: Error, Equatable {
    public let command: String
    public let proposition: String?

    public var localizedDescription: String {
        let error =  "unknown subcommand '\(command)'"

        if let proposition = proposition {
            return "\(error); did you mean '\(proposition)'?"
        } else {
            return error
        }
    }
}
