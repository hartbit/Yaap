import XCTest
@testable import Commandable

extension Tool.Commands: Equatable {
    public static func == (lhs: Tool.Commands, rhs: Tool.Commands) -> Bool {
        switch (lhs, rhs) {
        case (.command(let lhsType), command(let rhsType)):
            return lhsType == rhsType
        case (.subCommands(let lhsSubCommands), .subCommands(let rhsSubCommands)):
            return lhsSubCommands == rhsSubCommands
        case (.command, _),
             (.subCommands, _):
            return false
        }
    }
}

class CommandableTests: XCTestCase {
    func testInitializer() {
        struct Main: Command {
            static let documentation = ""
            func run() {}
        }

        let tool = Tool(name: "Name", version: "1.0", commands: Main.command)
        XCTAssertEqual(tool.name, "Name")
        XCTAssertEqual(tool.version, "1.0")
        XCTAssertEqual(tool.commands, Tool.Commands.command(Main.self))
    }

    static var allTests = [
        ("testInitializer", testInitializer),
    ]
}
