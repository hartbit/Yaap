import Foundation
import XCTest
import Yaap

class DummyCommand: Command {
    let documentation: String

    init(documentation: String = "") {
        self.documentation = documentation
    }

    func run() throws {
    }
}

class MockCommand: Command {
    private(set) var arguments: [String] = []

    func parse(arguments: inout [String]) throws -> Bool {
        self.arguments = arguments
        arguments.removeAll()
        return true
    }

    func run() throws {
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
