import XCTest
@testable import SemanticType

final class SemanticType_UsabilityExtensionsTests_ErrorlessSemanticTypeTests: XCTestCase {
    
    // Dollars:
    enum Dollars_Spec: ErrorlessSemanticTypeSpec { typealias RawValue = Int }
    typealias Dollars = SemanticType<Dollars_Spec>

    // CaselessString:
    enum CaselessString_Spec: ErrorlessSemanticTypeSpec {
        typealias RawValue = String
        
        static func gateway(preMap: String) -> String {
            return preMap.lowercased()
        }
    }
    typealias CaselessString = SemanticType<CaselessString_Spec>
        
    // ProcessedContactFormInput_Spec:
    struct ContactFormInput {
        var email: String
        var message: String
    }
    enum ProcessedContactFormInput_Spec: ErrorlessSemanticTypeSpec {
        typealias RawValue = ContactFormInput
        
        static func gateway(preMap: ContactFormInput) -> ContactFormInput {
            return .init(
                email: preMap.email.lowercased(),
                message: preMap.message
            )
        }
    }
    typealias ProcessedContactFormInput = SemanticType<ProcessedContactFormInput_Spec>

    

    func testInitialization() {
        let hello = CaselessString("HELlo")
        XCTAssertEqual(hello._rawValue, "hello")
    }
    
    
    func testBackingPrimitiveAccessAndModification() {
        var joe = CaselessString("Joe")
        XCTAssertEqual(joe.rawValue, "joe")
        joe.rawValue.removeLast()
        joe.rawValue.append("SEPH")
        XCTAssertEqual(joe.rawValue, "joseph")
        
        var someMoney = Dollars(15)
        XCTAssertEqual(someMoney.rawValue, 15)
        someMoney.rawValue += 25
        XCTAssertEqual(someMoney.rawValue, 40)
        
        var joesProcessedContactFormInput = ProcessedContactFormInput(.init(
            email: "joe.shmoe@GMAIL.com",
            message: "What a great library!"
        ))
        XCTAssertEqual(joesProcessedContactFormInput.rawValue.email, "joe.shmoe@gmail.com")
        joesProcessedContactFormInput.rawValue.email.removeLast(9)
        joesProcessedContactFormInput.rawValue.email.append("YaHOO.cOm")
        XCTAssertEqual(joesProcessedContactFormInput.rawValue.email, "joe.shmoe@yahoo.com")
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
        XCTAssertEqual(tenDollars.rawValue, 10)
    }
    
    
    
    static var allTests = [
        ("testInitialization", testInitialization),
        ("testBackingPrimitiveAccessAndModification", testBackingPrimitiveAccessAndModification),
        ("testSubscriptAccess", testSubscriptAccess),
        ("testMap", testMap),
    ]
}
