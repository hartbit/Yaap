import XCTest
@testable import CLI

class GroupCommandTests: XCTestCase {
    func test_generateUsage() {
        let command = GroupCommand(commands: [
            "edit": Command(documentation: "The documentation for edit"),
            "unedit": Command(documentation: "The documentation for unedit"),
            "random": Command(documentation: "")
        ])

        XCTAssertEqual(command.generateUsage(prefix: "tool command"), """
            tool command [options] subcommand
            """)
    }

    func test_generateHelp() {
        let command = GroupCommand(commands: [
            "edit": Command(documentation: "The documentation for edit"),
            "unedit": Command(documentation: "The documentation for unedit"),
            "random": Command(documentation: "")
        ], documentation: "This is the group command documentation")

        XCTAssertEqual(command.generateHelp(usagePrefix: "tool"), """
            OVERVIEW: This is the group command documentation

            USAGE: tool [options] subcommand

            OPTIONS:
              --help, -h    Print command documentation [default: false]

            SUBCOMMANDS:
              edit          The documentation for edit
              random        \n\
              unedit        The documentation for unedit
            """)
    }

    func test_parse() throws {
        class SimpleCommand: Command {
            let argument = Argument<String>()
        }

        class EditCommand: SimpleCommand {}
        class UneditCommand: SimpleCommand {}
        class RandomCommand: SimpleCommand {}

        let command = GroupCommand(commands: [
            "edit": EditCommand(documentation: "The documentation for edit"),
            "unedit": UneditCommand(documentation: "The documentation for unedit"),
            "random": RandomCommand(documentation: "The documentation for random")
        ])

        var arguments = ["edit", "something"]
        try command.parse(arguments: &arguments)
        XCTAssertTrue(command.subcommand.value is EditCommand)
        XCTAssertEqual((command.subcommand.value as? EditCommand)?.argument.value, "something")

        arguments = ["unedit", "something-else"]
        try command.parse(arguments: &arguments)
        XCTAssertTrue(command.subcommand.value is UneditCommand)
        XCTAssertEqual((command.subcommand.value as? UneditCommand)?.argument.value, "something-else")
    }
}
