//
//  SemanticTypeCoreCreationTests.swift
//  
//
//  Created by Atai Barkai on 8/13/19.
//

import XCTest
@testable import SemanticType

final class SemanticTypeCoreCreationTests: XCTestCase {
    
    func testErrorlessModificationlessCreation() {
        enum Cents_Spec: ErrorlessSemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = Int
            typealias Error = Never
            static func gateway(preMap: Int) -> Int {
                return preMap
            }
        }
        typealias Cents = SemanticType<Cents_Spec>
        
        let fiftyCents = Cents.create(50).get()
        XCTAssertEqual(fiftyCents._gatewayOutput.backingPrimitvie, 50)
        
        let fiftyCentsDebt = Cents.create(-50).get()
        XCTAssertEqual(fiftyCentsDebt._gatewayOutput.backingPrimitvie, -50)
        
        let adviceMoney = Cents.create(2).get()
        XCTAssertEqual(adviceMoney._gatewayOutput.backingPrimitvie, 2)

        let bezosMoney = Cents.create(2_000_000_000_000).get()
        XCTAssertEqual(bezosMoney._gatewayOutput.backingPrimitvie, 2_000_000_000_000)
    }
    

    func testErrorlessValueModifyingCreation() {
        enum CaselessString_Spec: ErrorlessSemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = String
            typealias Error = Never
            
            static func gateway(preMap: String) -> String {
                return preMap.lowercased()
            }
        }
        typealias CaselessString = SemanticType<CaselessString_Spec>

        let str1: CaselessString = CaselessString.create("HeLlo, WorLD.").get()
        XCTAssertEqual(str1._gatewayOutput.backingPrimitvie, "hello, world.")
        
        let str2: CaselessString = CaselessString.create("Why would Jerry BRING anything?").get()
        XCTAssertEqual(str2._gatewayOutput.backingPrimitvie, "why would jerry bring anything?")
        
        let str3: CaselessString = CaselessString.create("Why would JERRY bring anything?").get()
        XCTAssertEqual(str3._gatewayOutput.backingPrimitvie, "why would jerry bring anything?")

        let str4: CaselessString = CaselessString.create("Yo-Yo Ma").get()
        XCTAssertEqual(str4._gatewayOutput.backingPrimitvie, "yo-yo ma")
    }
    
    
    func testErrorfullCreation() {
        enum FiveLetterWordArray_Spec: SemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = [String]
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
            XCTAssertEqual(fiveLetterWordArray._gatewayOutput.backingPrimitvie, arrayThatOnlyContainsFiveLetterWords)
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
    typealias BackingPrimitiveWithValueSemantics = String
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
            backingPrimitvie: preMap,
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
