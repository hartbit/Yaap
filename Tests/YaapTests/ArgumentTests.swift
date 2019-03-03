import XCTest
@testable import Yaap

class ArgumentTests: XCTestCase {
    func testInitializer() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        XCTAssertNil(argument1.name)
        XCTAssertNil(argument1.documentation)

        let argument2 = Argument<Int>(name: "custom-name", documentation: "Lengthy documentation")
        XCTAssertEqual(argument2.name, "custom-name")
        XCTAssertEqual(argument2.documentation, "Lengthy documentation")
    }

    func testPriority() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        XCTAssertEqual(argument1.priority, 0.25)

        let argument2 = Argument<Int>(name: "custom-name", documentation: "Some documentation")
        XCTAssertEqual(argument2.priority, 0.25)
    }

    func testUsage() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        XCTAssertEqual(argument1.usage, "<label>")

        let argument2 = Argument<Int>(name: "custom-name", documentation: "Some documentation")
        argument2.setup(withLabel: "label")
        XCTAssertEqual(argument2.usage, "<custom-name>")
    }

    func testHelp() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        XCTAssertEqual(argument1.info, [])

        let argument2 = Argument<Int>(name: "custom-name", documentation: nil)
        argument2.setup(withLabel: "label")
        XCTAssertEqual(argument2.info, [])

        let argument3 = Argument<Int>(name: nil, documentation: "Lengthy documentation")
        argument3.setup(withLabel: "label")
        XCTAssertEqual(argument3.info, [
            PropertyInfo(
                category: "ARGUMENTS",
                label: "label",
                documentation: "Lengthy documentation")
        ])

        let argument4 = Argument<Int>(name: "custom-name", documentation: "Lengthy documentation")
        argument4.setup(withLabel: "label")
        XCTAssertEqual(argument4.info, [
            PropertyInfo(
                category: "ARGUMENTS",
                label: "custom-name",
                documentation: "Lengthy documentation")
        ])
    }

    func testParseNoArguments() {
        var arguments: [String] = []

        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        XCTAssertThrowsError(
            try argument1.parse(arguments: &arguments),
            equals: ArgumentMissingError(argument: "label"))

        let argument2 = Argument<Int>(name: "argument-name", documentation: nil)
        argument2.setup(withLabel: "label")
        XCTAssertThrowsError(
            try argument2.parse(arguments: &arguments),
            equals: ArgumentMissingError(argument: "argument-name"))

        let error = ArgumentMissingError(argument: "argument-name")
        XCTAssertEqual(error.errorDescription, "missing argument 'argument-name'")
    }

    func testParseInvalidValue() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        argument1.setup(withLabel: "label")
        var arguments = ["2.5"]
        XCTAssertThrowsError(
            try argument1.parse(arguments: &arguments),
            equals: ArgumentInvalidFormatError(argument: "label", value: "2.5"))

        let argument2 = Argument<Int>(name: "argument-name", documentation: nil)
        argument2.setup(withLabel: "label")
        arguments = ["two"]
        XCTAssertThrowsError(
            try argument2.parse(arguments: &arguments),
            equals: ArgumentInvalidFormatError(argument: "argument-name", value: "two"))

        let error = ArgumentInvalidFormatError(argument: "argument-name", value: "invalid-value")
        XCTAssertEqual(error.errorDescription, "invalid format 'invalid-value' for argument 'argument-name'")
    }

    func testParseValidValue() throws {
        let argument = Argument<Int>(name: nil, documentation: nil)
        argument.setup(withLabel: "label")
        var arguments = ["5", "2", "whatever"]
        try argument.parse(arguments: &arguments)
        XCTAssertEqual(argument.value, 5)
        XCTAssertEqual(arguments, ["2", "whatever"])
    }

    func testParseOption() throws {
        let argument = Argument<String>(name: "argument", documentation: nil)
        var arguments = ["--option"]
        XCTAssertFalse(try argument.parse(arguments: &arguments))
        XCTAssertEqual(arguments, ["--option"])

        arguments = ["-o"]
        XCTAssertFalse(try argument.parse(arguments: &arguments))
        XCTAssertEqual(arguments, ["-o"])
    }
}
