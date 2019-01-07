import XCTest
@testable import Yaap

struct DummyError: Error {
}

struct DummyLocalizedError: LocalizedError {
    var errorDescription: String? {
        return "dummy-localized-error"
    }
}

class ErrorCommand: Command {
    private let parseError: Error?
    private let runError: Error?

    init(parseError: Error? = nil, runError: Error? = nil) {
        self.parseError = parseError
        self.runError = runError
    }

    @discardableResult
    public func parse(arguments: inout [String]) throws -> Bool {
        if let parseError = parseError {
            throw parseError
        }

        return true
    }

    func run() throws {
        if let runError = runError {
            throw runError
        }
    }
}

func XCTAssertExit(
    _ expectedCode: Int32,
    _ closure: @autoclosure () -> Void,
    file: StaticString = #file,
    line: UInt = #line
) {
    var hasExited = false
    let previousExit = exitProcess
    exitProcess = { (code: Int32) -> Void in
        XCTAssertEqual(code, expectedCode, file: file, line: line)
        hasExited = true
    }
    defer {
        exitProcess = previousExit
    }

    closure()
    XCTAssert(hasExited, file: file, line: line)
}

class CommandTests: XCTestCase {
    func test_generateUsage_minimal() {
        XCTAssertEqual(DummyCommand().generateUsage(prefix: "tool command"), """
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

            func run() throws {
            }
        }

        XCTAssertEqual(TestCommand().generateUsage(prefix: "tool command"), """
            tool command [options] <output> <files> <times>
            """)
    }

    func test_generateHelp_minimal() {
        XCTAssertEqual(DummyCommand().generateHelp(usagePrefix: "tool command"), """
            USAGE: tool command
            """)
    }

    func test_generateHelp_withDocumentation() {
        let command = DummyCommand(documentation: "This is great documentation")
        XCTAssertEqual(command.generateHelp(usagePrefix: "tool command"), """
            OVERVIEW: This is great documentation

            USAGE: tool command
            """)
    }

    func test_generateHelp_argumentsWithoutDocumentation() {
        class TestCommand: Command {
            let documentation = "This is great documentation"
            let output = Argument<String>()
            let input = Argument<String>(name: "files")
            let times = Argument<Int>()

            func run() throws {
            }
        }

        XCTAssertEqual(TestCommand().generateHelp(usagePrefix: "tool command"), """
            OVERVIEW: This is great documentation

            USAGE: tool command <output> <files> <times>
            """)
    }

    func test_generateHelp_argumentsWithDocumentation() {
        class TestCommand: Command {
            let documentation = "This is great documentation"
            let output = Argument<String>(documentation: "This is the output documentation")
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let times = Argument<Int>()

            func run() throws {
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
            let documentation = "This is great documentation"
            let output = Argument<String>(documentation: "This is the output documentation")
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let times = Argument<Int>()
            let extra = Option<Int>(defaultValue: 1)
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false)

            func run() throws {
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
            let documentation = "This is great documentation"
            let input = Argument<String>(name: "files", documentation: "This is the input documentation")
            let output = Argument<String>(documentation: "This is the output documentation")
            let times = Argument<Int>()
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false, documentation: "This is the verbose documentation")
            let extra = Option<Int>(defaultValue: 2, documentation: "This is the extra documentation")

            func run() throws {
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
            "edit": DummyCommand(),
            "unedit": DummyCommand(),
            "random": DummyCommand()
        ])

        XCTAssertEqual(command.generateUsage(prefix: "tool command"), """
            tool command subcommand
            """)
    }

    func test_generateHelp_subCommand() {
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
        class TestCommand: Command {
            let input = Argument<String>()
            let times = Argument<Int>()
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false)
            let extra = Option<Int>(defaultValue: 2)

            func run() throws {
            }
        }

        let command = TestCommand()
        var arguments = ["--extra", "1", "inputfile.txt", "4"]
        try command.parse(arguments: &arguments)

        XCTAssertEqual(command.input.value, "inputfile.txt")
        XCTAssertEqual(command.times.value, 4)
        XCTAssertEqual(command.verbose.value, false)
        XCTAssertEqual(command.extra.value, 1)
    }

    func test_parse_unexpectedArgument() {
        class TestCommand: Command {
            func run() throws {
            }
        }

        let command = TestCommand()
        var arguments = ["something"]
        XCTAssertThrowsError(try command.parse(arguments: &arguments), "", { error in
            guard let expectedError = error as? CommandUnexpectedArgumentError else {
                XCTFail("incorrect error")
                return
            }

            XCTAssertEqual(expectedError, CommandUnexpectedArgumentError(argument: "something"))
            XCTAssertEqual(expectedError.errorDescription, "unexpected argument 'something'")
        })
    }

    func testParseAndRunError() {
        var command = ErrorCommand(parseError: DummyError())
        var outputStream: TextOutputStream = ""
        var errorStream: TextOutputStream = ""
        XCTAssertExit(128, command.parseAndRun(arguments: [], outputStream: &outputStream, errorStream: &errorStream))

        XCTAssertEqual(outputStream as! String, "")
        XCTAssertEqual(errorStream as! String, """
            \u{001B}[31merror:\u{001B}[0m The operation couldn’t be completed. (YaapTests.DummyError error 1.)

            """)

        command = ErrorCommand(parseError: DummyLocalizedError())
        outputStream = ""
        errorStream = ""
        XCTAssertExit(128, command.parseAndRun(arguments: [], outputStream: &outputStream, errorStream: &errorStream))

        XCTAssertEqual(outputStream as! String, "")
        XCTAssertEqual(errorStream as! String, """
            \u{001B}[31merror:\u{001B}[0m dummy-localized-error

            """)

        command = ErrorCommand(runError: DummyError())
        outputStream = ""
        errorStream = ""
        XCTAssertExit(128, command.parseAndRun(arguments: [], outputStream: &outputStream, errorStream: &errorStream))

        XCTAssertEqual(outputStream as! String, "")
        XCTAssertEqual(errorStream as! String, """
            \u{001B}[31merror:\u{001B}[0m The operation couldn’t be completed. (YaapTests.DummyError error 1.)

            """)

        command = ErrorCommand(runError: DummyLocalizedError())
        outputStream = ""
        errorStream = ""
        XCTAssertExit(128, command.parseAndRun(arguments: [], outputStream: &outputStream, errorStream: &errorStream))

        XCTAssertEqual(outputStream as! String, "")
        XCTAssertEqual(errorStream as! String, """
            \u{001B}[31merror:\u{001B}[0m dummy-localized-error

            """)
    }
}
