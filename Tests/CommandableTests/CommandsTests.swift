import XCTest
@testable import Commandable

class CommandTests: XCTestCase {
    func test_generateUsage_minimal() {
        struct TestCommand: Command {
            func run() throws {}
        }

        XCTAssertEqual(TestCommand().generateUsage(prefix: "tool command"), """
            tool command
            """)
    }

    func test_generateUsage_parameters() {
        struct TestCommand: Command {
            let output = Argument<String>()
            let input = Argument<String>(name: "files")
            let times = Argument<Int>()
            let extra = Option<Int>(defaultValue: 1)
            let verbose = Option<Bool>(defaultValue: false)
            func run() throws {}
        }

        XCTAssertEqual(TestCommand().generateUsage(prefix: "tool command"), """
            tool command [options] <output> <files> <times>
            """)
    }

    func test_generateHelp_minimal() {
        struct TestCommand: Command {
            func run() throws {}
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool command"), """
            USAGE: tool command
            """)
    }

    func test_generateHelp_withDocumentation() {
        struct TestCommand: Command {
            let documentation = "This is great documentation"
            func run() throws {}
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool command"), """
            OVERVIEW: This is great documentation

            USAGE: tool command
            """)
    }

    func test_generateHelp_argumentsWithoutDocumentation() {
        struct TestCommand: Command {
            let documentation = "This is great documentation"
            let output = Argument<String>()
            let input = Argument<String>(name: "files")
            let times = Argument<Int>()
            func run() {}
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool command"), """
            OVERVIEW: This is great documentation

            USAGE: tool command <output> <files> <times>
            """)
    }

    func test_generateHelp_argumentsWithDocumentation() {
        struct TestCommand: Command {
            let documentation = "This is great documentation"
            let output = Argument<String>(documentation: "This is the output documentation")
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let times = Argument<Int>()
            func run() {}
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
        struct TestCommand: Command {
            let documentation = "This is great documentation"
            let output = Argument<String>(documentation: "This is the output documentation")
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let times = Argument<Int>()
            let extra = Option<Int>(defaultValue: 1)
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false)
            func run() throws {}
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
        struct TestCommand: Command {
            let documentation = "This is great documentation"
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let output = Argument<String>(documentation: "This is the output documentation")
            let times = Argument<Int>()
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false, documentation: "This is the verbose documentation")
            let extra = Option<Int>(defaultValue: 2, documentation: "This is the extra documentation")
            func run() throws {}
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
            "edit": DocumentationCommand(documentation: "The documentation for edit"),
            "unedit": DocumentationCommand(documentation: "The documentation for unedit"),
            "random": DocumentationCommand(documentation: "")
        ])

        XCTAssertEqual(command.generateUsage(prefix: "tool command"), """
            tool command subcommand
            """)
    }

    func test_generateHelp_subCommand() {
        let command = GroupCommand(commands: [
            "edit": DocumentationCommand(documentation: "The documentation for edit"),
            "unedit": DocumentationCommand(documentation: "The documentation for unedit"),
            "random": DocumentationCommand(documentation: "")
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

    static var allTests = [
        ("test_generateUsage_minimal", test_generateUsage_minimal),
        ("test_generateUsage_parameters", test_generateUsage_parameters),
        ("test_generateHelp_minimal", test_generateHelp_minimal),
        ("test_generateHelp_withDocumentation", test_generateHelp_withDocumentation),
        ("test_generateHelp_argumentsWithoutDocumentation", test_generateHelp_argumentsWithoutDocumentation),
        ("test_generateHelp_argumentsWithDocumentation", test_generateHelp_argumentsWithDocumentation),
        ("test_generateHelp_optionsWithoutDocumentation", test_generateHelp_optionsWithoutDocumentation),
        ("test_generateHelp_optionsWithDocumentation", test_generateHelp_optionsWithDocumentation),
        ("test_generateUsage_subCommand", test_generateUsage_subCommand),
        ("test_generateHelp_subCommand", test_generateHelp_subCommand),
    ]
}
