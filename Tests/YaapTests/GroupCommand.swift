import XCTest
@testable import Yaap

class GroupCommandTests: XCTestCase {
    func test_generateUsage() {
        let command = GroupCommand(commands: [
            "edit": DummyCommand(documentation: "The documentation for edit"),
            "unedit": DummyCommand(documentation: "The documentation for unedit"),
            "random": DummyCommand(documentation: "")
        ])

        XCTAssertEqual(command.generateUsage(prefix: "tool command"), """
            tool command subcommand
            """)
    }

    func test_generateHelp() {
        let command = GroupCommand(commands: [
            "edit": DummyCommand(documentation: "The documentation for edit"),
            "unedit": DummyCommand(documentation: "The documentation for unedit"),
            "random": DummyCommand(documentation: "")
        ], documentation: "This is the group command documentation")

        XCTAssertEqual(command.generateHelp(usagePrefix: "tool"), """
            OVERVIEW: This is the group command documentation

            USAGE: tool subcommand

            SUBCOMMANDS:
              edit      The documentation for edit
              random    \n\
              unedit    The documentation for unedit
            """)
    }

    func test_parse() throws {
        class SimpleCommand: Command {
            let argument = Argument<String>()

            func run() throws {
            }
        }

        class EditCommand: SimpleCommand {}
        class UneditCommand: SimpleCommand {}
        class RandomCommand: SimpleCommand {}

        let command = GroupCommand(commands: [
            "edit": EditCommand(),
            "unedit": UneditCommand(),
            "random": RandomCommand()
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
