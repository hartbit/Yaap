import XCTest
@testable import Commandable

struct DocCommand: Command {
    let documentation: String

    init(documentation: String) {
        self.documentation = documentation
    }

    func run() throws {}
}

class GroupCommandTests: XCTestCase {
//    let group = GroupCommand(subcommands: [
//        "gen-foo": DocCommand(documentation: "Generates foos"),
//        "bar": DocCommand(documentation: "Does a bar"),
//    ], documentation: "This is a great command")

    func test_generateUsage() {
//        XCTAssertEqual(GroupCommand(subcommands: [:]).generateUsage(prefix: "mytool"), """
//            mytool <subcommand>
//            """)
    }

    func test_generateHelp() {
//        XCTAssertEqual(group.generateHelp(usagePrefix: "tool"), """
//            OVERVIEW: This is a great command
//
//            USAGE: tool <subcommand>
//
//            SUBCOMMANDS:
//                gen-foo    Generates foos
//                bar        Does a bar
//            """)
    }

    static var allTests = [
        ("test_generateUsage", test_generateUsage),
        ("test_generateHelp", test_generateHelp)
    ]
}

