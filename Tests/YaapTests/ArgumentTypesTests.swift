import XCTest
@testable import Yaap

class ArgumentTypesTests: XCTestCase {
    func test_string_noValue() {
        var arguments: [String] = []
        XCTAssertThrowsError(try String(arguments: &arguments), equals: ParseError.missingArgument)
    }

    func test_string_validValue() {
        var arguments = ["hello", "world"]
        XCTAssertEqual(try String(arguments: &arguments), "hello")
        XCTAssertEqual(arguments, ["world"])
    }

    func test_bool_noValue() throws {
        var arguments: [String] = []
        XCTAssertThrowsError(try Bool(arguments: &arguments), equals: ParseError.missingArgument)
    }

    func test_bool_invalidValue() {
        var arguments = ["0"]
        XCTAssertThrowsError(try Bool(arguments: &arguments), equals: ParseError.invalidFormat("0"))
        arguments = ["hello"]
        XCTAssertThrowsError(try Bool(arguments: &arguments), equals: ParseError.invalidFormat("hello"))
    }

    func test_bool_validValue() {
        var arguments = ["true", "false"]
        XCTAssertEqual(try Bool(arguments: &arguments), true)
        XCTAssertEqual(arguments, ["false"])

        arguments = ["false", "hello"]
        XCTAssertEqual(try Bool(arguments: &arguments), false)
        XCTAssertEqual(arguments, ["hello"])
    }

