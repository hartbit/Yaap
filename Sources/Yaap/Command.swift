import Foundation

public protocol Command: ArgumentParser {
    var documentation: String { get }

    func run() throws
}

extension Command {
    public var documentation: String {
        return ""
    }

    public func generateUsage(prefix: String) -> String {
        let components = sortedProperties()
            .compactMap({ $0.usage })
            .compactConsecutiveSame()

        return ([prefix] + components).joined(separator: " ")
    }

    public func generateHelp(usagePrefix: String) -> String {
        var output: [String] = []

        if !documentation.isEmpty {
            output.append("OVERVIEW: \(documentation)")
        }

        output.append("USAGE: \(generateUsage(prefix: usagePrefix))")

        let propertyHelps = sortedProperties().flatMap({ $0.help })
        let maxLabelWidth = propertyHelps.lazy.map({ $0.label.count }).max() ?? 0
        let helpsByCategory = Dictionary(grouping: propertyHelps, by: { $0.category })

        for category in helpsByCategory.keys.sorted() {
            var lines = ["\(category):"]
            let sortedHelps = helpsByCategory[category]!.sorted(by: { $0.label < $1.label })

            for help in sortedHelps {
                let padding = String(repeating: " ", count: maxLabelWidth - help.label.count)
                lines.append("  \(help.label)\(padding)    \(help.description)")
            }

            output.append(lines.joined(separator: "\n"))
        }

        return output.joined(separator: "\n\n")
    }

    @discardableResult
    public func parse(arguments: inout [String]) throws -> Bool {
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

private extension Command {
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

public struct CommandUnexpectedArgumentError: Error, Equatable {
    public let argument: String

    public var localizedDescription: String {
        return "unexpected argument '\(argument)'"
    }
}
