import Foundation
#if os(macOS)
import Darwin
#else
import Glibc
#endif

/// A type representing an executable command that can be setup using command line arguments before being run.
///
/// To conform to this protocol, simply implement the `run(outputStream:errorStream:)` function with the logic the
/// command should execute when invoked from the command line.
///
/// The `outputStream` and `errorStream` arguments represent
/// the standard output and standard error streams. If the function throws an error conforming to `LocalizedError`, its
/// `errorDescription` property will be printed to standard error. If not, its `localizedDescription` proeprty will be
/// used.
///
/// Any `CommandProperty` conforming properties on the command will be parsed before the `run(outputStream:errorStream)`
/// function is called.
public protocol Command: ArgumentParsable {
    /// The name of the command.
    var name: String { get }

    /// The documentation used to describe the command it the help output.
    var documentation: String { get }

    /// Runs a command in its current state.
    /// - Parameters:
    ///   - outputStream: The output stream where the command writes its output data.
    ///   - errorStream: The error stream where the command outputs error messages or diagnostics.
    /// - Throws: The command can throw any error in its operation.
    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws
}

// Default implementations
//swiftlint:disable missing_docs
public extension Command {
    var documentation: String {
        return ""
    }

    @discardableResult
    func parse(arguments: inout [String]) throws -> Bool {
        var properties = sortedProperties()

        func parseProperties() throws -> Bool {
            for (index, property) in properties.enumerated() {
                if try property.parse(arguments: &arguments) {
                    properties.remove(at: index)
                    return true
                }
            }

            return false
        }

        while !arguments.isEmpty {
            guard try parseProperties() else {
                throw CommandUnexpectedArgumentError(argument: arguments.first!)
            }
        }

        return true
    }
}
//swiftlint:enable explicit_acl

//swiftlint:disable:next missing_docs
public extension Command {
    /// Sets up the command with the process' command line arguments and then runs it.
    func parseAndRun() {
        let arguments = Array(CommandLine.arguments.dropFirst())
        var standardOutput: TextOutputStream = FileOutputStream(handle: .standardOutput)
        var standardError: TextOutputStream = FileOutputStream(handle: .standardError)
        parseAndRun(arguments: arguments, outputStream: &standardOutput, errorStream: &standardError)
    }

    /// Sets up the command with arguments and then runs it.
    /// - Parameters:
    ///   - arguments: The arguments to parse to setup the command.
    ///   - outputStream: The output stream where the command writes its output data.
    ///   - errorStream: The error stream where the command outputs error messages or diagnostics.
    func parseAndRun(arguments: [String], outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) {
        do {
            var arguments = arguments
            try parse(arguments: &arguments)
            try validate(in: [self], outputStream: &outputStream, errorStream: &errorStream)
            try run(outputStream: &outputStream, errorStream: &errorStream)
        } catch {
            let description = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            errorStream.write("\u{001B}[31merror:\u{001B}[0m \(description)\n")
            exitProcess(128)
        }
    }

    /// Validates each property in the command.
    /// - Parameters:
    ///   - commands: The list of commands the command is contained in, from root to leaf, including this command.
    ///   - outputStream: The output stream where the command writes its output data.
    ///   - errorStream: The error stream where the command outputs error messages or diagnostics.
    func validate(
        in commands: [Command],
        outputStream: inout TextOutputStream,
        errorStream: inout TextOutputStream
    ) throws {
        for property in sortedProperties() {
            try property.validate(in: commands, outputStream: &outputStream, errorStream: &errorStream)
        }
    }
}

internal extension Command {
    //swiftlint:disable:next explicit_acl
    func sortedProperties() -> [CommandProperty] {
        let mirrors = sequence(first: Mirror(reflecting: self), next: { $0.superclassMirror })
        let children = mirrors.lazy.flatMap({ $0.children })
        let properties = children.compactMap({ child -> CommandProperty? in
            if let property = child.value as? CommandProperty {
                if let label = child.label {
                    property.setup(withLabel: label)
                }

                return property
            } else {
                return nil
            }
        })

        let sortedProperties = properties
            .enumerated()
            .sorted(by: { lhs, rhs -> Bool in
                if lhs.element.priority != rhs.element.priority {
                    return lhs.element.priority > rhs.element.priority
                } else {
                    return lhs.offset < rhs.offset
                }
            })
            .map({ $0.element })

        return sortedProperties
    }
}

/// An error type thrown during `Command` parsing when encountering an unexpected argument.
public struct CommandUnexpectedArgumentError: LocalizedError, Equatable {
    /// The unexpected argument.
    public let argument: String

    public var errorDescription: String? {
        return "unexpected argument '\(argument)'"
    }
}

internal var exitProcess: (Int32) -> Void = { code in
    exit(code)
}
