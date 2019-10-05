/// A type that can be initialized from a list of arguments.
public protocol ArgumentType: CustomStringConvertible {
    /// Creates an instance of the `ArgumentType` conforming type from the arguments at the front an argument list
    /// passed by reference, returning the unused arguments through the reference.
    /// - Throws: Throws if the arguments don't allow creating an instance, either because they are too few or because
    ///   they are not formatted correctly.
    init(arguments: inout [String]) throws
}

//swiftlint:disable explicit_acl
//swiftlint:disable missing_docs
//swiftlint:disable extension_access_modifier

extension LosslessStringConvertible where Self: ArgumentType {
    public init(arguments: inout [String]) throws {
        guard let argument = arguments.first else {
            throw ParseError.missingArgument
        }

        guard let value = Self(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = value
        arguments.removeFirst()
    }
}

extension String: ArgumentType {
    public init(arguments: inout [String]) throws {
        guard let argument = arguments.first else {
            throw ParseError.missingArgument
        }

        self = argument
        arguments.removeFirst()
    }
}

extension Character: ArgumentType {
    public init(arguments: inout [String]) throws {
        guard let argument = arguments.first else {
            throw ParseError.missingArgument
        }

        guard argument.count == 1 else {
            throw ParseError.invalidFormat(argument)
        }

        self = argument[argument.startIndex]
        arguments.removeFirst()
    }
}

extension Bool: ArgumentType {}
extension Int: ArgumentType {}
extension Int8: ArgumentType {}
extension Int16: ArgumentType {}
extension Int32: ArgumentType {}
extension Int64: ArgumentType {}
extension UInt: ArgumentType {}
extension UInt8: ArgumentType {}
extension UInt16: ArgumentType {}
extension UInt32: ArgumentType {}
extension UInt64: ArgumentType {}
extension Float: ArgumentType {}
extension Double: ArgumentType {}

extension Array: ArgumentType where Element: ArgumentType {
    public init(arguments: inout [String]) throws {
        self.init()

        guard !arguments.isEmpty else {
            throw ParseError.missingArgument
        }

        while true {
            do {
                try append(Element(arguments: &arguments))
            } catch ParseError.missingArgument {
                break
            }
        }
    }
}

extension Set: ArgumentType where Element: ArgumentType {
    public init(arguments: inout [String]) throws {
        self.init()

        guard !arguments.isEmpty else {
            throw ParseError.missingArgument
        }

        while true {
            do {
                try insert(Element(arguments: &arguments))
            } catch ParseError.missingArgument {
                break
            }
        }
    }
}
