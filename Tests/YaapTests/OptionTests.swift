import XCTest
@testable import Yaap

class OptionTests: XCTestCase {
    func testInitializer() {
        let option1 = Option<Int>(wrappedValue: 42, name: nil, shorthand: nil)
        XCTAssertNil(option1.name)
        XCTAssertNil(option1.shorthand)
        XCTAssertEqual(option1.defaultValue, 42)
        XCTAssertNil(option1.documentation)

        let option2 = Option<String>(
            wrappedValue: "default",
            name: "option",
            shorthand: "o",
            documentation: "Super documentation")
        XCTAssertEqual(option2.name, "option")
        XCTAssertEqual(option2.shorthand, "o")
        XCTAssertEqual(option2.defaultValue, "default")
        XCTAssertEqual(option2.documentation, "Super documentation")
    }

    func testPriority() {
        let option1 = Option<Int>(wrappedValue: 42, name: nil, shorthand: nil)
        XCTAssertEqual(option1.priority, 0.75)

        let option2 = Option<Int>(wrappedValue: 42, name: "option", shorthand: "o", documentation: "Some documentation")
        XCTAssertEqual(option2.priority, 0.75)
    }

    func testUsage() {
        let option1 = Option<Int>(wrappedValue: 42, name: nil, shorthand: nil)
        option1.setup(withLabel: "label")
        XCTAssertEqual(option1.usage, "[options]")

        let option2 = Option<Int>(wrappedValue: 42, name: "option", shorthand: "o", documentation: "Some documentation")
        option2.setup(withLabel: "label")
        XCTAssertEqual(option2.usage, "[options]")
    }

    func testHelp() {
        let option1 = Option<Int>(wrappedValue: 42, name: nil, shorthand: nil)
        option1.setup(withLabel: "label")
        XCTAssertEqual(option1.info, [
            PropertyInfo(
                category: "OPTIONS",
                label: "--label",
                documentation: "[default: 42]")
        ])

        let option2 = Option<Int>(wrappedValue: 0, name: "option", shorthand: nil)
        option2.setup(withLabel: "label")
        XCTAssertEqual(option2.info, [
            PropertyInfo(
                category: "OPTIONS",
                label: "--option",
                documentation: "[default: 0]")
        ])

        let option3 = Option<String>(wrappedValue: "./", name: "output", shorthand: "o")
        option3.setup(withLabel: "label")
        XCTAssertEqual(option3.info, [
            PropertyInfo(
                category: "OPTIONS",
                label: "--output, -o",
                documentation: "[default: ./]")
        ])

        let option4 = Option<Bool>(
            wrappedValue: true,
            name: "verbose",
            shorthand: nil,
            documentation: "Awesome documentation")
        option4.setup(withLabel: "label")
        XCTAssertEqual(option4.info, [
            PropertyInfo(
                category: "OPTIONS",
                label: "--verbose",
                documentation: "Awesome documentation [default: true]")
        ])
    }

    func testParseNoArguments() throws {
        let option = Option<Int>(wrappedValue: 42, name: nil, shorthand: nil)
        option.setup(withLabel: "label")
        var arguments: [String] = []
        XCTAssertFalse(try option.parse(arguments: &arguments))
        XCTAssertEqual(option.value, 42)
    }

    func testParseNoStart() throws {
        let option = Option<Int>(wrappedValue: 42, name: nil, shorthand: nil)
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

    func testParseNoValue() throws {
        let option = Option<Int>(wrappedValue: 42, name: "option", shorthand: "o")
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

    func testParseInvalidValue() throws {
        let option = Option<Int>(wrappedValue: 42, name: "option", shorthand: "o")
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

    func testParseValidValue() throws {
        let option1 = Option<Int>(wrappedValue: 42, name: "option", shorthand: "o")
        option1.setup(withLabel: "label")

        var arguments = ["--option", "6", "8"]
        XCTAssertTrue(try option1.parse(arguments: &arguments))
        XCTAssertEqual(option1.value, 6)
        XCTAssertEqual(arguments, ["8"])

        arguments = ["-o", "78"]
        XCTAssertTrue(try option1.parse(arguments: &arguments))
        XCTAssertEqual(option1.value, 78)
        XCTAssertEqual(arguments, [])

        let option2 = Option<Int>(wrappedValue: 8)
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

    func testParseBoolean() throws {
        let option = Option<Bool>(name: "option", shorthand: "o")
        option.setup(withLabel: "label")

        var arguments = ["--option", "other"]
        XCTAssertTrue(try option.parse(arguments: &arguments))
        XCTAssertTrue(option.value)
        XCTAssertEqual(arguments, ["other"])

        arguments = ["-o"]
        XCTAssertTrue(try option.parse(arguments: &arguments))
        XCTAssertTrue(option.value)
        XCTAssertEqual(arguments, [])
    }

    func testParseUpToNextOptional() throws {
        let option1 = Option<String>(wrappedValue: "something", name: "option", shorthand: "o")

        var arguments = ["--option", "-v"]
        XCTAssertThrowsError(
            try option1.parse(arguments: &arguments),
            equals: OptionMissingValueError(option: "--option"))

        let option2 = Option<[String]>(wrappedValue: [], name: "option", shorthand: "o")

        arguments = ["--option", "one", "two", "--other", "three"]
        XCTAssertTrue(try option2.parse(arguments: &arguments))
        XCTAssertEqual(option2.value, ["one", "two"])
        XCTAssertEqual(arguments, ["--other", "three"])
    }

    func testParseMultipleFlags() throws {
        let option1 = Option<Bool>(name: "option", shorthand: "o")

        var arguments = ["-ab"]
        XCTAssertFalse(try option1.parse(arguments: &arguments))
        XCTAssertFalse(option1.value)
        XCTAssertEqual(arguments, ["-ab"])

        arguments = ["-oxy"]
        XCTAssertTrue(try option1.parse(arguments: &arguments))
        XCTAssertTrue(option1.value)
        XCTAssertEqual(arguments, ["-xy"])

        let option2 = Option<String>(wrappedValue: "default", name: "option", shorthand: "o")

        arguments = ["-oxy"]
        XCTAssertThrowsError(
            try option2.parse(arguments: &arguments),
            equals: OptionMissingValueError(option: "-o"))
    }

    func testParseEqualSyntax() throws {
        let option = Option<Int>(wrappedValue: 42, name: "option", shorthand: "o")

        var arguments = ["--option=12", "other"]
        XCTAssertTrue(try option.parse(arguments: &arguments))
        XCTAssertEqual(option.value, 12)
        XCTAssertEqual(arguments, ["other"])

        arguments = ["-o=33", "other"]
        XCTAssertTrue(try option.parse(arguments: &arguments))
        XCTAssertEqual(option.value, 33)
        XCTAssertEqual(arguments, ["other"])

        arguments = ["--option=invalid"]
        XCTAssertThrowsError(
            try option.parse(arguments: &arguments),
            equals: OptionInvalidFormatError(option: "--option", value: "invalid"))
    }
}
