import Foundation

public enum CommandableError: Error {
    case invalidCommand(String)
}

public struct Tool {
    public enum Commands {
        case command(Command.Type)
        case subCommands([String: Commands])
    }

    let name: String
    let version: String
    let commands: Commands

    init(name: String, version: String, commands: Commands) {
        self.name = name
        self.version = version
        self.commands = commands
    }
}

extension Command {
    public static var command: Tool.Commands {
        return .command(self)
    }
}

extension Tool.Commands: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Tool.Commands)...) {
        self = .subCommands(Dictionary(uniqueKeysWithValues: elements))
    }
}

//struct Main: Command {
//    let documentation: String = "lol"
//    func run() { }
//}
//
//let tool1 = Tool(name: "tool", version: "1.0", command: Main.command)
//let tool2 = Tool(name: "tool", version: "1.0", command: [
//    "install": Main.command,
//    "package": [
//        "update": Main.command
//    ]
//])

//    public class StandardErrorOutputStream: TextOutputStream {
//        public func write(_ string: String) {
//            FileHandle.standardError.write(string.data(using: .utf8)!)
//        }
//    }
//    var stderr = StandardErrorOutputStream()
//    func parse(arguments: [String] = CommandLine.arguments) -> Command? {
//        do {
//            let decoder = CommandLineDecoder(arguments: arguments)
//            return try command.init(from: decoder)
//        } catch {
//            print(usage, to: &stderr)
//            print("🛑 \(error)", to: &stderr)
//            return nil
//        }
//    }
//
//    var usage: String {
//        let decoder = HelpDecoder()
//
//        do {
//            _ = try command.init(from: decoder)
//        } catch {
//            fatalError("invalid command: \(error)")
//        }
//
//        return decoder.generateUsage()
//    }
//
//    var help: String {
//        let decoder = HelpDecoder()
//
//        do {
//            _ = try command.init(from: decoder)
//        } catch {
//            fatalError("invalid command: \(error)")
//        }
//
//        return decoder.generateHelp()
//    }

//let tool = Tool(name: "visgen - Visage Generator", version: "1.0", command: MainCommand.self)
//tool.parse()?.run()
//let tool2 = Tool(version: "1.0", commands: [
//    "install": Commands.command(MainCommand.self),
//    "package": [
//        "update": Commands.command(MainCommand.self)
//    ]
//])

//public func execute(_ commandType: Command.Type, arguments: [String] = CommandLine.arguments) throws {
//    let decoder = CommandLineDecoder(arguments: arguments)
//    let command = try commandType.init(from: decoder)
//    command.run()
//}
//
//public func execute(_ declaration: CommandDeclaration, arguments: [String] = CommandLine.arguments) throws {
//}
//
//do {
//    execute(MainCommand.self)
//} catch {
//
//}
//execute(.subCommands([
//    "install": .command(InstallCommand.self),
//    "update": .command(UpdateCommand.self),
//    "package": .subCommands([
//        "install": .command(PackageInstallCommand.self),
//        "update": .command(PackageUpdateCommand.self)
//    ])
//]))


