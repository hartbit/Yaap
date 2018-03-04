import XCTest
@testable import Commandable

class ArgumentsTests: XCTestCase {
    func testArgumentInitializer() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        XCTAssertNil(argument1.name)
        XCTAssertNil(argument1.documentation)

        let argument2 = Argument<Int>(name: "custom-name", documentation: "Lengthy documentation")
        XCTAssertEqual(argument2.name, "custom-name")
        XCTAssertEqual(argument2.documentation, "Lengthy documentation")
    }

    func testArgumentPriority() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        XCTAssertEqual(argument1.priority, 0.25)

        let argument2 = Argument<Int>(name: "custom-name", documentation: "Some documentation")
        XCTAssertEqual(argument2.priority, 0.25)
    }

    func testArgumentUsage() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        XCTAssertEqual(argument1.usage(withLabel: "label"), "<label>")

        let argument2 = Argument<Int>(name: "custom-name", documentation: "Some documentation")
        XCTAssertEqual(argument2.usage(withLabel: "label"), "<custom-name>")
    }

    func testArgumentHelp() {
        let argument1 = Argument<Int>(name: nil, documentation: nil)
        XCTAssertNil(argument1.help(withLabel: "label"))

        let argument2 = Argument<Int>(name: "custom-name", documentation: nil)
        XCTAssertNil(argument2.help(withLabel: "label"))

        let argument3 = Argument<Int>(name: nil, documentation: "Lengthy documentation")
        XCTAssertEqual(argument3.help(withLabel: "label"), ArgumentHelp(
            category: "ARGUMENTS",
            label: "label",
            description: "Lengthy documentation"))

        let argument4 = Argument<Int>(name: "custom-name", documentation: "Lengthy documentation")
        XCTAssertEqual(argument4.help(withLabel: "label"), ArgumentHelp(
            category: "ARGUMENTS",
            label: "custom-name",
            description: "Lengthy documentation"))
    }

    func testOptionInitializer() {
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

    func testOptionPriority() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42, documentation: nil)
        XCTAssertEqual(option1.priority, 0.75)

        let option2 = Option<Int>(name: "option", shorthand: "o", defaultValue: 42, documentation: "Some documentation")
        XCTAssertEqual(option2.priority, 0.75)
    }

    func testOptionUsage() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42, documentation: nil)
        XCTAssertEqual(option1.usage(withLabel: "label"), "[options]")

        let option2 = Option<Int>(name: "option", shorthand: "o", defaultValue: 42, documentation: "Some documentation")
        XCTAssertEqual(option2.usage(withLabel: "label"), "[options]")
    }

    func testOptionHelp() {
        let option1 = Option<Int>(name: nil, shorthand: nil, defaultValue: 42, documentation: nil)
        XCTAssertEqual(option1.help(withLabel: "label"), ArgumentHelp(
            category: "OPTIONS",
            label: "--label",
            description: "[default: 42]"))

        let option2 = Option<Int>(name: "option", shorthand: nil, defaultValue: 0, documentation: nil)
        XCTAssertEqual(option2.help(withLabel: "label"), ArgumentHelp(
            category: "OPTIONS",
            label: "--option",
            description: "[default: 0]"))

        let option3 = Option<String>(name: "output", shorthand: "o", defaultValue: "./", documentation: nil)
        XCTAssertEqual(option3.help(withLabel: "label"), ArgumentHelp(
            category: "OPTIONS",
            label: "--output, -o",
            description: "[default: ./]"))

        let option4 = Option<Bool>(
            name: "verbose",
            shorthand: nil,
            defaultValue: true,
            documentation: "Awesome documentation")
        XCTAssertEqual(option4.help(withLabel: "label"), ArgumentHelp(
            category: "OPTIONS",
            label: "--verbose",
            description: "Awesome documentation [default: true]"))
    }

    static var allTests = [
        ("testArgumentInitializer", testArgumentInitializer),
        ("testArgumentHelp", testArgumentHelp),
        ("testOptionInitializer", testOptionInitializer),
        ("testOptionHelp", testOptionHelp),
    ]
}

