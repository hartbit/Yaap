import XCTest
@testable import Commandable

class CommandableTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(Commandable().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
