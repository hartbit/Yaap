import Foundation

public protocol Command {
    var documentation: String { get }
    func run() throws
}

extension Command {
    var documentation: String { return "" }
}

public protocol Parameter {
    var name: String? { get }
    var documentation: String? { get }
}

public protocol ArgumentProtocol: Parameter {
}

public class Argument<T: LosslessStringConvertible>: ArgumentProtocol {
    public let name: String?
    public let documentation: String?
    public private(set) var value: T!

    public init(name: String? = nil, documentation: String? = nil) {
        self.name = name
        self.documentation = documentation
    }
}

public protocol OptionProtocol: Parameter {
    var shortName: String? { get }
    var defaultValue: CustomStringConvertible? { get }
}

public class Option<T: LosslessStringConvertible>: OptionProtocol {
    public let name: String?
    public let shortName: String?
    public let defaultValue: CustomStringConvertible?
    public let documentation: String?
    public private(set) var value: T!

    public init(name: String? = nil, shortName: String? = nil, defaultValue: T? = nil, documentation: String? = nil) {
        self.name = name
        self.shortName = shortName
        self.defaultValue = defaultValue
        self.documentation = documentation

        if let defaultValue = defaultValue {
            self.value = defaultValue
        }
    }
}

public extension Command {
    func generateUsage(prefix: String) -> String {
        var usageComponents = [prefix]

        if !reflectOptions().isEmpty {
            usageComponents.append("[options]")
        }

        usageComponents.append(contentsOf: reflectArguments().map({ "<\($0.name)>" }))
        return usageComponents.joined(separator: " ")
    }

    func generateHelp(usagePrefix: String) -> String {
        var help = ""

        if !documentation.isEmpty {
            help += """
                OVERVIEW: \(documentation)


                """
        }

        help += """
            USAGE: \(generateUsage(prefix: usagePrefix))
            """

        let arguments = reflectArguments()
        let documentedArguments = arguments.filter({ $0.argument.documentation != nil })
        let maxArgumentWidth = documentedArguments.lazy.map({ $0.name.count }).max() ?? 0
        let options = reflectOptions()
        let maxOptionWidth = options.lazy.map({ $0.name.count }).max() ?? 0
        let maxWidth = max(maxArgumentWidth, maxOptionWidth + 2)

        if !documentedArguments.isEmpty {
            let argumentDocumentation = documentedArguments
                .lazy
                .map({ argument in
                    let padding = String(repeating: " ", count: maxWidth - argument.name.count)
                    return "  \(argument.name)\(padding)    \(argument.argument.documentation!)"
                })
                .joined(separator: "\n")

            help += """


                ARGUMENTS:
                \(argumentDocumentation)
                """
        }

        if !options.isEmpty {
            let optionsDocumentation = options
                .lazy
                .map({ option in
                    let padding = String(repeating: " ", count: maxWidth - option.name.count - 2)

                    var rightColumnComponents: [String] = []
                    if let documentation = option.option.documentation {
                        rightColumnComponents.append(documentation)
                    }

                    if let defaultValue = option.option.defaultValue {
                        rightColumnComponents.append("[default: \(defaultValue.description)]")
                    }

                    let rightColumn = rightColumnComponents.joined(separator: " ")
                    return "  --\(option.name)\(padding)    \(rightColumn)"
                })
                .joined(separator: "\n")

            help += """


            OPTIONS:
            \(optionsDocumentation)
            """
        }

        return help
    }
}

private struct ArgumentInfo {
    let name: String
    let argument: ArgumentProtocol
}

private struct OptionInfo {
    let name: String
    let option: OptionProtocol
}

private extension Command {
    private func reflectArguments() -> [ArgumentInfo] {
        return Mirror(reflecting: self).children.compactMap({ child in
            if let argument = child.value as? ArgumentProtocol, let name = argument.name ?? child.label {
                return ArgumentInfo(name: name, argument: argument)
            } else {
                return nil
            }
        })
    }

    private func reflectOptions() -> [OptionInfo] {
        return Mirror(reflecting: self).children.compactMap({ child in
            if let option = child.value as? OptionProtocol, let name = option.name ?? child.label {
                return OptionInfo(name: name, option: option)
            } else {
                return nil
            }
        })
    }
}

//extension HelpDecoder {
//    func generateUsage(prefix: String) -> String {
//        var components: [String] = [prefix.trimmingCharacters(in: .whitespaces)]
//
//        if !optionalArguments.isEmpty {
//            components.append("[options]")
//        }
//
//        components.append(contentsOf: positionalArguments.map({ "<\($0.stringValue)>" }))
//
//        return components.joined(separator: " ")
//    }
//}

