public class Argument<T: ArgumentType>: CommandProperty {
    public private(set) var name: String?
    public let documentation: String?
    public private(set) var value: T!
    public let priority = 0.25

    public var usage: String? {
        return name.map({ "<\($0)>" })
    }

    public var help: [ArgumentHelp] {
        if let name = name, let documentation = documentation {
            return [ArgumentHelp(
                category: "ARGUMENTS",
                label: name,
                description: documentation)]
        } else {
            return []
        }
    }

    public init(name: String? = nil, documentation: String? = nil) {
        self.name = name
        self.documentation = documentation
    }

    public func setup(withLabel label: String) {
        if name == nil {
            name = label
        }
    }

    public func parse<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        do {
            value = try T.init(arguments: &arguments)
        } catch ParseError.missingArgument {
            throw MissingArgumentError(argument: name ?? "")
        } catch ParseError.invalidFormat(let value) {
            throw ArgumentInvalidFormatError(argument: name ?? "", value: value)
        }
    }
}

public struct MissingArgumentError: Error, Equatable {
    public let argument: String

    public var localizedDescription: String {
        return "missing argument '\(argument)'"
    }
}

public struct ArgumentInvalidFormatError: Error, Equatable {
    public let argument: String
    public let value: String

    public var localizedDescription: String {
        return "invalid format '\(value)' for argument '\(argument)'"
    }
}
