import XCTest
@testable import Yaap

class VersionTests: XCTestCase {
    func testValidate() {
        class TestCommand: Command {
            let name = "test"
            let version = Version(version: "TestTool 2.4-alpha")

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        let command = TestCommand()

        var outputStream = "" as TextOutputStream
        var errorStream = "" as TextOutputStream
        XCTAssertExit(0, command.parseAndRun(
            arguments: ["--version"],
            outputStream: &outputStream,
            errorStream: &errorStream))
        XCTAssertEqual(errorStream as! String, "")
        XCTAssertEqual(outputStream as! String, "TestTool 2.4-alpha")

        outputStream = "" as TextOutputStream
        errorStream = "" as TextOutputStream
        XCTAssertExit(0, command.parseAndRun(
            arguments: ["-v"],
            outputStream: &outputStream,
            errorStream: &errorStream))
        XCTAssertEqual(errorStream as! String, "")
        XCTAssertEqual(outputStream as! String, "TestTool 2.4-alpha")
    }

    func testValidateCustomNameAndShorthand() {
        class TestCommand: Command {
            let name = "test"
            let version = Version(version: "TestTool 1.0.1", name: "wersja", shorthand: "w")

            func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
            }
        }

        let command = TestCommand()

        var outputStream = "" as TextOutputStream
        var errorStream = "" as TextOutputStream
        XCTAssertExit(0, command.parseAndRun(
            arguments: ["--wersja"],
            outputStream: &outputStream,
            errorStream: &errorStream))
        XCTAssertEqual(errorStream as! String, "")
        XCTAssertEqual(outputStream as! String, "TestTool 1.0.1")

        outputStream = "" as TextOutputStream
        errorStream = "" as TextOutputStream
        XCTAssertExit(0, command.parseAndRun(
            arguments: ["-w"],
            outputStream: &outputStream,
            errorStream: &errorStream))
        XCTAssertEqual(errorStream as! String, "")
        XCTAssertEqual(outputStream as! String, "TestTool 1.0.1")
    }
}
