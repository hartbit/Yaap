import Foundation

public class Help: Option<Bool> {
    override public init(
        name: String? = nil,
        shorthand: Character? = nil,
        defaultValue: Bool = false,
        documentation: String? = nil
    ) {
        super.init(
            name: name ?? "help",
            shorthand: shorthand ?? "h",
            defaultValue: defaultValue,
            documentation: documentation ?? "Display available options")
    }

    override public func validate(
        in commands: [Command],
        outputStream: inout TextOutputStream,
        errorStream: inout TextOutputStream
    ) throws {
        if value {
            outputStream.write(generateHelp(in: commands))
            outputStream.write("\n")
            exitProcess(0)
        }
    }

    internal func generateUsage(in commands: [Command]) -> String {
        let commandsUsage = commands.map({ $0.name })
        let properties = commands.last!.sortedProperties()
        let propertiesUsage = properties
            .compactMap({ $0.usage })
            .compactConsecutiveSame()

        return (commandsUsage + propertiesUsage).joined(separator: " ")
    }

    internal func generateHelp(in commands: [Command]) -> String {
        var sections: [String] = []

        if !commands.last!.documentation.isEmpty {
            sections.append("OVERVIEW: \(commands.last!.documentation)")
        }

        sections.append("USAGE: \(generateUsage(in: commands))")

        let propertyInfo = commands.last!.sortedProperties().flatMap({ $0.info })
        let maxLabelWidth = propertyInfo.lazy.map({ $0.label.count }).max() ?? 0
        let helpsByCategory = Dictionary(grouping: propertyInfo, by: { $0.category })

        for category in helpsByCategory.keys.sorted() {
            var lines = ["\(category):"]
            let sortedHelps = helpsByCategory[category]!.sorted(by: { $0.label < $1.label })

            for help in sortedHelps {
                let padding = String(repeating: " ", count: maxLabelWidth - help.label.count)
                lines.append("  \(help.label)\(padding)    \(help.documentation)")
            }

            sections.append(lines.joined(separator: "\n"))
        }

        return sections.joined(separator: "\n\n")
    }
}
