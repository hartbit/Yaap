import XCTest
@testable import Commendable

class ArgumentTests: XCTestCase {
    func test_initializer() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        XCTAssertNil(argument1.name)
        XCTAssertNil(argument1.documentation)

        let argument2 = Argument<Int>(name: "custom-name", documentation: "Lengthy documentation")
        XCTAssertEqual(argument2.name, "custom-name")
        XCTAssertEqual(argument2.documentation, "Lengthy documentation")
    }

    func test_priority() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        XCTAssertEqual(argument1.priority, 0.25)

        let argument2 = Argument<Int>(name: "custom-name", documentation: "Some documentation")
        XCTAssertEqual(argument2.priority, 0.25)
    }

    func test_usage() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        XCTAssertEqual(argument1.usage, "<label>")

        let argument2 = Argument<Int>(name: "custom-name", documentation: "Some documentation")
        argument2.setup(withLabel: "label")
        XCTAssertEqual(argument2.usage, "<custom-name>")
    }

    func test_help() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        XCTAssertEqual(argument1.help, [])

        let argument2 = Argument<Int>(name: "custom-name", documentation: nil)
        argument2.setup(withLabel: "label")
        XCTAssertEqual(argument2.help, [])

        let argument3 = Argument<Int>(name: nil, documentation: "Lengthy documentation")
        argument3.setup(withLabel: "label")
        XCTAssertEqual(argument3.help, [ArgumentHelp(
            category: "ARGUMENTS",
            label: "label",
            description: "Lengthy documentation")])

        let argument4 = Argument<Int>(name: "custom-name", documentation: "Lengthy documentation")
        argument4.setup(withLabel: "label")
        XCTAssertEqual(argument4.help, [ArgumentHelp(
            category: "ARGUMENTS",
            label: "custom-name",
            description: "Lengthy documentation")])
    }

    func test_parse_noArguments() {
        var leftover: [String] = []

        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        XCTAssertThrowsError(try argument1.parse(arguments: [], leftover: &leftover), equals: MissingArgumentError(argument: "label"))

        let argument2 = Argument<Int>(name: "argument-name", documentation: nil)
        argument2.setup(withLabel: "label")
        XCTAssertThrowsError(try argument2.parse(arguments: [], leftover: &leftover), equals: MissingArgumentError(argument: "argument-name"))
    }

    func test_parse_invalidValue() {
        var leftover: [String] = []

        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        XCTAssertThrowsError(try argument1.parse(arguments: ["2.5"], leftover: &leftover), equals: ArgumentInvalidFormatError(argument: "label", value: "2.5"))

        let argument2 = Argument<Int>(name: "agument-name", documentation: nil)
        argument2.setup(withLabel: "label")
        XCTAssertThrowsError(try argument2.parse(arguments: ["two"], leftover: &leftover), equals: ArgumentInvalidFormatError(argument: "agument-name", value: "two"))
    }

    func test_parse_validValue() throws {
        let argument = Argument<Int>(name: nil, documentation: nil)
        argument.setup(withLabel: "label")
        var leftover: [String] = []
        try argument.parse(arguments: ["5", "2", "whatever"], leftover: &leftover)
        XCTAssertEqual(argument.value, 5)
        XCTAssertEqual(leftover, ["2", "whatever"])
    }

    static var allTests = [
        ("test_initializer", test_initializer),
        ("test_priority", test_priority),
        ("test_usage", test_usage),
        ("test_help", test_help),
        ("test_parse_noArguments", test_parse_noArguments),
        ("test_parse_invalidValue", test_parse_invalidValue),
        ("test_parse_validValue", test_parse_validValue),
    ]
}
