import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SemanticTypeCoreCreationTests.allTests),
        testCase(SemanticType_UsabilityExtensionsTests_ErrorfulSemanticTypeTests.allTests),
        testCase(SemanticType_UsabilityExtensionsTests_ErrorlessSemanticTypeTests.allTests),
    ]
}
#endif
