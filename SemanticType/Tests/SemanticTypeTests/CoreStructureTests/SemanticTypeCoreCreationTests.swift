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
        enum Cents_Spec: SemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = Int
            typealias Error = Never
        }
        typealias Cents = SemanticType<Cents_Spec>
        
        let fiftyCents = Cents.create(50).get()
        XCTAssertEqual(fiftyCents._backingPrimitiveProxy, 50)
        
        let negativeFiftyCents = Cents.create(-50).get()
        XCTAssertEqual(negativeFiftyCents._backingPrimitiveProxy, -50)
        
        let adviceMoney = Cents.create(2).get()
        XCTAssertEqual(adviceMoney._backingPrimitiveProxy, 2)

        let aLotOfAdvice = Cents.create(2_000_000_000_000).get()
        XCTAssertEqual(aLotOfAdvice._backingPrimitiveProxy, 2_000_000_000_000)

    }

    func testErrorlessValueModifyingCreation() {
        enum CaselessString_Spec: SemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = String
            typealias Error = Never
            
            static func gatewayMap(preMap: String) -> Result<String, Never> {
                return .success(preMap.lowercased())
            }
        }
        typealias CaselessString = SemanticType<CaselessString_Spec>

        let str1: CaselessString = CaselessString.create("HeLlo, WorLD.").get()
        XCTAssertEqual(str1._backingPrimitiveProxy, "hello, world.")
        
        let str2: CaselessString = CaselessString.create("Why would Jerry BRING anything?").get()
        XCTAssertEqual(str2._backingPrimitiveProxy, "why would jerry bring anything?")
        
        let str3: CaselessString = CaselessString.create("Why would JERRY bring anything?").get()
        XCTAssertEqual(str3._backingPrimitiveProxy, "why would jerry bring anything?")

        let str4: CaselessString = CaselessString.create("Yo-Yo Ma").get()
        XCTAssertEqual(str4._backingPrimitiveProxy, "yo-yo ma")
    }
    
    func testErrorfullCreation() {
        enum FiveLetterWordArray_Spec: SemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = [String]
            struct Error: Swift.Error {
                var excludedWords: [String]
            }
            
            static func gatewayMap(preMap: [String]) -> Result<[String], Error> {
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
            XCTAssertEqual(fiveLetterWordArray._backingPrimitiveProxy, arrayThatOnlyContainsFiveLetterWords)
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
    
    static var allTests = [
        ("testErrorlessModificationlessCreation", testErrorlessModificationlessCreation),
        ("testErrorlessValueModifyingCreation", testErrorlessValueModifyingCreation),
        ("testErrorfullCreation", testErrorfullCreation),
    ]
}
