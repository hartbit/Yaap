import XCTest
@testable import Commendable

class ArgumentTypesTests: XCTestCase {
    func test_string_noValue() {
        var leftover: [String] = []
        XCTAssertThrowsError(try String(arguments: [], leftover: &leftover))
    }

    func test_string_validValue() {
        var leftover: [String] = []
        XCTAssertEqual(try String(arguments: ["hello", "world"], leftover: &leftover), "hello")
        XCTAssertEqual(leftover, ["world"])
    }

    func test_bool_noValue() throws {
        var leftover: [String] = []
        XCTAssertThrowsError(try Bool(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
    }

    func test_bool_invalidValue() {
        var leftover: [String] = []
        XCTAssertThrowsError(try Bool(arguments: ["0"], leftover: &leftover), equals: ParseError.invalidFormat("0"))
        XCTAssertThrowsError(try Bool(arguments: ["hello"], leftover: &leftover), equals: ParseError.invalidFormat("hello"))
    }

    func test_bool_validValue() {
        var leftover: [String] = []
        XCTAssertEqual(try Bool(arguments: ["true", "false"], leftover: &leftover), true)
        XCTAssertEqual(leftover, ["false"])
        XCTAssertEqual(try Bool(arguments: ["false", "hello"], leftover: &leftover), false)
        XCTAssertEqual(leftover, ["hello"])
    }

    func test_integers_noValue() {
        var leftover: [String] = []
        XCTAssertThrowsError(try Int(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Int8(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Int16(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Int32(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Int64(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt8(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt16(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt32(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt64(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
    }

    func test_integers_invalidValue() {
        var leftover: [String] = []
        XCTAssertThrowsError(try Int(arguments: ["two"], leftover: &leftover), equals: ParseError.invalidFormat("two"))
        XCTAssertThrowsError(try Int8(arguments: ["-129"], leftover: &leftover), equals: ParseError.invalidFormat("-129"))
        XCTAssertThrowsError(try Int16(arguments: ["4834984935"], leftover: &leftover), equals: ParseError.invalidFormat("4834984935"))
        XCTAssertThrowsError(try Int32(arguments: ["really"], leftover: &leftover), equals: ParseError.invalidFormat("really"))
        XCTAssertThrowsError(try Int64(arguments: ["2.6"], leftover: &leftover), equals: ParseError.invalidFormat("2.6"))
        XCTAssertThrowsError(try UInt(arguments: ["three"], leftover: &leftover), equals: ParseError.invalidFormat("three"))
        XCTAssertThrowsError(try UInt8(arguments: ["-2"], leftover: &leftover), equals: ParseError.invalidFormat("-2"))
        XCTAssertThrowsError(try UInt16(arguments: ["10e45"], leftover: &leftover), equals: ParseError.invalidFormat("10e45"))
        XCTAssertThrowsError(try UInt32(arguments: ["totally"], leftover: &leftover), equals: ParseError.invalidFormat("totally"))
        XCTAssertThrowsError(try UInt64(arguments: ["big"], leftover: &leftover), equals: ParseError.invalidFormat("big"))
    }

    func test_integers_validValue() {
        var leftover: [String] = []
        XCTAssertEqual(try Int(arguments: ["4", "3", "other"], leftover: &leftover), 4)
        XCTAssertEqual(leftover, ["3", "other"])
        XCTAssertEqual(try Int8(arguments: ["-128", "256", "other"], leftover: &leftover), -128)
        XCTAssertEqual(leftover, ["256", "other"])
        XCTAssertEqual(try Int16(arguments: ["58", "hello", "world"], leftover: &leftover), 58)
        XCTAssertEqual(leftover, ["hello", "world"])
        XCTAssertEqual(try Int32(arguments: ["95", "mr", "small"], leftover: &leftover), 95)
        XCTAssertEqual(leftover, ["mr", "small"])
        XCTAssertEqual(try Int64(arguments: ["-29", "smell", "5"], leftover: &leftover), -29)
        XCTAssertEqual(leftover, ["smell", "5"])
        XCTAssertEqual(try UInt(arguments: ["4", "3", "other"], leftover: &leftover), 4)
        XCTAssertEqual(leftover, ["3", "other"])
        XCTAssertEqual(try UInt8(arguments: ["128", "256", "other"], leftover: &leftover), 128)
        XCTAssertEqual(leftover, ["256", "other"])
        XCTAssertEqual(try UInt16(arguments: ["58", "hello", "world"], leftover: &leftover), 58)
        XCTAssertEqual(leftover, ["hello", "world"])
        XCTAssertEqual(try UInt32(arguments: ["95", "mr", "small"], leftover: &leftover), 95)
        XCTAssertEqual(leftover, ["mr", "small"])
        XCTAssertEqual(try UInt64(arguments: ["29", "smell", "5"], leftover: &leftover), 29)
        XCTAssertEqual(leftover, ["smell", "5"])
    }

    func test_floatingPoints_noValue() {
        var leftover: [String] = []
        XCTAssertThrowsError(try Float(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Double(arguments: [], leftover: &leftover), equals: ParseError.missingArgument)
    }

    func test_floatingPoints_invalidValue() {
        var leftover: [String] = []
        XCTAssertThrowsError(try Float(arguments: ["two"], leftover: &leftover), equals: ParseError.invalidFormat("two"))
        XCTAssertThrowsError(try Double(arguments: ["74eff"], leftover: &leftover), equals: ParseError.invalidFormat("74eff"))
    }

    func test_floatingPoints_validValue() {
        var leftover: [String] = []
        XCTAssertEqual(try Float(arguments: ["2.5", "3", "other"], leftover: &leftover), 2.5)
        XCTAssertEqual(leftover, ["3", "other"])
        XCTAssertEqual(try Float(arguments: ["56", "256", "other"], leftover: &leftover), 56)
        XCTAssertEqual(leftover, ["256", "other"])
        XCTAssertEqual(try Double(arguments: ["5e10", "hello", "world"], leftover: &leftover), 5e10)
        XCTAssertEqual(leftover, ["hello", "world"])
        XCTAssertEqual(try Double(arguments: ["7.84394", "mr", "small"], leftover: &leftover), 7.84394)
        XCTAssertEqual(leftover, ["mr", "small"])
    }

    func test_collections_noValue() {
        var leftover: [String] = []
        XCTAssertEqual(try [String](arguments: [], leftover: &leftover), [])
        XCTAssertEqual(try Set<Int>(arguments: [], leftover: &leftover), [])
    }

    func test_collections_invalidValue() {
        var leftover: [String] = []
        XCTAssertThrowsError(try [Int](arguments: ["invalid"], leftover: &leftover), equals: ParseError.invalidFormat("invalid"))
        XCTAssertThrowsError(try Set<Float>(arguments: ["5", "not"], leftover: &leftover), equals: ParseError.invalidFormat("not"))
    }

    func test_collections_validValue() {
        var leftover: [String] = []
        XCTAssertEqual(try [String](arguments: ["hello", "world", "!"], leftover: &leftover), ["hello", "world", "!"])
        XCTAssertEqual(leftover, [])
        XCTAssertEqual(try Set<Int>(arguments: ["4", "-2", "8", "-2"], leftover: &leftover), Set([4, -2, 8]))
        XCTAssertEqual(leftover, [])
    }

    static var allTests = [
        ("test_string_noValue", test_string_noValue),
        ("test_string_validValue", test_string_validValue),
        ("test_bool_noValue", test_bool_noValue),
        ("test_bool_invalidValue", test_bool_invalidValue),
        ("test_bool_validValue", test_bool_validValue),
        ("test_integers_noValue", test_integers_noValue),
        ("test_integers_invalidValue", test_integers_invalidValue),
        ("test_integers_validValue", test_integers_validValue),
        ("test_floatingPoints_noValue", test_floatingPoints_noValue),
        ("test_floatingPoints_invalidValue", test_floatingPoints_invalidValue),
        ("test_floatingPoints_validValue", test_floatingPoints_validValue),
        ("test_collections_noValue", test_collections_noValue),
        ("test_collections_invalidValue", test_collections_invalidValue),
        ("test_collections_validValue", test_collections_validValue),
    ]
}
