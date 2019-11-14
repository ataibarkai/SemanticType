import XCTest

import SemanticTypeTests

var tests = [XCTestCaseEntry]()
tests += SemanticType_Core_Tests.allTests,
tests += SemanticTypeSpec_Tests.allTests,

tests += ErrorlessSemanticType_ConditionalConformances_ExpressibleByLiteral_Tests.allTests,
tests += ErrorlessSemanticType_ConditionalConformances_Standard_Tests.allTests,
tests += SemanticType_ConditionalConformances_Standard_Tests.allTests,

tests += SemanticType_UsabilityExtensionsTests_ErrorfulSemanticTypeTests.allTests,
tests += SemanticType_UsabilityExtensionsTests_ErrorlessSemanticTypeTests.allTests,

XCTMain(tests)
