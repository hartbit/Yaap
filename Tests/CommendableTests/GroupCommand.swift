import XCTest
@testable import Commendable

class GroupCommandTests: XCTestCase {
    func testGenerateUsage() {
        let command = GroupCommand(commands: [
            "edit": Command(documentation: "The documentation for edit"),
            "unedit": Command(documentation: "The documentation for unedit"),
            "random": Command(documentation: "")
        ])

        XCTAssertEqual(command.generateUsage(prefix: "tool command"), """
            tool command subcommand
            """)
    }

    func testGenerateHelp() {
        let command = GroupCommand(commands: [
            "edit": Command(documentation: "The documentation for edit"),
            "unedit": Command(documentation: "The documentation for unedit"),
            "random": Command(documentation: "")
        ], documentation: "This is the group command documentation")

        XCTAssertEqual(command.generateHelp(usagePrefix: "tool"), """
            OVERVIEW: This is the group command documentation

            USAGE: tool subcommand

            SUBCOMMANDS:
              edit      The documentation for edit
              random    
              unedit    The documentation for unedit
            """)
    }
}