    func test_integers_noValue() {
        var arguments: [String] = []
        XCTAssertThrowsError(try Int(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Int8(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Int16(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Int32(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Int64(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt8(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt16(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt32(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try UInt64(arguments: &arguments), equals: ParseError.missingArgument)
    }

    func test_integers_invalidValue() {
        var arguments = ["two"]
        XCTAssertThrowsError(try Int(arguments: &arguments), equals: ParseError.invalidFormat("two"))
        XCTAssertEqual(arguments, ["two"])

        arguments = ["-129"]
        XCTAssertThrowsError(try Int8(arguments: &arguments), equals: ParseError.invalidFormat("-129"))
        XCTAssertEqual(arguments, ["-129"])

        arguments = ["4834984935"]
        XCTAssertThrowsError(try Int16(arguments: &arguments), equals: ParseError.invalidFormat("4834984935"))
        XCTAssertEqual(arguments, ["4834984935"])

        arguments = ["really"]
        XCTAssertThrowsError(try Int32(arguments: &arguments), equals: ParseError.invalidFormat("really"))
        XCTAssertEqual(arguments, ["really"])

        arguments = ["2.6"]
        XCTAssertThrowsError(try Int64(arguments: &arguments), equals: ParseError.invalidFormat("2.6"))
        XCTAssertEqual(arguments, ["2.6"])

        arguments = ["three"]
        XCTAssertThrowsError(try UInt(arguments: &arguments), equals: ParseError.invalidFormat("three"))
        XCTAssertEqual(arguments, ["three"])

        arguments = ["-2"]
        XCTAssertThrowsError(try UInt8(arguments: &arguments), equals: ParseError.invalidFormat("-2"))
        XCTAssertEqual(arguments, ["-2"])

        arguments = ["10e45"]
        XCTAssertThrowsError(try UInt16(arguments: &arguments), equals: ParseError.invalidFormat("10e45"))
        XCTAssertEqual(arguments, ["10e45"])

        arguments = ["totally"]
        XCTAssertThrowsError(try UInt32(arguments: &arguments), equals: ParseError.invalidFormat("totally"))
        XCTAssertEqual(arguments, ["totally"])

        arguments = ["big"]
        XCTAssertThrowsError(try UInt64(arguments: &arguments), equals: ParseError.invalidFormat("big"))
        XCTAssertEqual(arguments, ["big"])
    }

    func test_integers_validValue() {
        var arguments = ["4", "-128", "58", "95", "-29", "4", "128", "58", "95", "29", "other"]
        XCTAssertEqual(try Int(arguments: &arguments), 4)
        XCTAssertEqual(arguments, ["-128", "58", "95", "-29", "4", "128", "58", "95", "29", "other"])
        XCTAssertEqual(try Int8(arguments: &arguments), -128)
        XCTAssertEqual(arguments, ["58", "95", "-29", "4", "128", "58", "95", "29", "other"])
        XCTAssertEqual(try Int16(arguments: &arguments), 58)
        XCTAssertEqual(arguments, ["95", "-29", "4", "128", "58", "95", "29", "other"])
        XCTAssertEqual(try Int32(arguments: &arguments), 95)
        XCTAssertEqual(arguments, ["-29", "4", "128", "58", "95", "29", "other"])
        XCTAssertEqual(try Int64(arguments: &arguments), -29)
        XCTAssertEqual(arguments, ["4", "128", "58", "95", "29", "other"])
        XCTAssertEqual(try UInt(arguments: &arguments), 4)
        XCTAssertEqual(arguments, ["128", "58", "95", "29", "other"])
        XCTAssertEqual(try UInt8(arguments: &arguments), 128)
        XCTAssertEqual(arguments, ["58", "95", "29", "other"])
        XCTAssertEqual(try UInt16(arguments: &arguments), 58)
        XCTAssertEqual(arguments, ["95", "29", "other"])
        XCTAssertEqual(try UInt32(arguments: &arguments), 95)
        XCTAssertEqual(arguments, ["29", "other"])
        XCTAssertEqual(try UInt64(arguments: &arguments), 29)
        XCTAssertEqual(arguments, ["other"])
    }

    func test_floatingPoints_noValue() {
        var arguments: [String] = []
        XCTAssertThrowsError(try Float(arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Double(arguments: &arguments), equals: ParseError.missingArgument)
    }

    func test_floatingPoints_invalidValue() {
        var arguments = ["two"]
        XCTAssertThrowsError(try Float(arguments: &arguments), equals: ParseError.invalidFormat("two"))
        XCTAssertEqual(arguments, ["two"])

        arguments = ["74eff"]
        XCTAssertThrowsError(try Double(arguments: &arguments), equals: ParseError.invalidFormat("74eff"))
        XCTAssertEqual(arguments, ["74eff"])
    }

    func test_floatingPoints_validValue() {
        var arguments = ["2.5", "56", "5e10", "7.84394", "hello", "world"]
        XCTAssertEqual(try Float(arguments: &arguments), 2.5)
        XCTAssertEqual(arguments, ["56", "5e10", "7.84394", "hello", "world"])
        XCTAssertEqual(try Float(arguments: &arguments), 56)
        XCTAssertEqual(arguments, ["5e10", "7.84394", "hello", "world"])
        XCTAssertEqual(try Double(arguments: &arguments), 5e10)
        XCTAssertEqual(arguments, ["7.84394", "hello", "world"])
        XCTAssertEqual(try Double(arguments: &arguments), 7.84394)
        XCTAssertEqual(arguments, ["hello", "world"])
    }

    func test_collections_noValue() {
        var arguments: [String] = []
        XCTAssertThrowsError(try [String](arguments: &arguments), equals: ParseError.missingArgument)
        XCTAssertThrowsError(try Set<Int>(arguments: &arguments), equals: ParseError.missingArgument)
    }

    func test_collections_invalidValue() {
        var arguments = ["invalid"]
        XCTAssertThrowsError(try [Int](arguments: &arguments), equals: ParseError.invalidFormat("invalid"))
        XCTAssertEqual(arguments, ["invalid"])

        arguments = ["5", "not"]
        XCTAssertThrowsError(try Set<Float>(arguments: &arguments), equals: ParseError.invalidFormat("not"))
        XCTAssertEqual(arguments, ["not"])
    }

    func test_collections_validValue() {
        var arguments = ["hello", "world", "!"]
        XCTAssertEqual(try [String](arguments: &arguments), ["hello", "world", "!"])
        XCTAssertEqual(arguments, [])

        arguments = ["4", "-2", "8", "-2"]
        XCTAssertEqual(try Set<Int>(arguments: &arguments), Set([4, -2, 8]))
        XCTAssertEqual(arguments, [])
    }
}
