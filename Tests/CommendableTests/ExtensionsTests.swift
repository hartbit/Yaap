import XCTest
@testable import Commendable

class ExtensionsTests: XCTestCase {
    // Tests come the following blog: https://oldfashionedsoftware.com/tag/levenshtein-distance/
    func testLevenshteinDistance() {
        // should work on empty strings
        XCTAssertEqual(levenshteinDistance(from: "", to: ""), 0)
        XCTAssertEqual(levenshteinDistance(from: "a", to: ""), 1)
        XCTAssertEqual(levenshteinDistance(from: "", to: "a"), 1)
        XCTAssertEqual(levenshteinDistance(from: "abc", to: ""), 3)
        XCTAssertEqual(levenshteinDistance(from: "", to: "abc"), 3)

        // should work on equal strings
        XCTAssertEqual(levenshteinDistance(from: "", to: ""), 0)
        XCTAssertEqual(levenshteinDistance(from: "a", to: "a"), 0)
        XCTAssertEqual(levenshteinDistance(from: "abc", to: "abc"), 0)

        // should work where only inserts are needed
        XCTAssertEqual(levenshteinDistance(from: "", to: "a"), 1)
        XCTAssertEqual(levenshteinDistance(from: "a", to: "ab"), 1)
        XCTAssertEqual(levenshteinDistance(from: "b", to: "ab"), 1)
        XCTAssertEqual(levenshteinDistance(from: "ac", to: "abc"), 1)
        XCTAssertEqual(levenshteinDistance(from: "abcdefg", to: "xabxcdxxefxgx"), 6)

        // stringDistance should work where only deletes are needed
        XCTAssertEqual(levenshteinDistance(from: "a", to: ""), 1)
        XCTAssertEqual(levenshteinDistance(from: "ab", to: "a"), 1)
        XCTAssertEqual(levenshteinDistance(from: "ab", to: "b"), 1)
        XCTAssertEqual(levenshteinDistance(from: "abc", to: "ac"), 1)
        XCTAssertEqual(levenshteinDistance(from: "xabxcdxxefxgx", to: "abcdefg"), 6)

        // stringDistance should work where only deletes are needed
        XCTAssertEqual(levenshteinDistance(from: "a", to: ""), 1)
        XCTAssertEqual(levenshteinDistance(from: "ab", to: "a"), 1)
        XCTAssertEqual(levenshteinDistance(from: "ab", to: "b"), 1)
        XCTAssertEqual(levenshteinDistance(from: "abc", to: "ac"), 1)
        XCTAssertEqual(levenshteinDistance(from: "xabxcdxxefxgx", to: "abcdefg"), 6)

        // should work where only substitutions are needed
        XCTAssertEqual(levenshteinDistance(from: "a", to: "b"), 1)
        XCTAssertEqual(levenshteinDistance(from: "ab", to: "ac"), 1)
        XCTAssertEqual(levenshteinDistance(from: "ac", to: "bc"), 1)
        XCTAssertEqual(levenshteinDistance(from: "abc", to: "axc"), 1)
        XCTAssertEqual(levenshteinDistance(from: "xabxcdxxefxgx", to: "1ab2cd34ef5g6"), 6)

        // should work where many operations are needed
        XCTAssertEqual(levenshteinDistance(from: "example", to: "samples"), 3)
        XCTAssertEqual(levenshteinDistance(from: "sturgeon", to: "urgently"), 6)
        XCTAssertEqual(levenshteinDistance(from: "levenshtein", to: "frankenstein"), 6)
        XCTAssertEqual(levenshteinDistance(from: "distance", to: "difference"), 5)
        XCTAssertEqual(levenshteinDistance(from: "objective-c was neat", to: "swift is great"), 14)
    }

    // Test with strings and substrings
    func levenshteinDistance(from: String, to: String, file: StaticString = #file, line: UInt = #line) -> Int {
        let stringDistance = from.levenshteinDistance(to: to)
        let fromSubstring = "before\(from)after".dropFirst(6).dropLast(5)
        let toSubstring = "prefix\(to)suffix".dropFirst(6).dropLast(6)
        let substringDistance = fromSubstring.levenshteinDistance(to: toSubstring)
        XCTAssertEqual(stringDistance, substringDistance, "difference between levenshtein distance of string and substring", file: file, line: line)
        return stringDistance
    }
}
