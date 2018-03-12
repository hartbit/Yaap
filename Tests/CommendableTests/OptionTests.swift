import XCTest
@testable import Commendable

class OptionTests: XCTestCase {
    func test_initializer() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42, documentation: nil)
        XCTAssertNil(option1.name)
        XCTAssertNil(option1.shorthand)
        XCTAssertEqual(option1.defaultValue, 42)
        XCTAssertNil(option1.documentation)

        let option2 = Option<String>(
            name: "option",
            shorthand: "o",
            defaultValue: "default",
            documentation: "Super documentation")
        XCTAssertEqual(option2.name, "option")
        XCTAssertEqual(option2.shorthand, "o")
        XCTAssertEqual(option2.defaultValue, "default")
        XCTAssertEqual(option2.documentation, "Super documentation")
    }

    func test_priority() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42, documentation: nil)
        XCTAssertEqual(option1.priority, 0.75)

        let option2 = Option<Int>(name: "option", shorthand: "o", defaultValue: 42, documentation: "Some documentation")
        XCTAssertEqual(option2.priority, 0.75)
    }

    func test_usage() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42, documentation: nil)
        option1.setup(withLabel: "label")
        XCTAssertEqual(option1.usage, "[options]")

        let option2 = Option<Int>(name: "option", shorthand: "o", defaultValue: 42, documentation: "Some documentation")
        option2.setup(withLabel: "label")
        XCTAssertEqual(option2.usage, "[options]")
    }

    func test_help() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42, documentation: nil)
        option1.setup(withLabel: "label")
        XCTAssertEqual(option1.help, [ArgumentHelp(
            category: "OPTIONS",
            label: "--label",
            description: "[default: 42]")])

        let option2 = Option<Int>(name: "option", shorthand: nil, defaultValue: 0, documentation: nil)
        option2.setup(withLabel: "label")
        XCTAssertEqual(option2.help, [ArgumentHelp(
            category: "OPTIONS",
            label: "--option",
            description: "[default: 0]")])

        let option3 = Option<String>(name: "output", shorthand: "o", defaultValue: "./", documentation: nil)
        option3.setup(withLabel: "label")
        XCTAssertEqual(option3.help, [ArgumentHelp(
            category: "OPTIONS",
            label: "--output, -o",
            description: "[default: ./]")])

        let option4 = Option<Bool>(
            name: "verbose",
            shorthand: nil,
            defaultValue: true,
            documentation: "Awesome documentation")
        option4.setup(withLabel: "label")
        XCTAssertEqual(option4.help, [ArgumentHelp(
            category: "OPTIONS",
            label: "--verbose",
            description: "Awesome documentation [default: true]")])
    }

    func test_parse_noArguments() throws {
        let option = Option<Int>(name: nil, shorthand: nil, defaultValue: 42, documentation: nil)
        option.setup(withLabel: "label")
        var leftover: [String] = []
        try option.parse(arguments: [], leftover: &leftover)
        XCTAssertEqual(option.value, 42)
    }

    func test_parse_noStart() throws {
        let option = Option<Int>(name: nil, shorthand: nil, defaultValue: 42, documentation: nil)
        option.setup(withLabel: "label")
        var leftover: [String] = []
        try option.parse(arguments: ["one", "2", "3.0"], leftover: &leftover)
        XCTAssertEqual(option.value, 42)
        XCTAssertEqual(leftover, [])
    }

    func test_parse_noValue() throws {
        let option = Option<Int>(name: "option", shorthand: "o", defaultValue: 42, documentation: nil)
        option.setup(withLabel: "label")
        var leftover: [String] = []
        XCTAssertThrowsError(try option.parse(arguments: ["before", "--option"], leftover: &leftover), equals: OptionMissingArgumentError(option: "--option"))
        XCTAssertThrowsError(try option.parse(arguments: ["-o"], leftover: &leftover), equals: OptionMissingArgumentError(option: "-o"))
    }

    func test_parse_invalidValue() throws {
        let option = Option<Int>(name: "option", shorthand: "o", defaultValue: 42, documentation: nil)
        option.setup(withLabel: "label")
        var leftover: [String] = []
        XCTAssertThrowsError(try option.parse(arguments: ["before", "--option", "two"], leftover: &leftover), equals: OptionInvalidFormatError(option: "--option", value: "two"))
        XCTAssertThrowsError(try option.parse(arguments: ["-o", "2.4"], leftover: &leftover), equals: OptionInvalidFormatError(option: "-o", value: "2.4"))
    }

    static var allTests = [
        ("test_initializer", test_initializer),
        ("test_priority", test_priority),
        ("test_usage", test_usage),
        ("test_help", test_help),
        ("test_parse_noArguments", test_parse_noArguments),
        ("test_parse_noStart", test_parse_noStart),
        ("test_parse_noValue", test_parse_noValue),
        ("test_parse_invalidValue", test_parse_invalidValue),
    ]
}
