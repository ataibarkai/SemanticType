import XCTest
@testable import SemanticType

final class SemanticType_Core_Tests: XCTestCase {
    
    func testErrorlessModificationlessCreation() {
        enum Cents_Spec: ErrorlessSemanticTypeSpec {
            typealias RawValue = Int
            static func gateway(preMap: Int) -> Int {
                return preMap
            }
        }
        typealias Cents = SemanticType<Cents_Spec>
        
        let fiftyCents = Cents.create(50).get()
        XCTAssertEqual(fiftyCents._rawValue, 50)
        
        let fiftyCentsDebt = Cents.create(-50).get()
        XCTAssertEqual(fiftyCentsDebt._rawValue, -50)
        
        let adviceMoney = Cents.create(2).get()
        XCTAssertEqual(adviceMoney._rawValue, 2)

        let bezosMoney = Cents.create(2_000_000_000_000).get()
        XCTAssertEqual(bezosMoney._rawValue, 2_000_000_000_000)
    }
    

    func testErrorlessValueModifyingCreation() {
        enum CaselessString_Spec: ErrorlessSemanticTypeSpec {
            typealias RawValue = String
            static func gateway(preMap: String) -> String {
                return preMap.lowercased()
            }
        }
        typealias CaselessString = SemanticType<CaselessString_Spec>

        let str1: CaselessString = CaselessString.create("HeLlo, WorLD.").get()
        XCTAssertEqual(str1._rawValue, "hello, world.")
        
        let str2: CaselessString = CaselessString.create("Why would Jerry BRING anything?").get()
        XCTAssertEqual(str2._rawValue, "why would jerry bring anything?")
        
        let str3: CaselessString = CaselessString.create("Why would JERRY bring anything?").get()
        XCTAssertEqual(str3._rawValue, "why would jerry bring anything?")

        let str4: CaselessString = CaselessString.create("Yo-Yo Ma").get()
        XCTAssertEqual(str4._rawValue, "yo-yo ma")
    }
    
    
    func testErrorfullCreation() {
        enum FiveLetterWordArray_Spec: SemanticTypeSpec {
            typealias RawValue = [String]
            struct Error: Swift.Error {
                var excludedWords: [String]
            }
            
            static func gateway(preMap: [String]) -> Result<[String], Error> {
                let excludedWords = preMap.filter { $0.count != 5 }
                guard excludedWords.isEmpty
                    else { return .failure(.init(excludedWords: excludedWords)) }
                return .success(preMap)
            }
        }
        typealias FiveLetterWordArray = SemanticType<FiveLetterWordArray_Spec>
        
        let arrayThatOnlyContainsFiveLetterWords = ["12345", "Earth", "water", "melon", "12345", "great"]
        
        let shouldBeValid = FiveLetterWordArray.create(arrayThatOnlyContainsFiveLetterWords)
        switch shouldBeValid {
        case .success(let fiveLetterWordArray):
            XCTAssertEqual(fiveLetterWordArray._rawValue, arrayThatOnlyContainsFiveLetterWords)
        case .failure:
            XCTFail()
        }
        
        let oneInvalidWord = FiveLetterWordArray.create(arrayThatOnlyContainsFiveLetterWords + ["123456"])
        switch oneInvalidWord {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error.excludedWords, ["123456"])
        }
        
        let nonFiveLetterWords = ["123456", "abc", "foo", "A", "123456", "A!"]
        let aFewInvalidWords = FiveLetterWordArray.create(arrayThatOnlyContainsFiveLetterWords + nonFiveLetterWords)
        switch aFewInvalidWords {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error.excludedWords, nonFiveLetterWords)
        }
    }
    
    func testMeaningfulGatewayMetadata() {
        let joesEmail = try! EmailAddress.create("Joe1234@GMAIL.com").get()
        XCTAssertEqual(joesEmail.user, "joe1234")
        XCTAssertEqual(joesEmail.host, "gmail.com")
        
        let invalidEmail = EmailAddress.create("@gmail.com")
        switch invalidEmail {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error.candidateEmailAddress, "@gmail.com")
        }
        
        
        let oneTwoThree = try! NonEmptyIntArray.create([1, 2, 3]).get()
        XCTAssertEqual(oneTwoThree.first as Int, 1)
        XCTAssertEqual(oneTwoThree.last as Int, 3)
        
        XCTAssertThrowsError(
            try NonEmptyIntArray.create([]).get()
        )
    }
    
    
    
    static var allTests = [
        ("testErrorlessModificationlessCreation", testErrorlessModificationlessCreation),
        ("testErrorlessValueModifyingCreation", testErrorlessValueModifyingCreation),
        ("testErrorfullCreation", testErrorfullCreation),
        ("testMeaningfulGatewayMetadata", testMeaningfulGatewayMetadata),
    ]
}

// we define `EmailAddress` outside of the test function so that we can write an extension for it
enum EmailAddress_Spec: GeneralizedSemanticTypeSpec {
    typealias RawValue = String
    struct GatewayMetadataWithValueSemantics {
        var beforeAtSign: String
        var afterAtSign: String
    }
    struct Error: Swift.Error {
        var candidateEmailAddress: String
    }
    
    static func gateway(preMap: String) -> Result<GatewayOutput, Error> {
        let preMap = preMap.lowercased()
        
        guard let indexOfFirstAtSign = preMap.firstIndex(of: "@")
            else { return .failure(.init(candidateEmailAddress: preMap)) }
        
        let beforeAtSign = preMap[..<indexOfFirstAtSign]
        let afterAtSign = preMap[indexOfFirstAtSign...].dropFirst()
        
        // make sure we have valid strings before and after the `@`
        guard !beforeAtSign.isEmpty && !afterAtSign.isEmpty
            else { return .failure(.init(candidateEmailAddress: preMap)) }
        
        return .success(.init(
            rawValue: preMap,
            metadata: .init(beforeAtSign: String(beforeAtSign),
                            afterAtSign: String(afterAtSign))
        ))
    }
}
typealias EmailAddress = SemanticType<EmailAddress_Spec>

extension EmailAddress {
    var user: String {
        gatewayMetadata.beforeAtSign
    }
    
    var host: String {
        gatewayMetadata.afterAtSign
    }
}



// we define `NonEmptyIntArray_Spec` outside of the test function so that we can write an extension for it
enum NonEmptyIntArray_Spec: GeneralizedSemanticTypeSpec {
    typealias RawValue = [Int]
    struct GatewayMetadataWithValueSemantics {
        var first: Int
        var last: Int
    }
    enum Error: Swift.Error {
        case arrayIsEmpty
    }
    
    static func gateway(preMap: [Int]) -> Result<GatewayOutput, Error> {
        
        // a non-empty array will always have first/last elements:
        guard
            let first = preMap.first,
            let last = preMap.last
            else {
                return .failure(.arrayIsEmpty)
        }
        
        return .success(.init(
            rawValue: preMap,
            metadata: .init(first: first,
                            last: last)
        ))
    }
}
typealias NonEmptyIntArray = SemanticType<NonEmptyIntArray_Spec>

extension NonEmptyIntArray {
    var first: Int {
        return gatewayMetadata.first
    }
    
    var last: Int {
        return gatewayMetadata.last
    }
}
