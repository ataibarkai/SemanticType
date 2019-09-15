import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SemanticType_Core_Tests.allTests),
        testCase(SemanticTypeSpec_Tests.allTests),
        
        testCase(ErrorlessSemanticType_Numeric_Tests.allTests),
        
        testCase(ErrorlessSemanticType_ConditionalConformances_ExpressibleByLiteral_Tests.allTests),
        testCase(ErrorlessSemanticType_ConditionalConformances_Standard_Tests.allTests),
        testCase(ErrorlessSemanticType_NonConformanceConditionalExtensions_Tests.allTests),
        testCase(SemanticType_ConditionalConformances_Standard_Tests.allTests),
        
        testCase(SemanticType_UsabilityExtensionsTests_ErrorfulSemanticTypeTests.allTests),
        testCase(SemanticType_UsabilityExtensionsTests_ErrorlessSemanticTypeTests.allTests),
    ]
}
#endif
