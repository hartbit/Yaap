import XCTest
@testable import CLI

class ToolTests: XCTestCase {
    func testInitializer() {
        let tool = Tool(name: "Name", version: "1.0", command: Command(documentation: ""))
        XCTAssertEqual(tool.name, "Name")
        XCTAssertEqual(tool.version, "1.0")
    }

    func testParse() {
        var tool = Tool(name: "SuperTool", version: "1.0", command: Command(documentation: "Does super things"))
        tool.outputStream = ""
        tool.errorStream = ""
        tool.run()

        XCTAssertEqual(tool.outputStream as! String, "")
        XCTAssertEqual(tool.errorStream as! String, "")
    }
}
