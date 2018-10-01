import XCTest

import CommendableTests

var tests = [XCTestCaseEntry]()
tests += CommendableTests.__allTests()

XCTMain(tests)
