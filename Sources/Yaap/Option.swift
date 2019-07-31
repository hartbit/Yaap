import Foundation

/// A type representing an optional command property that can be set using the `--option value`, `--option=value` or a
/// shorthand `-o value` and `-o=value` command line argument syntax.
@propertyWrapper
public class Option<T: ArgumentType>: CommandProperty {
    /// The name used to reference the option in command line arguments and the help output, without the `--` prefix.
    public private(set) var name: String?

    /// The single-character name used to reference the option in the shorthand command ine syntax. A `nil` value
    /// means the shorthand syntax is disabled.
    public let shorthand: Character?

    /// The default value the option will take if it is not defined in a command line invocation.
    public let defaultValue: T

    /// The documentation used to describe the option it the help output.
    public let documentation: String?

    /// The option's value. It starts with `defaultValue` and then contains the value parsed from the latest invocation
    /// of `parse(arguments:)`.
    public private(set) var value: T
    public var wrappedValue: T { value }

    public let priority = 0.75

    public var usage: String? {
        return "[options]"
    }

    public var info: [PropertyInfo] {
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

        return [
            PropertyInfo(
                category: "OPTIONS",
                label: label,
                documentation: components.joined(separator: " "))
        ]
    }

    /// Creates an instance of `Option`.
    /// - Parameters:
    ///   - initialValue: The default value the option should take if it is not defined in a command line invocation.
    ///   - name: The full name used to reference the option in command line arguments, without the `--` prefix. Pass
    ///     nil to have it default to the property's identifier name.
    ///   - shorthand: The single-character name used to reference the option in the shorthand command ine syntax. Pass
    ///     `nil` to disable the shorthand syntax.
    ///   - documentation: The documentation of the option used to describe it in the help output.
    public init(initialValue: T, name: String? = nil, shorthand: Character? = nil, documentation: String? = nil) {
        defaultValue = initialValue
        self.name = name
        self.shorthand = shorthand
        self.documentation = documentation
        self.value = defaultValue
    }

    public func setup(withLabel label: String) {
        if name == nil {
            name = label
        }
    }

    @discardableResult
    public func parse(arguments: inout [String]) throws -> Bool {
        guard let name = name else {
            fatalError("parse called before setup(withLabel:)")
        }

        guard let argument = arguments.first else {
            value = defaultValue
            return false
        }

        if argument == "--\(name)" {
            arguments.removeFirst()
        } else if argument.starts(with: "--\(name)=") {
            arguments.removeFirst()

            let equalIndex = argument.index(argument.startIndex, offsetBy: name.count + 2)
            let option = String(argument[..<equalIndex])
            let valueStartIndex = argument.index(after: equalIndex)
            let value = String(argument[valueStartIndex...])

            var innerArguments = [value]
            try parse(option: option, innerArguments: &innerArguments)
            return true
        } else if let shorthand = shorthand, argument.starts(with: "-\(shorthand)") {
            if argument.count == 2 {
                arguments.removeFirst()
            } else {
                let nextIndex = argument.index(argument.startIndex, offsetBy: 2)
                if argument[nextIndex] == "=" {
                    arguments.removeFirst()

                    let option = String(argument[..<nextIndex])
                    let valueStartIndex = argument.index(after: nextIndex)
                    let value = String(argument[valueStartIndex...])

                    var innerArguments = [value]
                    try parse(option: option, innerArguments: &innerArguments)
                    return true
                }

                guard type(of: value) == Bool.self else {
                    throw OptionMissingValueError(option: "-\(shorthand)")
                }

                arguments[0] = "-" + argument.dropFirst(2)
            }
        } else {
            value = defaultValue
            return false
        }

        if let trueT = true as? T {
            value = trueT
        } else {
            let endIndex = arguments.firstIndex(where: { $0.starts(with: "-") }) ?? arguments.endIndex
            var innerArguments = [String](arguments[..<endIndex])
            try parse(option: argument, innerArguments: &innerArguments)
            arguments = innerArguments + arguments[endIndex..<arguments.endIndex]
        }

        return true
    }

    public func validate(
        in commands: [Command],
        outputStream: inout TextOutputStream,
        errorStream: inout TextOutputStream
    ) throws {
    }

    private func parse(option: String, innerArguments: inout [String]) throws {
        do {
            value = try T(arguments: &innerArguments)
        } catch ParseError.missingArgument {
            throw OptionMissingValueError(option: option)
        } catch ParseError.invalidFormat(let value) {
            throw OptionInvalidFormatError(option: option, value: value)
        }
    }
}

//swiftlint:disable:next explicit_acl extension_access_modifier
extension Option where T == Bool {
    /// Creates an instance of a `Option<Bool>` that defaults to `false`.
    /// - Parameters:
    ///   - name: The full name used to reference the option in command line arguments, without the `--` prefix. Pass
    ///     nil to have it default to the property's identifier name.
    ///   - shorthand: The single-character name used to reference the option in the shorthand command ine syntax. Pass
    ///     `nil` to disable the shorthand syntax.
    ///   - documentation: The documentation of the option used to describe it in the help output.
    public convenience init(name: String? = nil, shorthand: Character? = nil, documentation: String? = nil) {
        self.init(initialValue: false, name: name, shorthand: shorthand, documentation: documentation)
    }
}

/// An error type thrown during `Option` parsing when the value is missing.
public struct OptionMissingValueError: LocalizedError, Equatable {
    /// The parsed option argument that is missing a value.
    public let option: String

    public var errorDescription: String? {
        return """
            option '\(option)' missing a value; provide one with '\(option) <value>' or '\(option)=<value>'
            """
    }
}

/// An error type thrown during `Option` parsing when the value is not formatted correctly.
public struct OptionInvalidFormatError: LocalizedError, Equatable {
    /// The parsed option argument that has an incorrectly formatted value.
    public let option: String

    /// The value that is incorrectly formatted.
    public let value: String

    public var errorDescription: String? {
        return "invalid format '\(value)' for option '\(option)'"
    }
}
