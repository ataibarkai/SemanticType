import XCTest
@testable import SemanticType

final class SemanticType_UsabilityExtensionsTests_ErrorlessSemanticTypeTests: XCTestCase {
        
    enum CaselessString_Spec: SemanticTypeSpec {
        typealias BackingPrimitiveWithValueSemantics = String
        typealias Error = Never
        
        static func gatewayMap(preMap: String) -> Result<String, Never> {
            return .success(preMap.lowercased())
        }
    }
    typealias CaselessString = SemanticType<CaselessString_Spec>
    
    enum Dollars_Spec: SemanticTypeSpec {
        typealias BackingPrimitiveWithValueSemantics = Int
        typealias Error = Never
    }
    typealias Dollars = SemanticType<Dollars_Spec>
    
    enum name {
        case <#case#>
    }
    
    
    func testInitialization() {
        let hello = CaselessString("HELlo")
        XCTAssertEqual(hello._backingPrimitiveProxy, "hello")
    }
    
    func testBackingPrimitiveAccess() {
        var joe = CaselessString("Joe")
        XCTAssertEqual(joe.backingPrimitive, "Joe")
        joe.backingPrimitive.removeLast()
        joe.backingPrimitive.append("seph")
        XCTAssertEqual(joe.backingPrimitive, "Joseph")
        
        var someMoney = Dollars(15)
        XCTAssertEqual(someMoney.backingPrimitive, 15)
        someMoney.backingPrimitive += 25
        XCTAssertEqual(someMoney.backingPrimitive, 40)
    }
    
    func testSubscriptAccess() {
        let tim = try! PersonWithShortName(Person(name: "Tim"))
        XCTAssertEqual(tim.name, "Tim")
        XCTAssertEqual(tim.associatedGreeting, "Hello, my name is Tim.")

        let bill = try! PersonWithShortName(Person(name: "Bill"))
        XCTAssertEqual(bill.name, "Bill")
        XCTAssertEqual(bill.associatedGreeting, "Hello, my name is Bill.")
    }
    
    func testSuccessfulTryMap() {
        let joe = try! PersonWithShortName(Person(name: "Joe"))
        let lowercaseJoe = try! joe.tryMap { person in
            var person = person
            person.name = person.name.lowercased()
            return person
        }.get()
        XCTAssertEqual(lowercaseJoe.name, "joe")
    }
    
    func testFailingTryMap() {
        let joe = try! PersonWithShortName(Person(name: "Joe"))

        let josephTooLong = joe.tryMap { person in
            var person = person
            person.name.removeLast()
            person.name.append(contentsOf: "seph")
            return person
        }
        
        switch josephTooLong {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(
                error,
                PersonWithShortName.Spec.NameIsTooLongError(name: "Joseph")
            )
        }
    }
    
    func testSuccessfulMutatingTryMap() {
        var joe = try! PersonWithShortName(Person(name: "Joe"))
        
        XCTAssertEqual(joe.name, "Joe")
        try! joe.mutatingTryMap { person in person.name = person.name.lowercased() }
        XCTAssertEqual(joe.name, "joe")
    }
    
    func testFailingMutatingTryMap() {
        var joe = try! PersonWithShortName(Person(name: "Joe"))
        
        XCTAssertEqual(joe.name, "Joe")
        XCTAssertThrowsError(
            try joe.mutatingTryMap { person in
                  person.name.removeLast()
                  person.name.append(contentsOf: "seph")
            }
        ) { error in
            XCTAssertEqual(
                error as! PersonWithShortName.Spec.NameIsTooLongError,
                PersonWithShortName.Spec.NameIsTooLongError.init(name: "Joseph")
            )
        }
    }

    
    static var allTests = [
        ("testInitialization", testInitialization),
        ("testBackingPrimitiveAccess", testBackingPrimitiveAccess),
        ("testSubscriptAccess", testSubscriptAccess),
        ("testSuccessfulTryMap", testSuccessfulTryMap),
        ("testFailingTryMap", testFailingTryMap),
        ("testSuccessfulMutatingTryMap", testSuccessfulMutatingTryMap),
        ("testFailingMutatingTryMap", testFailingMutatingTryMap),
    ]
}
