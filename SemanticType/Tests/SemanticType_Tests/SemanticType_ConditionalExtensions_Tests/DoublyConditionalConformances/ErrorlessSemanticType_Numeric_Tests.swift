import XCTest
@testable import SemanticType

final class ErrorlessSemanticType_Numeric_Tests: XCTestCase {
    
    func testNumericConformance() {
        enum UserEnteredInt_Spec: ErrorlessSemanticTypeSpec, ShouldBeNumeric {
            typealias BackingPrimitiveWithValueSemantics = Int
            static func gateway(preMap: Int) -> Int {
                return preMap
            }
        }
        typealias UserEnteredInt = SemanticType<UserEnteredInt_Spec>
        
        let five = UserEnteredInt(5)
        let six = UserEnteredInt(6)
        
        let thirty = five * six
        XCTAssertEqual(thirty, UserEnteredInt(30))
        
        var finalNumber = UserEnteredInt(10)
        finalNumber *= six
        XCTAssertEqual(finalNumber, UserEnteredInt(60))
    }
    
    static var allTests = [
        ("testNumericConformance", testNumericConformance),
    ]

}


