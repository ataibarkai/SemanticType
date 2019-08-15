import XCTest

import SemanticTypeTests

var tests = [XCTestCaseEntry]()
tests += SemanticTypeTests.allTests()
tests += SemanticTypeCoreCreationTests.allTests()
XCTMain(tests)
