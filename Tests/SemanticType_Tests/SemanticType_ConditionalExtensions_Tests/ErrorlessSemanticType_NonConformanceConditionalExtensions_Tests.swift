import XCTest
@testable import SemanticType

final class ErrorlessSemanticType_NonConformanceConditionalExtensions_Tests: XCTestCase {
    
    func testNumericBackedSemanticTypeMultiplication() {
        
        enum Seconds_Spec: ErrorlessSemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = Double
            static func gateway(preMap: Double) -> Double {
                return preMap
            }
        }
        typealias Seconds = SemanticType<Seconds_Spec>
        
        let fiveSeconds = Seconds(5)
        let tenSeconds = fiveSeconds * Double(2)
        XCTAssertEqual(
            tenSeconds,
            Seconds(10)
        )
        
        let anotherTenSecond = Double(2) * fiveSeconds
        XCTAssertEqual(
            anotherTenSecond,
            Seconds(10)
        )
        
        var finalTime = fiveSeconds
        finalTime *= Double(3)
        XCTAssertEqual(
            finalTime,
            Seconds(15)
        )
    }
    
    static var allTests = [
        ("testNumericBackedSemanticTypeMultiplication", testNumericBackedSemanticTypeMultiplication),
    ]

}
