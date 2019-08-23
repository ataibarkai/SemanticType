import XCTest
@testable import SemanticType

final class SemanticType_UsabilityExtensionsTests_ErrorfulSemanticType: XCTestCase {
    
    struct Person: Equatable {
        var name: String
        
        var associatedGreeting: String {
            "Hello, my name is \(name)."
        }
    }
    
    enum PersonWithShortName_Spec: SemanticTypeSpec {
        typealias BackingPrimitiveWithValueSemantics = Person
        
        enum Error: Swift.Error, Equatable {
            case nameIsTooLong(name: String)
        }
        
        static func gatewayMap(preMap: Person) -> Result<Person, PersonWithShortName_Spec.Error> {
            guard preMap.name.count < 5
                else { return .failure(.nameIsTooLong(name: preMap.name)) }
            
            return .success(preMap)
        }
    }
    typealias PersonWithShortName = SemanticType<PersonWithShortName_Spec>
    
    
    
    func testInitialization() {
        XCTAssertNoThrow(
            try PersonWithShortName(Person(name: "Joe"))
        )
        
        XCTAssertThrowsError(try PersonWithShortName(Person(name: "Joseph"))) { error in
            XCTAssertEqual(
                error as! PersonWithShortName_Spec.Error,
                .nameIsTooLong(name: "Joseph")
            )
        }
    }
    
    func testBackingPrimitiveAccess() {
        let joe = try! PersonWithShortName(Person(name: "Joe"))
        XCTAssertEqual(joe.backingPrimitive, Person(name: "Joe"))
        
        let dean = try! PersonWithShortName(Person(name: "Dean"))
        XCTAssertEqual(dean.backingPrimitive, Person(name: "Dean"))
        
        let tom = try! PersonWithShortName(Person(name: "tom"))
        XCTAssertEqual(tom.backingPrimitive, Person(name: "tom"))
    }
    
    func testSubscriptAccess() {
        let tim = try! PersonWithShortName(Person(name: "Tim"))
        XCTAssertEqual(tim.name, "Tim")
        XCTAssertEqual(tim.associatedGreeting, "Hello, my name is Tim.")

        let bill = try! PersonWithShortName(Person(name: "Bill"))
        XCTAssertEqual(bill.name, "Bill")
        XCTAssertEqual(bill.associatedGreeting, "Hello, my name is Bill.")
    }
    
    func testTryMap() {
        
    }
    
    

    static var allTests = [
        ("testInitialization", testInitialization),
        ("testBackingPrimitiveAccess", testBackingPrimitiveAccess),
        ("testSubscriptAccess", testSubscriptAccess),
        ("testTryMap", testTryMap),
    ]
}
