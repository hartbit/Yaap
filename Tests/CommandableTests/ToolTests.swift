import XCTest
@testable import Commandable

class ToolTests: XCTestCase {
    func testInitializer() {
        struct Main: Command {
            static let documentation = ""
            func run() {}
        }

        let main = Main()
        let tool = Tool(name: "Name", version: "1.0", command: main)
        XCTAssertEqual(tool.name, "Name")
        XCTAssertEqual(tool.version, "1.0")
    }

    static var allTests = [
        ("testInitializer", testInitializer),
    ]
}
