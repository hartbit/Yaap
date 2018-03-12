import XCTest
@testable import CommendableTests

XCTMain([
    testCase(ArgumentsTests.allTests),
    testCase(CommandsTests.allTests),
    testCase(ToolTests.allTests),
])
