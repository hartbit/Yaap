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
    let name = "error"
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

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
        if let runError = runError {
            throw runError
        }
    }
}

class CommandTests: XCTestCase {
    func testParse() throws {
        class TestCommand: Command {
            let name = "test"
            let input = Argument<String>()
            let times = Argument<Int>()
            let verbose = Option<Bool>(shorthand: "v", defaultValue: false)
            let extra = Option<Int>(defaultValue: 2)

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
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

    func testParseUnexpectedArgument() {
        class TestCommand: Command {
            let name = "test"

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
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
