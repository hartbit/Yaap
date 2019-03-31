/// A type that can setup its state by parsing command-line arguments.
public protocol ArgumentParsable: AnyObject {
    /// Sets up the object's state by parsing from the beginning of a list of arguments.
    /// - Parameters:
    ///   - arguments: The array of arguments to parse. Arguments are passed by reference so the function can remove the
    ///     arguments it parsed from the beginning of the array.
    /// - Returns: Returns a boolean value indicating whether the object could use the first values from the `arguments`
    ///   array.
    /// - Throws: Throws if the arguments are invalid.
    /// - Note: If the function can parse from the start of the array, it should remove all the arguments it used and
    ///   return `true`. If not, it should return `false` and not mutate the `arguments` parameter. If the arguments
    ///   are available to setup the object but are invalid, the function should throw an error.
    @discardableResult
    func parse(arguments: inout [String]) throws -> Bool
}

/// A type representing the textual information concerning a command's property.
public struct PropertyInfo: Equatable {
    /// The category, or type, of the property. This is used to categorize the properties in the help output.
    public let category: String

    /// The label, or name, of the property. This is used to refer to the property in the usage and help output.
    public let label: String

    /// The documentation of the property used to describe it in the help output.
    public let documentation: String
}

/// A type representing a command property that can be setup with command line arguments.
public protocol CommandProperty: ArgumentParsable {
    /// The priority that will affect the order the property is to be parsed in. Higher priority properties are parsed
    /// first. Properties with the same priority will parse in the order they are defined in the command.
    var priority: Double { get }

    /// A string representing how the property will appear in the usage description. Return `nil` to not appear.
    var usage: String? { get }

    /// An array of `PropertyInfo` values representing the user-facing properties behind this property.
    /// - Note: Generally contains a single `PropertyInfo` but can contain more when the property actually represents
    ///   multiple descriptions, like in the case of sub-commands.
    var info: [PropertyInfo] { get }

    /// Sets up the property. Called once at initialization time.
    /// - Parameters:
    ///   - label: The name of the property's identifier. Can be used as a default label.
    func setup(withLabel label: String)

    /// Validates the property's state. Called after parsing but before running the command.
    /// - Parameters:
    ///   - commands: An array of successive sub-commands and command containing the property.
    ///   - outputStream: The stream to output standard messages to.
    ///   - errorStream: The stream to output error messages to.
    /// - Throws: Throws an error if the rpoperty has not been setup properly.
    func validate(
        in commands: [Command],
        outputStream: inout TextOutputStream,
        errorStream: inout TextOutputStream
    ) throws
}

/// A type representing different generic parsing errors.
public enum ParseError: Error, Equatable {
    /// A parsing error representing missing mandatory arguments.
    case missingArgument

    /// A parsing error representing an argument with an invalid format.
    case invalidFormat(String)
}
