import XCTest
@testable import SemanticType

final class SemanticType_UsabilityExtensionsTests: XCTestCase {
    func testErrorfullSemanticType() {
        struct Person {
            var name: String
        }
        
        enum PersonWithShortName_Spec: SemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = Person
            enum Error: Swift.Error {
                case nameIsTooLong(name: String)
            }
            
            static func gatewayMap(preMap: Person) -> Result<Person, PersonWithShortName_Spec.Error> {
                guard preMap.name.count < 5
                    else { return .failure(.nameIsTooLong(name: preMap.name)) }
                
                return .success(preMap)
            }
        }
        typealias PersonWithShortName = SemanticType<PersonWithShortName_Spec>
        
        XCTAssertNoThrow(
            try PersonWithShortName(Person(name: "Joe"))
        )
          
    }

    static var allTests = [
        ("testErrorfullSemanticType", testErrorfullSemanticType),
    ]
}
