import XCTest
@testable import CLI

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
        var arguments: [String] = []

        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        XCTAssertThrowsError(
            try argument1.parse(arguments: &arguments),
            equals: MissingArgumentError(argument: "label"))

        let argument2 = Argument<Int>(name: "argument-name", documentation: nil)
        argument2.setup(withLabel: "label")
        XCTAssertThrowsError(
            try argument2.parse(arguments: &arguments),
            equals: MissingArgumentError(argument: "argument-name"))
    }

    func test_parse_invalidValue() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        var arguments = ["2.5"]
        XCTAssertThrowsError(
            try argument1.parse(arguments: &arguments),
            equals: ArgumentInvalidFormatError(argument: "label", value: "2.5"))

        let argument2 = Argument<Int>(name: "agument-name", documentation: nil)
        argument2.setup(withLabel: "label")
        arguments = ["two"]
        XCTAssertThrowsError(
            try argument2.parse(arguments: &arguments),
            equals: ArgumentInvalidFormatError(argument: "agument-name", value: "two"))
    }

    func test_parse_validValue() throws {
        let argument = Argument<Int>(name: nil, documentation: nil)
        argument.setup(withLabel: "label")
        var arguments = ["5", "2", "whatever"]
        try argument.parse(arguments: &arguments)
        XCTAssertEqual(argument.value, 5)
        XCTAssertEqual(arguments, ["2", "whatever"])
    }
}
