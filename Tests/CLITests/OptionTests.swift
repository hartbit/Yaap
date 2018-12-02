import XCTest
@testable import CLI

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
        try option.parse(arguments: &arguments)
        XCTAssertEqual(option.value, 42)
    }

    func test_parse_noStart() throws {
        let option = Option<Int>(name: nil, shorthand: nil, defaultValue: 42)
        option.setup(withLabel: "label")
        var arguments = ["one", "2", "3.0"]
        try option.parse(arguments: &arguments)
        XCTAssertEqual(option.value, 42)
        XCTAssertEqual(arguments, ["one", "2", "3.0"])
    }

    func test_parse_noValue() throws {
        let option = Option<Int>(name: "option", shorthand: "o", defaultValue: 42)
        option.setup(withLabel: "label")

        var arguments = ["--option"]
        XCTAssertThrowsError(
            try option.parse(arguments: &arguments),
            equals: OptionMissingArgumentError(option: "--option"))

        arguments = ["-o"]
        XCTAssertThrowsError(
            try option.parse(arguments: &arguments),
            equals: OptionMissingArgumentError(option: "-o"))
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
    }

    func test_parse_validValue() throws {
        let option1 = Option<Int>(name: "option", shorthand: "o", defaultValue: 42)
        option1.setup(withLabel: "label")

        var arguments = ["--option", "6", "8"]
        try option1.parse(arguments: &arguments)
        XCTAssertEqual(option1.value, 6)
        XCTAssertEqual(arguments, ["8"])

        arguments = ["-o", "78"]
        try option1.parse(arguments: &arguments)
        XCTAssertEqual(option1.value, 78)
        XCTAssertEqual(arguments, [])

        let option2 = Option<Int>(defaultValue: 8)
        option2.setup(withLabel: "label")

        arguments = ["--label", "23"]
        try option2.parse(arguments: &arguments)
        XCTAssertEqual(option2.value, 23)
        XCTAssertEqual(arguments, [])

        arguments = ["-l", "98"]
        try option2.parse(arguments: &arguments)
        XCTAssertEqual(option2.value, 8)
        XCTAssertEqual(arguments, ["-l", "98"])
    }

    func test_parse_boolean() throws {
        let option = Option<Bool>(name: "option", shorthand: "o")
        option.setup(withLabel: "label")

        var arguments = ["--option", "other"]
        try option.parse(arguments: &arguments)
        XCTAssertEqual(option.value, true)
        XCTAssertEqual(arguments, ["other"])

        arguments = ["-o"]
        try option.parse(arguments: &arguments)
        XCTAssertEqual(option.value, true)
        XCTAssertEqual(arguments, [])
    }

    func test_parse_upToNextOptional() throws {
        let option1 = Option<String>(name: "option", shorthand: "o", defaultValue: "something")
        option1.setup(withLabel: "label")

        var arguments = ["--option", "-v"]
        XCTAssertThrowsError(
            try option1.parse(arguments: &arguments),
            equals: OptionMissingArgumentError(option: "--option"))

        let option2 = Option<[String]>(name: "option", shorthand: "o", defaultValue: [])
        option1.setup(withLabel: "label")

        arguments = ["--option", "one", "two", "--other", "three"]
        try option2.parse(arguments: &arguments)
        XCTAssertEqual(option2.value, ["one", "two"])
        XCTAssertEqual(arguments, ["--other", "three"])
    }
}
