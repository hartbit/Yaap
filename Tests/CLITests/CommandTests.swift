import XCTest
@testable import CLI

class CommandTests: XCTestCase {
    func test_generateUsage_minimal() {
        XCTAssertEqual(Command(documentation: "").generateUsage(prefix: "tool command"), """
            tool command
            """)
    }

    func test_generateUsage_parameters() {
        class TestCommand: Command {
            let output = Argument<String>()
            let input = Argument<String>(name: "files")
            let times = Argument<Int>()
            let extra = Option<Int>(defaultValue: 1)
            let verbose = Option<Bool>(defaultValue: false)

            init() {
                super.init(documentation: "")
            }
        }

        XCTAssertEqual(TestCommand().generateUsage(prefix: "tool command"), """
            tool command [options] <output> <files> <times>
            """)
    }

    func test_generateHelp_minimal() {
        XCTAssertEqual(Command(documentation: "").generateHelp(usagePrefix: "tool command"), """
            USAGE: tool command
            """)
    }

    func test_generateHelp_withDocumentation() {
        let command = Command(documentation: "This is great documentation")
        XCTAssertEqual(command.generateHelp(usagePrefix: "tool command"), """
            OVERVIEW: This is great documentation

            USAGE: tool command
            """)
    }

    func test_generateHelp_argumentsWithoutDocumentation() {
        class TestCommand: Command {
            let output = Argument<String>()
            let input = Argument<String>(name: "files")
            let times = Argument<Int>()

            init() {
                super.init(documentation: "This is great documentation")
            }
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool command"), """
            OVERVIEW: This is great documentation

            USAGE: tool command <output> <files> <times>
            """)
    }

    func test_generateHelp_argumentsWithDocumentation() {
        class TestCommand: Command {
            let output = Argument<String>(documentation: "This is the output documentation")
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let times = Argument<Int>()

            init() {
                super.init(documentation: "This is great documentation")
            }
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool command"), """
            OVERVIEW: This is great documentation

            USAGE: tool command <output> <files> <times>

            ARGUMENTS:
              files     This is the input documentation
              output    This is the output documentation
            """)
    }

    func test_generateHelp_optionsWithoutDocumentation() {
        class TestCommand: Command {
            let output = Argument<String>(documentation: "This is the output documentation")
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let times = Argument<Int>()
            let extra = Option<Int>(defaultValue: 1)
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false)

            init() {
                super.init(documentation: "This is great documentation")
            }
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool"), """
            OVERVIEW: This is great documentation

            USAGE: tool [options] <output> <files> <times>

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
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let output = Argument<String>(documentation: "This is the output documentation")
            let times = Argument<Int>()
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false, documentation: "This is the verbose documentation")
            let extra = Option<Int>(defaultValue: 2, documentation: "This is the extra documentation")

            init() {
                super.init(documentation: "This is great documentation")
            }
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool"), """
            OVERVIEW: This is great documentation

            USAGE: tool [options] <files> <output> <times>

            ARGUMENTS:
              files            This is the input documentation
              output           This is the output documentation

            OPTIONS:
              --extra          This is the extra documentation [default: 2]
              --verbose, -v    This is the verbose documentation [default: false]
            """)
    }

    func test_generateUsage_subCommand() {
        let command = GroupCommand(commands: [
            "edit": Command(documentation: "The documentation for edit"),
            "unedit": Command(documentation: "The documentation for unedit"),
            "random": Command(documentation: "")
        ])

        XCTAssertEqual(command.generateUsage(prefix: "tool command"), """
            tool command subcommand
            """)
    }

    func test_generateHelp_subCommand() {
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
