import Foundation
import XCTest
@testable import Yaap

class DummyCommand: Command {
    let name: String
    let documentation: String

    init(name: String, documentation: String = "") {
        self.name = name
        self.documentation = documentation
    }

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
    }
}

class MockCommand: Command {
    let name = "mock"
    private(set) var arguments: [String] = []

    func parse(arguments: inout [String]) throws -> Bool {
        self.arguments = arguments
        arguments.removeAll()
        return true
    }

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
    }
}

func XCTAssertThrowsError<T, E: Error & Equatable>(
    _ expression: @autoclosure () throws -> T,
    equals expectedError: E,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertThrowsError(expression, "should have thrown", file: file, line: line, { thrownError in
        XCTAssert(
            thrownError as? E == expectedError,
            "\(thrownError) si not equal to \(expectedError)",
            file: file,
            line: line)
    })
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
