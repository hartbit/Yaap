import Foundation
#if os(macOS)
import Darwin
#else
import Glibc
#endif

internal var exitProcess: (Int32) -> Void = { code in
    exit(code)
}

public protocol Command: ArgumentParser {
    var name: String { get }
    var documentation: String { get }

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws
}

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

    func parseAndRun() {
        let arguments = Array(CommandLine.arguments.dropFirst())
        var standardOutput: TextOutputStream = FileOutputStream(handle: .standardOutput)
        var standardError: TextOutputStream = FileOutputStream(handle: .standardError)
        parseAndRun(arguments: arguments, outputStream: &standardOutput, errorStream: &standardError)
    }

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
            .sorted(by: { (lhs, rhs) -> Bool in
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

public struct CommandUnexpectedArgumentError: LocalizedError, Equatable {
    public let argument: String

    public var errorDescription: String? {
        return "unexpected argument '\(argument)'"
    }
}
