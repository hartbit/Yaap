import Foundation

open class Command: ArgumentParser {
    let documentation: String

    init(documentation: String) {
        self.documentation = documentation
    }

    open func generateUsage(prefix: String) -> String {
        let components = sortedProperties()
            .compactMap({ $0.usage })
            .compactConsecutiveSame()

        return ([prefix] + components).joined(separator: " ")
    }

    open func generateHelp(usagePrefix: String) -> String {
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

    open func parse<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
    }

    open func run() throws {
    }
}

private extension Command {
    func sortedProperties() -> [CommandProperty] {
        return Mirror(reflecting: self).children
            .lazy
            .compactMap({ child -> CommandProperty? in
                if let property = child.value as? CommandProperty {
                    if let label = child.label {
                        property.setup(withLabel: label)
                    }

                    return property
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
            .map({ $0.element })
    }
}
