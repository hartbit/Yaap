import XCTest
@testable import Yaap

class HelpTests: XCTestCase {
    func test_generateUsage_minimal() {
        XCTAssertEqual(Help().generateUsage(in: [DummyCommand(name: "tool"), DummyCommand(name: "command")]), """
            tool command
            """)
    }

    func test_generateUsage_parameters() {
        class TestCommand: Command {
            let name = "test"
            let output = Argument<String>()
            let input = Argument<String>(name: "files")
            let times = Argument<Int>()
            let extra = Option<Int>(defaultValue: 1)
            let verbose = Option<Bool>(defaultValue: false)

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        XCTAssertEqual(Help().generateUsage(in: [DummyCommand(name: "testing"), TestCommand()]), """
            testing test [options] <output> <files> <times>
            """)
    }

    func test_generateUsage_subCommand() {
        class GroupCommand: Command {
            let name = "group"
            let subcommand = SubCommand(commands: [
                DummyCommand(name: "edit"),
                DummyCommand(name: "unedit"),
                DummyCommand(name: "random")
                ])

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
                try subcommand.value?.run(outputStream: &outputStream, errorStream: &errorStream)
            }
        }

        XCTAssertEqual(Help().generateUsage(in: [GroupCommand()]), """
            group subcommand
            """)
    }

    func test_generateHelp_minimal() {
        XCTAssertEqual(Help().generateHelp(in: [DummyCommand(name: "super"), DummyCommand(name: "tool")]), """
            USAGE: super tool
            """)
    }

    func test_generateHelp_withDocumentation() {
        let command = DummyCommand(name: "dummy", documentation: "This is great documentation")
        XCTAssertEqual(Help().generateHelp(in: [command]), """
            OVERVIEW: This is great documentation

            USAGE: dummy
            """)
    }

    func test_generateHelp_argumentsWithoutDocumentation() {
        class TestCommand: Command {
            let name = "test"
            let documentation = "This is great documentation"
            let output = Argument<String>()
            let input = Argument<String>(name: "files")
            let times = Argument<Int>()

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        XCTAssertEqual(Help().generateHelp(in: [DummyCommand(name: "dummy"), TestCommand()]), """
            OVERVIEW: This is great documentation

            USAGE: dummy test <output> <files> <times>
            """)
    }

    func test_generateHelp_argumentsWithDocumentation() {
        class TestCommand: Command {
            let name = "test"
            let documentation = "This is great documentation"
            let output = Argument<String>(documentation: "This is the output documentation")
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let times = Argument<Int>()

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        XCTAssertEqual(Help().generateHelp(in: [TestCommand()]), """
            OVERVIEW: This is great documentation

            USAGE: test <output> <files> <times>

            ARGUMENTS:
              files     This is the input documentation
              output    This is the output documentation
            """)
    }

    func test_generateHelp_optionsWithoutDocumentation() {
        class TestCommand: Command {
            let name = "testing"
            let documentation = "This is great documentation"
            let output = Argument<String>(documentation: "This is the output documentation")
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let times = Argument<Int>()
            let extra = Option<Int>(defaultValue: 1)
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false)

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        XCTAssertEqual(Help().generateHelp(in: [DummyCommand(name: "prefix"), TestCommand()]), """
            OVERVIEW: This is great documentation

            USAGE: prefix testing [options] <output> <files> <times>

            ARGUMENTS:
              files            This is the input documentation
              output           This is the output documentation

            OPTIONS:
              --extra          [default: 1]
              --verbose, -v    [default: false]
            """)
    }

    func test_generateHelp_optionsWithDocumentation() {
        class TestCommand: Command {
            let name = "test"
            let documentation = "This is great documentation"
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let output = Argument<String>(documentation: "This is the output documentation")
            let times = Argument<Int>()
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false, documentation: "This is the verbose documentation")
            let extra = Option<Int>(defaultValue: 2, documentation: "This is the extra documentation")

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        XCTAssertEqual(Help().generateHelp(in: [TestCommand()]), """
            OVERVIEW: This is great documentation

            USAGE: test [options] <files> <output> <times>

            ARGUMENTS:
              files            This is the input documentation
              output           This is the output documentation

            OPTIONS:
              --extra          This is the extra documentation [default: 2]
              --verbose, -v    This is the verbose documentation [default: false]
            """)
    }

    func test_generateHelp_subCommand() {
        class GroupCommand: Command {
            let name = "group"
            let documentation: String = "This is the group command documentation"
            let subcommand = SubCommand(commands: [
                DummyCommand(name: "edit", documentation: "The documentation for edit"),
                DummyCommand(name: "unedit", documentation: "The documentation for unedit"),
                DummyCommand(name: "random", documentation: "")
            ])

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
                try subcommand.value?.run(outputStream: &outputStream, errorStream: &errorStream)
            }
        }

        XCTAssertEqual(Help().generateHelp(in: [DummyCommand(name: "dummy"), GroupCommand()]), """
            OVERVIEW: This is the group command documentation

            USAGE: dummy group subcommand

            SUBCOMMANDS:
              edit      The documentation for edit
              random    \n\
              unedit    The documentation for unedit
            """)
    }

}
