public class GroupCommand: Command {
    public let documentation: String
    public let subcommand: SubCommand

    public init(commands: [String: Command], documentation: String = "") {
        self.documentation = documentation
        subcommand = SubCommand(commands: commands)
    }

    public func run() throws {
        try subcommand.value?.run()
    }
}
