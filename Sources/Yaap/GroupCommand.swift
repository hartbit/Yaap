public class GroupCommand: Command {
    public let subcommand: SubCommand

    public init(commands: [String: Command], documentation: String = "") {
        subcommand = SubCommand(commands: commands)
        super.init(documentation: documentation)
    }

    public override func run(stdout: inout TextOutputStream, stderr: inout TextOutputStream) throws {
        try subcommand.value?.run(stdout: &stdout, stderr: &stderr)
    }
}
