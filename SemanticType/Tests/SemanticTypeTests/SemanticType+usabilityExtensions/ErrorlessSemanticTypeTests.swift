import XCTest
@testable import SemanticType

final class SemanticType_UsabilityExtensionsTests_ErrorlessSemanticTypeTests: XCTestCase {
    
    // CaselessString:
    enum CaselessString_Spec: SemanticTypeSpec {
        typealias BackingPrimitiveWithValueSemantics = String
        typealias Error = Never
        
        static func gateway(preMap: String) -> Result<String, Never> {
            return .success(preMap.lowercased())
        }
    }
    typealias CaselessString = SemanticType<CaselessString_Spec>
    
    // Dollars:
    enum Dollars_Spec: ErrorlessSemanticTypeSpec {
        typealias BackingPrimitiveWithValueSemantics = Int
        typealias Error = Never
        static func gateway(preMap: Int) -> Int {
            return preMap
        }
    }
    typealias Dollars = SemanticType<Dollars_Spec>
    
    
    // ProcessedContactFormInput_Spec:
    struct ContactFormInput {
        var email: String
        var message: String
    }
    enum ProcessedContactFormInput_Spec: SemanticTypeSpec {
        typealias BackingPrimitiveWithValueSemantics = ContactFormInput
        typealias Error = Never
        
        static func gateway(preMap: ContactFormInput) -> Result<ContactFormInput, Never> {
            return .success(.init(
                email: preMap.email.lowercased(),
                message: preMap.message
            ))
        }
    }
    typealias ProcessedContactFormInput = SemanticType<ProcessedContactFormInput_Spec>

    

    func testInitialization() {
        let hello = CaselessString("HELlo")
        XCTAssertEqual(hello._gatewayOutput.backingPrimitvie, "hello")
    }
    
    
    func testBackingPrimitiveAccessAndModification() {
        var joe = CaselessString("Joe")
        XCTAssertEqual(joe.backingPrimitive, "joe")
        joe.backingPrimitive.removeLast()
        joe.backingPrimitive.append("SEPH")
        XCTAssertEqual(joe.backingPrimitive, "joseph")
        
        var someMoney = Dollars(15)
        XCTAssertEqual(someMoney.backingPrimitive, 15)
        someMoney.backingPrimitive += 25
        XCTAssertEqual(someMoney.backingPrimitive, 40)
        
        var joesProcessedContactFormInput = ProcessedContactFormInput(.init(
            email: "joe.shmoe@GMAIL.com",
            message: "What a great library!"
        ))
        XCTAssertEqual(joesProcessedContactFormInput.backingPrimitive.email, "joe.shmoe@gmail.com")
        joesProcessedContactFormInput.backingPrimitive.email.removeLast(9)
        joesProcessedContactFormInput.backingPrimitive.email.append("YaHOO.cOm")
        XCTAssertEqual(joesProcessedContactFormInput.backingPrimitive.email, "joe.shmoe@yahoo.com")
    }
    
    
    func testSubscriptAccess() {
        let joesProcessedContactFormInput = ProcessedContactFormInput(.init(
            email: "joe.shmoe@GMAIL.com",
            message: "What a great library!"
        ))
        XCTAssertEqual(joesProcessedContactFormInput.email, "joe.shmoe@gmail.com")
        XCTAssertEqual(joesProcessedContactFormInput.message, "What a great library!")
    }
    
    
    func testMap() {
        let fiveDollars = Dollars(5)
        let tenDollars = fiveDollars.map { $0 + 5 }
        XCTAssertEqual(tenDollars.backingPrimitive, 10)
    }
    
    
    func testMutatingMap() {
        var anAmountOfDollars = Dollars(5)
        
        XCTAssertEqual(anAmountOfDollars.backingPrimitive, 5)
        anAmountOfDollars.mutatingMap { $0 += 5 }
        XCTAssertEqual(anAmountOfDollars.backingPrimitive, 10)
    }
    
    
    
    static var allTests = [
        ("testInitialization", testInitialization),
        ("testBackingPrimitiveAccessAndModification", testBackingPrimitiveAccessAndModification),
        ("testSubscriptAccess", testSubscriptAccess),
        ("testMap", testMap),
        ("testMutatingMap", testMutatingMap),
    ]
}
