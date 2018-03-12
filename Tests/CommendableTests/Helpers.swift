import Foundation
import XCTest
import Commendable

extension ArgumentHelp: Equatable {
    public static func == (lhs: ArgumentHelp, rhs: ArgumentHelp) -> Bool {
        return lhs.category == rhs.category &&
            lhs.label == rhs.label &&
            lhs.description == rhs.description
    }
}

extension ArgumentType {
    init(arguments: [String], leftover: inout [String]) throws {
        var iterator = arguments.makeIterator()
        try self.init(arguments: &iterator)
        leftover = Array(iterator)
    }
}

extension ArgumentParser {
    func parse(arguments: [String], leftover: inout [String]) throws {
        var iterator = arguments.makeIterator()
        try parse(arguments: &iterator)
        leftover = Array(iterator)
    }
}

func XCTAssertThrowsError<T, E: Error & Equatable>(
    _ expression: @autoclosure () throws -> T,
    equals expectedError: E,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertThrowsError(expression, "should have thrown", file: file, line: line, { thrownError in
        XCTAssert(thrownError as? E == expectedError, "\(thrownError) si not equal to \(expectedError)", file: file, line: line)
    })
}
