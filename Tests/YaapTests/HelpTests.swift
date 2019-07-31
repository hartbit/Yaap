import XCTest
@testable import Yaap

class HelpTests: XCTestCase {
    func testGenerateUsageMinimal() {
        XCTAssertEqual(Help().generateUsage(in: [DummyCommand(name: "tool"), DummyCommand(name: "command")]), """
            tool command
            """)
    }

    func testGenerateUsageParameters() {
        class TestCommand: Command {
            let name = "test"
            @Argument var output: String
            @Argument(name: "files") var input: String
            @Argument var times: Int
            @Option var extra = 1
            @Option var verbose = false

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        XCTAssertEqual(Help().generateUsage(in: [DummyCommand(name: "testing"), TestCommand()]), """
            testing test [options] <output> <files> <times>
            """)
    }

    func testGenerateUsageSubCommand() {
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

    func testGenerateHelpMinimal() {
        XCTAssertEqual(Help().generateHelp(in: [DummyCommand(name: "super"), DummyCommand(name: "tool")]), """
            USAGE: super tool
            """)
    }

    func testGenerateHelpWithDocumentation() {
        let command = DummyCommand(name: "dummy", documentation: "This is great documentation")
        XCTAssertEqual(Help().generateHelp(in: [command]), """
            OVERVIEW: This is great documentation

            USAGE: dummy
            """)
    }

    func testGenerateHelpArgumentsWithoutDocumentation() {
        class TestCommand: Command {
            let name = "test"
            let documentation = "This is great documentation"
            @Argument var output: String
            @Argument(name: "files") var input: String
            @Argument var times: Int

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        XCTAssertEqual(Help().generateHelp(in: [DummyCommand(name: "dummy"), TestCommand()]), """
            OVERVIEW: This is great documentation

            USAGE: dummy test <output> <files> <times>
            """)
    }

    func testGenerateHelpArgumentsWithDocumentation() {
        class TestCommand: Command {
            let name = "test"
            let documentation = "This is great documentation"
            @Argument(documentation: "This is the output documentation") var output: String
            @Argument(name: "files", documentation: "This is the input documentation") var input: String
            @Argument var times: Int

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

    func testGenerateHelpOptionsWithoutDocumentation() {
        class TestCommand: Command {
            let name = "testing"
            let documentation = "This is great documentation"
            @Argument(documentation: "This is the output documentation") var output: String
            @Argument(name: "files", documentation: "This is the input documentation") var input: String
            @Argument var times: Int
            @Option var extra = 1
            @Option(shorthand: "v") var verbose = false

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

    func testGenerateHelpOptionsWithDocumentation() {
        class TestCommand: Command {
            let name = "test"
            let documentation = "This is great documentation"
            @Argument(name: "files", documentation: "This is the input documentation") var input: String
            @Argument(documentation: "This is the output documentation") var output: String
            @Argument var times: Int
            @Option(shorthand: "v", documentation: "Verbose documentation") var verbose = false
            @Option(documentation: "This is the extra documentation") var extra = 2

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
              --verbose, -v    Verbose documentation [default: false]
            """)
    }

    func testGenerateHelpSubCommand() {
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

    func testValidate() {
        class TestCommand: Command {
            let name = "test"
            let documentation = "This is great documentation"
            let help = Help()

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        let command = TestCommand()

        var outputStream = "" as TextOutputStream
        var errorStream = "" as TextOutputStream
        XCTAssertExit(0, command.parseAndRun(
            arguments: ["--help"],
            outputStream: &outputStream,
            errorStream: &errorStream))
        XCTAssertEqual(errorStream as? String, "")
        XCTAssertEqual(outputStream as? String, """
            OVERVIEW: This is great documentation

            USAGE: test [options]

            OPTIONS:
              --help, -h    Display available options [default: false]

            """)

        outputStream = "" as TextOutputStream
        errorStream = "" as TextOutputStream
        XCTAssertExit(0, command.parseAndRun(
            arguments: ["-h"],
            outputStream: &outputStream,
            errorStream: &errorStream))
        XCTAssertEqual(errorStream as? String, "")
        XCTAssertEqual(outputStream as? String, """
            OVERVIEW: This is great documentation

            USAGE: test [options]

            OPTIONS:
              --help, -h    Display available options [default: false]

            """)
    }

    func testValidateCustomNameAndShorthand() {
        class TestCommand: Command {
            let name = "test"
            let documentation = "Ceci est une super documentation"
            let help = Help(name: "aide", shorthand: "a", documentation: "Afficher les options")

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        let command = TestCommand()

        var outputStream = "" as TextOutputStream
        var errorStream = "" as TextOutputStream
        XCTAssertExit(0, command.parseAndRun(
            arguments: ["--aide"],
            outputStream: &outputStream,
            errorStream: &errorStream))
        XCTAssertEqual(errorStream as? String, "")
        XCTAssertEqual(outputStream as? String, """
            OVERVIEW: Ceci est une super documentation

            USAGE: test [options]

            OPTIONS:
              --aide, -a    Afficher les options [default: false]

            """)

        outputStream = "" as TextOutputStream
        errorStream = "" as TextOutputStream
        XCTAssertExit(0, command.parseAndRun(
            arguments: ["-a"],
            outputStream: &outputStream,
            errorStream: &errorStream))
        XCTAssertEqual(errorStream as? String, "")
        XCTAssertEqual(outputStream as? String, """
            OVERVIEW: Ceci est une super documentation

            USAGE: test [options]

            OPTIONS:
              --aide, -a    Afficher les options [default: false]

            """)
    }
}
