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

class ToolTests: XCTestCase {
    func testInitializer() {
        let tool = Tool(name: "Name", version: "1.0", command: DummyCommand(documentation: ""))
        XCTAssertEqual(tool.name, "Name")
        XCTAssertEqual(tool.version, "1.0")
    }

    func testRunError() {
        var tool = Tool(name: "error", version: "1.0", command: ErrorCommand(parseError: DummyError()))
        tool.outputStream = ""
        tool.errorStream = ""
        tool.run()

        XCTAssertEqual(tool.outputStream as! String, "")
        XCTAssertEqual(tool.errorStream as! String, """
            error: The operation couldn’t be completed. (YaapTests.DummyError error 1.)
            """)

        tool = Tool(name: "error", version: "1.0", command: ErrorCommand(parseError: DummyLocalizedError()))
        tool.outputStream = ""
        tool.errorStream = ""
        tool.run()

        XCTAssertEqual(tool.outputStream as! String, "")
        XCTAssertEqual(tool.errorStream as! String, "error: dummy-localized-error")

        tool = Tool(name: "error", version: "1.0", command: ErrorCommand(runError: DummyError()))
        tool.outputStream = ""
        tool.errorStream = ""
        tool.run()

        XCTAssertEqual(tool.outputStream as! String, "")
        XCTAssertEqual(tool.errorStream as! String, """
            error: The operation couldn’t be completed. (YaapTests.DummyError error 1.)
            """)

        tool = Tool(name: "error", version: "1.0", command: ErrorCommand(runError: DummyLocalizedError()))
        tool.outputStream = ""
        tool.errorStream = ""
        tool.run()

        XCTAssertEqual(tool.outputStream as! String, "")
        XCTAssertEqual(tool.errorStream as! String, "error: dummy-localized-error")
    }
}
