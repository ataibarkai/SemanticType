import XCTest
@testable import SemanticType

final class SemanticType_UsabilityExtensionsTests_ErrorfulSemanticTypeTests: XCTestCase {
    
    struct Person: Equatable {
        var name: String
        var associatedGreeting: String
        
        init(name: String) {
            self.name = name
            self.associatedGreeting = "Hello, my name is \(name)." // initialize greeting to default
        }
    }
    enum PersonWithShortName_Spec: SemanticTypeSpec {
        typealias BackingPrimitiveWithValueSemantics = Person
        enum Error: Swift.Error, Equatable {
            case nameIsTooLong(name: String)
        }
        
        static func gateway(preMap: Person) -> Result<Person, PersonWithShortName_Spec.Error> {
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
                error as! PersonWithShortName.Spec.Error,
                PersonWithShortName.Spec.Error.nameIsTooLong(name: "Joseph")
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
    
    
    func testSuccessfulTryMap() {
        let joe = try! PersonWithShortName(Person(name: "Joe"))
        let lowercaseJoeResult = joe.tryMap { person in
            var person = person
            person.associatedGreeting = person.associatedGreeting.lowercased()
            return person
        }
        let lowercaseJoe = try! lowercaseJoeResult.get()
        
        XCTAssertEqual(lowercaseJoe.associatedGreeting, "hello, my name is joe.")
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
                PersonWithShortName.Spec.Error.nameIsTooLong(name: "Joseph")
            )
        }
    }
    
    
    func testSuccessfulMutatingTryMap() {
        var joe = try! PersonWithShortName(Person(name: "Joe"))
        XCTAssertEqual(joe.name, "Joe")
        try! joe.mutatingTryMap { person in person.name = person.name.lowercased() }
        XCTAssertEqual(joe.name, "joe")
        
        var joesEmail = try! EmailAddress.create("JonaTHAN@gmail.com").get()
        XCTAssertEqual(joesEmail.user, "jonathan")
        XCTAssertEqual(joesEmail.host, "gmail.com")
        try! joesEmail.mutatingTryMap { email in
            email.removeLast(3)
            email.append("nET")
        }
        XCTAssertEqual(joesEmail.user, "jonathan")
        XCTAssertEqual(joesEmail.host, "gmail.net")
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
                error as! PersonWithShortName.Spec.Error,
                PersonWithShortName.Spec.Error.nameIsTooLong(name: "Joseph")
            )
        }
        
        
        var joesEmail = try! EmailAddress.create("JonaTHAN@gmail.com").get()
        XCTAssertEqual(joesEmail.user, "jonathan")
        XCTAssertEqual(joesEmail.host, "gmail.com")
        XCTAssertThrowsError(
            try joesEmail.mutatingTryMap { email in
                email.removeLast(10)
            }
        ) { error in
            XCTAssertEqual(
                (error as! EmailAddress.Spec.Error).candidateEmailAddress,
                "jonathan"
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
