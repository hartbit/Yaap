public struct ArgumentHelp {
    public let category: String
    public let label: String
    public let description: String
}

public protocol ArgumentProtocol: class {
    var priority: Double { get }
    func usage(withLabel label: String) -> String?
    func help(withLabel label: String) -> [ArgumentHelp]
}

public class Argument<T: LosslessStringConvertible>: ArgumentProtocol {
    public var name: String?
    public let documentation: String?
    public private(set) var value: T!
    public let priority = 0.25

    public func usage(withLabel label: String) -> String? {
        return "<\(name ?? label)>"
    }

    public init(name: String? = nil, documentation: String? = nil) {
        self.name = name
        self.documentation = documentation
    }

    public func help(withLabel label: String) -> [ArgumentHelp] {
        if let documentation = documentation {
            return [ArgumentHelp(
                category: "ARGUMENTS",
                label: name ?? label,
                description: documentation)]
        } else {
            return []
        }
    }
}

public class Option<T: LosslessStringConvertible>: ArgumentProtocol {
    public var name: String?
    public let shorthand: Character?
    public let defaultValue: T
    public let documentation: String?
    public private(set) var value: T
    public let priority = 0.75

    public func usage(withLabel label: String) -> String? {
        return "[options]"
    }

    public func help(withLabel label: String) -> [ArgumentHelp] {
        var label = "--\(name ?? label)"

        if let shorthand = shorthand {
            label += ", -\(shorthand)"
        }

        var components: [String] = []

        if let documentation = documentation {
            components.append(documentation)
        }

        components.append("[default: \(defaultValue.description)]")

        return [ArgumentHelp(
            category: "OPTIONS",
            label: label,
            description: components.joined(separator: " "))]
    }

    public init(name: String? = nil, shorthand: Character? = nil, defaultValue: T, documentation: String? = nil) {
        self.name = name
        self.shorthand = shorthand
        self.defaultValue = defaultValue
        self.documentation = documentation
        self.value = defaultValue
    }
}

public class SubCommand: ArgumentProtocol {
    public let priority: Double = 0.25
    public let commands: [String: Command]
    public private(set) var value: Command!

    public func usage(withLabel label: String) -> String? {
        return label
    }

    public func help(withLabel label: String) -> [ArgumentHelp] {
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
}

