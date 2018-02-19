import XCTest
@testable import Commandable

class CommandTests: XCTestCase {
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
            let input = Argument<String>(name: "files")
            let output = Argument<String>()
            let times = Argument<Int>()
            func run() {}
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool command"), """
            OVERVIEW: This is great documentation

            USAGE: tool command <files> <output> <times>
            """)
    }

    func test_generateHelp_argumentsWithDocumentation() {
        struct TestCommand: Command {
            let documentation = "This is great documentation"
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let output = Argument<String>(documentation: "This is the output documentation")
            let times = Argument<Int>()
            func run() {}
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool command"), """
            OVERVIEW: This is great documentation

            USAGE: tool command <files> <output> <times>

            ARGUMENTS:
              files     This is the input documentation
              output    This is the output documentation
            """)
    }

    func test_generateHelp_optionsWithoutDocumentation() {
        struct TestCommand: Command {
            let documentation = "This is great documentation"
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let output = Argument<String>(documentation: "This is the output documentation")
            let times = Argument<Int>()
            let extra = Option<Int>()
            let verbose = Option<Bool>(defaultValue: false)
            func run() throws {}
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool"), """
            OVERVIEW: This is great documentation

            USAGE: tool [options] <files> <output> <times>

            ARGUMENTS:
              files        This is the input documentation
              output       This is the output documentation

            OPTIONS:
              --extra      \n\
              --verbose    [default: false]
            """)
    }

    func test_generateHelp_optionsWithDocumentation() {
        struct TestCommand: Command {
            let documentation = "This is great documentation"
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let output = Argument<String>(documentation: "This is the output documentation")
            let times = Argument<Int>()
            let extra = Option<Int>(documentation: "This is the extra documentation")
            let verbose = Option<Bool>(defaultValue: false, documentation: "This is the verbose documentation")
            func run() throws {}
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool"), """
            OVERVIEW: This is great documentation

            USAGE: tool [options] <files> <output> <times>

            ARGUMENTS:
              files        This is the input documentation
              output       This is the output documentation

            OPTIONS:
              --extra      This is the extra documentation
              --verbose    This is the verbose documentation [default: false]
            """)
    }

    static var allTests = [
        ("test_generateHelp_minimal", test_generateHelp_minimal),
        ("test_generateHelp_withDocumentation", test_generateHelp_withDocumentation),
        ("test_generateHelp_argumentsWithoutDocumentation", test_generateHelp_argumentsWithoutDocumentation),
        ("test_generateHelp_argumentsWithDocumentation", test_generateHelp_argumentsWithDocumentation),
        ("test_generateHelp_optionsWithoutDocumentation", test_generateHelp_optionsWithoutDocumentation),
        ("test_generateHelp_optionsWithDocumentation", test_generateHelp_optionsWithDocumentation),
    ]
}
