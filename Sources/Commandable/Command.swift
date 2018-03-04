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
        let components = Mirror(reflecting: self).children
            .lazy
            .compactMap({ child -> (priority: Double, usage: String)? in
                if let label = child.label,
                   let argument = child.value as? ArgumentProtocol,
                   let usage = argument.usage(withLabel: label)
                {
                    return (priority: argument.priority, usage: usage)
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
            .map({ $0.element.usage })
            .compactConsecutiveSame()

        return ([prefix] + components).joined(separator: " ")
    }

    func generateHelp(usagePrefix: String) -> String {
        var output: [String] = []

        if !documentation.isEmpty {
            output.append("OVERVIEW: \(documentation)")
        }

        output.append("USAGE: \(generateUsage(prefix: usagePrefix))")

        let argumentHelps = Mirror(reflecting: self).children.compactMap({ child -> ArgumentHelp? in
            if let label = child.label, let argument = child.value as? ArgumentProtocol {
                return argument.help(withLabel: label)
            } else {
                return nil
            }
        })

        let maxLabelWidth = argumentHelps.lazy.map({ $0.label.count }).max() ?? 0
        let helpsByCategory = Dictionary(grouping: argumentHelps, by: { $0.category })

        for (category, helps) in helpsByCategory {
            var category = ["\(category):"]

            for help in helps {
                let padding = String(repeating: " ", count: maxLabelWidth - help.label.count)
                category.append("  \(help.label)\(padding)    \(help.description)")
            }

            output.append(category.joined(separator: "\n"))
        }

        return output.joined(separator: "\n\n")
    }
}
