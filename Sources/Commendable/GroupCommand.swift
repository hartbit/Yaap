public class GroupCommand: Command {
    public let subcommand: SubCommand

    public init(commands: [String: Command], documentation: String = "") {
        subcommand = SubCommand(commands: commands)
        super.init(documentation: documentation)
    }

    public override func run() throws {
        try subcommand.value.run()
    }
}
