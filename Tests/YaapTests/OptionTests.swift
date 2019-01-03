import XCTest
@testable import Yaap

class OptionTests: XCTestCase {
    func test_initializer() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42)
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
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42)
        XCTAssertEqual(option1.priority, 0.75)

        let option2 = Option<Int>(name: "option", shorthand: "o", defaultValue: 42, documentation: "Some documentation")
        XCTAssertEqual(option2.priority, 0.75)
    }

    func test_usage() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42)
        option1.setup(withLabel: "label")
        XCTAssertEqual(option1.usage, "[options]")

        let option2 = Option<Int>(name: "option", shorthand: "o", defaultValue: 42, documentation: "Some documentation")
        option2.setup(withLabel: "label")
        XCTAssertEqual(option2.usage, "[options]")
    }

    func test_help() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42)
        option1.setup(withLabel: "label")
        XCTAssertEqual(option1.help, [ArgumentHelp(
            category: "OPTIONS",
            label: "--label",
            description: "[default: 42]")])

        let option2 = Option<Int>(name: "option", shorthand: nil, defaultValue: 0)
        option2.setup(withLabel: "label")
        XCTAssertEqual(option2.help, [ArgumentHelp(
            category: "OPTIONS",
            label: "--option",
            description: "[default: 0]")])

        let option3 = Option<String>(name: "output", shorthand: "o", defaultValue: "./")
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
        let option = Option<Int>(name: nil, shorthand: nil, defaultValue: 42)
        option.setup(withLabel: "label")
        var arguments: [String] = []
        XCTAssertFalse(try option.parse(arguments: &arguments))
        XCTAssertEqual(option.value, 42)
    }

    func test_parse_noStart() throws {
        let option = Option<Int>(name: nil, shorthand: nil, defaultValue: 42)
        option.setup(withLabel: "label")

        var arguments = ["one", "2", "3.0"]
        XCTAssertFalse(try option.parse(arguments: &arguments))
        XCTAssertEqual(option.value, 42)
        XCTAssertEqual(arguments, ["one", "2", "3.0"])

        arguments = ["--other", "2"]
        XCTAssertFalse(try option.parse(arguments: &arguments))
        XCTAssertEqual(option.value, 42)
        XCTAssertEqual(arguments, ["--other", "2"])

        arguments = ["-o", "test"]
        XCTAssertFalse(try option.parse(arguments: &arguments))
        XCTAssertEqual(option.value, 42)
        XCTAssertEqual(arguments, ["-o", "test"])
    }

    func test_parse_noValue() throws {
        let option = Option<Int>(name: "option", shorthand: "o", defaultValue: 42)
        option.setup(withLabel: "label")

        var arguments = ["--option"]
        XCTAssertThrowsError(
            try option.parse(arguments: &arguments),
            equals: OptionMissingValueError(option: "--option"))

        arguments = ["-o"]
        XCTAssertThrowsError(
            try option.parse(arguments: &arguments),
            equals: OptionMissingValueError(option: "-o"))

        let error = OptionMissingValueError(option: "--option")
        XCTAssertEqual(error.errorDescription, """
            option '--option' missing a value; provide one with '--option <value>' or '--option=<value>'
            """)
    }

    func test_parse_invalidValue() throws {
        let option = Option<Int>(name: "option", shorthand: "o", defaultValue: 42)
        option.setup(withLabel: "label")

        var arguments = ["--option", "two"]
        XCTAssertThrowsError(
            try option.parse(arguments: &arguments),
            equals: OptionInvalidFormatError(option: "--option", value: "two"))

        arguments = ["-o", "2.4"]
        XCTAssertThrowsError(
            try option.parse(arguments: &arguments),
            equals: OptionInvalidFormatError(option: "-o", value: "2.4"))

        let error = OptionInvalidFormatError(option: "--option", value: "invalid-value")
        XCTAssertEqual(error.errorDescription, "invalid format 'invalid-value' for option '--option'")
    }

    func test_parse_validValue() throws {
        let option1 = Option<Int>(name: "option", shorthand: "o", defaultValue: 42)
        option1.setup(withLabel: "label")

        var arguments = ["--option", "6", "8"]
        XCTAssertTrue(try option1.parse(arguments: &arguments))
        XCTAssertEqual(option1.value, 6)
        XCTAssertEqual(arguments, ["8"])

        arguments = ["-o", "78"]
        XCTAssertTrue(try option1.parse(arguments: &arguments))
        XCTAssertEqual(option1.value, 78)
        XCTAssertEqual(arguments, [])

        let option2 = Option<Int>(defaultValue: 8)
        option2.setup(withLabel: "label")

        arguments = ["--label", "23"]
        XCTAssertTrue(try option2.parse(arguments: &arguments))
        XCTAssertEqual(option2.value, 23)
        XCTAssertEqual(arguments, [])

        arguments = ["-l", "98"]
        XCTAssertFalse(try option2.parse(arguments: &arguments))
        XCTAssertEqual(option2.value, 8)
        XCTAssertEqual(arguments, ["-l", "98"])
    }

    func test_parse_boolean() throws {
        let option = Option<Bool>(name: "option", shorthand: "o")
        option.setup(withLabel: "label")

        var arguments = ["--option", "other"]
        XCTAssertTrue(try option.parse(arguments: &arguments))
        XCTAssertEqual(option.value, true)
        XCTAssertEqual(arguments, ["other"])

        arguments = ["-o"]
        XCTAssertTrue(try option.parse(arguments: &arguments))
        XCTAssertEqual(option.value, true)
        XCTAssertEqual(arguments, [])
    }

    func test_parse_upToNextOptional() throws {
        let option1 = Option<String>(name: "option", shorthand: "o", defaultValue: "something")

        var arguments = ["--option", "-v"]
        XCTAssertThrowsError(
            try option1.parse(arguments: &arguments),
            equals: OptionMissingValueError(option: "--option"))

        let option2 = Option<[String]>(name: "option", shorthand: "o", defaultValue: [])

        arguments = ["--option", "one", "two", "--other", "three"]
        XCTAssertTrue(try option2.parse(arguments: &arguments))
        XCTAssertEqual(option2.value, ["one", "two"])
        XCTAssertEqual(arguments, ["--other", "three"])
    }

    func test_parse_multipleFlags() throws {
        let option1 = Option<Bool>(name: "option", shorthand: "o")

        var arguments = ["-ab"]
        XCTAssertFalse(try option1.parse(arguments: &arguments))
        XCTAssertEqual(option1.value, false)
        XCTAssertEqual(arguments, ["-ab"])

        arguments = ["-oxy"]
        XCTAssertTrue(try option1.parse(arguments: &arguments))
        XCTAssertEqual(option1.value, true)
        XCTAssertEqual(arguments, ["-xy"])

        let option2 = Option<String>(name: "option", shorthand: "o", defaultValue: "default")

        arguments = ["-oxy"]
        XCTAssertThrowsError(
            try option2.parse(arguments: &arguments),
            equals: OptionMissingValueError(option: "-o"))
    }
}
