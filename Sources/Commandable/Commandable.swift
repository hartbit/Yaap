public protocol Command: Decodable {
    var documentation: String { get }
    func run()
}

public protocol CommandArgumentCodingKey: CodingKey {
    var documentation: String { get }
    var shortStringValue: String? { get }
}

public struct SubCommands: Command {
    public let commands: [String: Command]

    public init(_ commands: [String: Command]) {
        self.commands = commands
    }

    public run() {
    }
}

public enum CommandableError: Error {
    case invalidCommand(String)
}

public enum CommandDeclaration {
    case command(Command.Type)
    case subCommands([String: Command])
}

public func execute(_ commandType: Command.self) {
    execute(.command(commandType))
}

public func execute(_ declaration: CommandDeclaration) {
    let decoder = CommandLineDecoder()
    let command = try commandType.init(from: decoder)
    command.run()
}

execute(MainCommand.self)
execute(.subCommands([
    "install": .command(InstallCommand.self),
    "update": .command(UpdateCommand.self),
    "package": .subCommands([
        "install": .command(PackageInstallCommand.self),
        "update": .command(PackageUpdateCommand.self)
    ])
]))