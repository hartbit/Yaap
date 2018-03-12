public class Option<T: ArgumentType>: CommandProperty {
    public private(set) var name: String?
    public let shorthand: Character?
    public let defaultValue: T
    public let documentation: String?
    public private(set) var value: T
    public let priority = 0.75

    public var usage: String? {
        return "[options]"
    }

    public var help: [ArgumentHelp] {
        guard let name = name else { return [] }

        var label = "--\(name)"

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

    public func setup(withLabel label: String) {
        if name == nil {
            name = label
        }
    }

    public func parse<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let name = name else {
            throw ParseError.missingArgument
        }

        var starters = ["--\(name)"]

        if let shorthand = shorthand {
            starters.append("-\(shorthand)")
        }

        while let argument = arguments.next() {
            guard !starters.contains(argument) else {
                if type(of: value) == Bool.self {
                    value = true as! T
                } else {
                    do {
                        value = try T.init(arguments: &arguments)
                    } catch ParseError.missingArgument {
                        throw OptionMissingArgumentError(option: argument)
                    } catch ParseError.invalidFormat(let value) {
                        throw OptionInvalidFormatError(option: argument, value: value)
                    }
                }

                return
            }
        }

        value = defaultValue
    }
}

public struct OptionMissingArgumentError: Error, Equatable {
    public let option: String

    public var localizedDescription: String {
        return """
            option '\(option)' missing a value; provide one with '\(option) <value>' or '\(option)=<value>'
            """
    }
}

public struct OptionInvalidFormatError: Error, Equatable {
    public let option: String
    public let value: String

    public var localizedDescription: String {
        return """
            invalid format '\(value)' for option '\(option)'
            """
    }
}
