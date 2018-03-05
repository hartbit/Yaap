import Foundation

public protocol Command {
    var documentation: String { get }
    func run() throws
}

public extension Command {
    var documentation: String {
        return ""
    }

    func generateUsage(prefix: String) -> String {
        let components = sortedArguments()
            .compactMap({ $0.argument.usage(withLabel: $0.label) })
            .compactConsecutiveSame()

        return ([prefix] + components).joined(separator: " ")
    }

    func generateHelp(usagePrefix: String) -> String {
        var output: [String] = []

        if !documentation.isEmpty {
            output.append("OVERVIEW: \(documentation)")
        }

        output.append("USAGE: \(generateUsage(prefix: usagePrefix))")

        let argumentHelps = sortedArguments()
            .flatMap({ $0.argument.help(withLabel: $0.label) })

        let maxLabelWidth = argumentHelps.lazy.map({ $0.label.count }).max() ?? 0
        let helpsByCategory = Dictionary(grouping: argumentHelps, by: { $0.category })

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

    private func sortedArguments() -> [(label: String, argument: ArgumentProtocol)] {
        return Mirror(reflecting: self).children
            .lazy
            .compactMap({ child -> (label: String, argument: ArgumentProtocol, priority: Double)? in
                if let label = child.label,
                   let argument = child.value as? ArgumentProtocol
                {
                    return (label: label, argument: argument, priority: argument.priority)
                } else {
                    return nil
                }
            })
            .enumerated()
            .sorted(by: { (lhs, rhs) -> Bool in
                if lhs.element.priority != rhs.element.priority {
                    return lhs.element.priority > rhs.element.priority
                } else {
                    return lhs.offset < rhs.offset
                }
            })
            .map({ ($0.element.label, $0.element.argument) })
    }
}

public struct GroupCommand: Command {
    public let documentation: String
    public let subcommand: SubCommand

    public init(commands: [String: Command], documentation: String = "") {
        self.documentation = documentation
        subcommand = SubCommand(commands: commands)
    }

    public func run() throws {
    }
}
