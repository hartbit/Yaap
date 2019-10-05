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
            @Argument var input: String
            @Argument var times: Int
            @Option(shorthand: "v") var verbose = false
            @Option var extra = 2

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        let command = TestCommand()
        var arguments = ["--extra", "1", "inputfile.txt", "4"]
        try command.parse(arguments: &arguments)

        XCTAssertEqual(command.input, "inputfile.txt")
        XCTAssertEqual(command.times, 4)
        XCTAssertFalse(command.verbose)
        XCTAssertEqual(command.extra, 1)
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

        XCTAssertEqual(outputStream as? String, "")
        var errorString = errorStream as! String
        // Can't be more precise because Darwin and Linux don't print errors the same way.
        XCTAssert(errorString.starts(with: "\u{001B}[31merror:\u{001B}[0m The operation could"))
        XCTAssertEqual(errorString.last, "\n")

        command = ErrorCommand(parseError: DummyLocalizedError())
        outputStream = ""
        errorStream = ""
        XCTAssertExit(128, command.parseAndRun(arguments: [], outputStream: &outputStream, errorStream: &errorStream))

        XCTAssertEqual(outputStream as? String, "")
        XCTAssertEqual(errorStream as? String, "\u{001B}[31merror:\u{001B}[0m dummy-localized-error\n")

        command = ErrorCommand(runError: DummyError())
        outputStream = ""
        errorStream = ""
        XCTAssertExit(128, command.parseAndRun(arguments: [], outputStream: &outputStream, errorStream: &errorStream))

        XCTAssertEqual(outputStream as? String, "")
        errorString = errorStream as! String
        // Can't be more precise because Darwin and Linux don't print errors the same way.
        XCTAssert(errorString.starts(with: "\u{001B}[31merror:\u{001B}[0m The operation could"))
        XCTAssertEqual(errorString.last, "\n")

        command = ErrorCommand(runError: DummyLocalizedError())
        outputStream = ""
        errorStream = ""
        XCTAssertExit(128, command.parseAndRun(arguments: [], outputStream: &outputStream, errorStream: &errorStream))

        XCTAssertEqual(outputStream as? String, "")
        XCTAssertEqual(errorStream as? String, "\u{001B}[31merror:\u{001B}[0m dummy-localized-error\n")
    }
}
