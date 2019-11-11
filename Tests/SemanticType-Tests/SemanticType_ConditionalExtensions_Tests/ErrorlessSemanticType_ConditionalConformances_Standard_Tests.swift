import XCTest
@testable import SemanticType

final class ErrorlessSemanticType_ConditionalConformances_Standard_Tests: XCTestCase {
    
    func testAdditiveArithmeticConformance() {
        enum Seconds_Spec: ErrorlessSemanticTypeSpec {
            typealias RawValue = Double
            static func gateway(preMap: Double) -> Double {
                return preMap
            }
        }
        typealias Seconds = SemanticType<Seconds_Spec>
        
        var step1Duration: Seconds = 5
        let step2Duration: Seconds = 10
        
        XCTAssertEqual(
            step1Duration + step2Duration,
            Seconds(15)
        )
        
        step1Duration += 7
        XCTAssertEqual(
            step1Duration,
            Seconds(12)
        )
        
        XCTAssertEqual(
            step1Duration - step2Duration,
            Seconds(2)
        )
        
        step1Duration -= 9
        XCTAssertEqual(
            step1Duration,
            Seconds(3)
        )
    }
    
    static var allTests = [
        ("testAdditiveArithmeticConformance", testAdditiveArithmeticConformance),
    ]

}
