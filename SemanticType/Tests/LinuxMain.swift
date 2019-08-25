import XCTest

import SemanticTypeTests

var tests = [XCTestCaseEntry]()
tests += SemanticTypeCoreCreationTests.allTests()
tests += SemanticType_UsabilityExtensionsTests_ErrorfulSemanticTypeTests.allTests()
tests += SemanticType_UsabilityExtensionsTests_ErrorlessSemanticTypeTests.allTests()
XCTMain(tests)
