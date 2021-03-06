import Foundation

/// A type representing a mandatory command property that must be set at a specific position of the command line
/// arguments.
@propertyWrapper
public class Argument<T: ArgumentType>: CommandProperty {
    /// The full name used to reference the argument in the help output.
    public private(set) var name: String?

    /// The documentation used to describe the argument it the help output.
    public let documentation: String?

    /// The argument's value. It contains the value parsed from the latest invocation of `parse(arguments:)`.
    public var value: T!

    public var wrappedValue: T {
        guard let value = value else { preconditionFailure("value has not been set") }
        return value
    }

    public let priority = 0.25

    public var usage: String? {
        return name.map({ "<\($0)>" })
    }

    public var info: [PropertyInfo] {
        if let name = name, let documentation = documentation {
            return [
                PropertyInfo(
                    category: "ARGUMENTS",
                    label: name,
                    documentation: documentation)
            ]
        } else {
            return []
        }
    }

    public init()
    {
        self.name = nil
        self.documentation = nil
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

    @discardableResult
    public func parse(arguments: inout [String]) throws -> Bool {
        if let firstArgument = arguments.first {
            guard !firstArgument.starts(with: "-") else {
                return false
            }
        }

        do {
            value = try T(arguments: &arguments)
            return true
        } catch ParseError.missingArgument {
            throw ArgumentMissingError(argument: name ?? "")
        } catch ParseError.invalidFormat(let value) {
            throw ArgumentInvalidFormatError(argument: name ?? "", value: value)
        }
    }

    public func validate(
        in commands: [Command],
        outputStream: inout TextOutputStream,
        errorStream: inout TextOutputStream
    ) throws {
        guard value != nil else {
            throw ArgumentMissingError(argument: name ?? "")
        }
    }
}

/// An error type thrown during `Argument` parsing when the value is missing.
public struct ArgumentMissingError: LocalizedError, Equatable {
    /// The name of the argument that is missing a value.
    public let argument: String

    public var errorDescription: String? {
        return "missing argument '\(argument)'"
    }
}

/// An error type thrown during `Argument` parsing when the value is not formatted correctly.
public struct ArgumentInvalidFormatError: LocalizedError, Equatable {
    /// The name of the argument that has an incorrectly formatted value.
    public let argument: String

    /// The value that is incorrectly formatted.
    public let value: String

    public var errorDescription: String? {
        return "invalid format '\(value)' for argument '\(argument)'"
    }
}
