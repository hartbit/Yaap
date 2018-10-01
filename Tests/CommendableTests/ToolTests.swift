import XCTest
@testable import Commendable

class ToolTests: XCTestCase {
    func testInitializer() {
        let tool = Tool(name: "Name", version: "1.0", command: Command(documentation: ""))
        XCTAssertEqual(tool.name, "Name")
        XCTAssertEqual(tool.version, "1.0")
    }
}
