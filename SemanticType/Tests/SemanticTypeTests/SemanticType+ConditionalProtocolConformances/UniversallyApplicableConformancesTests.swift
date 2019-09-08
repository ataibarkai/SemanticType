//
//  File.swift
//  
//
//  Created by Atai Barkai on 8/25/19.
//

import Foundation
import XCTest
@testable import SemanticType

final class SemanticType_ConditioinalProtocolConformances_UniversallyApplicableConformancesTests: XCTestCase {
    
    func testCustomStringConvertibleConformance() {
        struct StrangeString: CustomStringConvertible {
            var str: String
            
            var description: String {
                "\(str)... how strange..."
            }
        }
        enum UniquelyStrangeString_Spec: ErrorlessSemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = StrangeString
            static func gateway(preMap: StrangeString) -> StrangeString {
                return preMap
            }
        }
        typealias UniquelyStrangeString = SemanticType<UniquelyStrangeString_Spec>
        
        let uniquelyStrangeBobString = UniquelyStrangeString(.init(str: "Bob"))
        XCTAssertEqual("\(uniquelyStrangeBobString)", "Bob... how strange...")
    }
    
    func testCustomDebugStringConvertibleConformance() {
        struct StrangeString: CustomDebugStringConvertible {
            var str: String

            var debugDescription: String {
                "\(str)... how strange..."
            }
        }
        enum UniquelyStrangeString_Spec: ErrorlessSemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = StrangeString
            static func gateway(preMap: StrangeString) -> StrangeString {
                return preMap
            }
        }
        typealias UniquelyStrangeString = SemanticType<UniquelyStrangeString_Spec>

        let uniquelyStrangeBobString = UniquelyStrangeString(.init(str: "Bob"))
        XCTAssertEqual(
            (uniquelyStrangeBobString as CustomDebugStringConvertible).debugDescription,
            "(SemanticType<UniquelyStrangeString_Spec>): Bob... how strange..."
        )
    }
    
    
    func testHashableConformance() {
        struct StrangeString: Hashable {
            var str: String
        }
        enum UniquelyStrangeString_Spec: ErrorlessSemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = StrangeString
            static func gateway(preMap: StrangeString) -> StrangeString {
                return preMap
            }
        }
        typealias UniquelyStrangeString = SemanticType<UniquelyStrangeString_Spec>
        
        let dict = [
            UniquelyStrangeString(.init(str: "hello")): 5,
            UniquelyStrangeString(.init(str: "world")): 9,
        ]
        XCTAssertEqual(
            dict[UniquelyStrangeString(.init(str: "hello"))],
            5
        )
        XCTAssertEqual(
            dict[UniquelyStrangeString(.init(str: "world"))],
            9
        )
    }
    
    
    func testEquatableConformance() {
        struct StrangeString: Equatable {
            var str: String
        }
        enum UniquelyStrangeString_Spec: ErrorlessSemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = StrangeString
            static func gateway(preMap: StrangeString) -> StrangeString {
                return preMap
            }
        }
        typealias UniquelyStrangeString = SemanticType<UniquelyStrangeString_Spec>

        XCTAssertEqual(
            UniquelyStrangeString(.init(str: "hello")),
            UniquelyStrangeString(.init(str: "hello"))
        )
        XCTAssertNotEqual(
            UniquelyStrangeString(.init(str: "hello")),
            UniquelyStrangeString(.init(str: "HEllo"))
        )
    }
    
    func testComparableConformance() {
        enum Dollars_Spec: ErrorlessSemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = Double
            static func gateway(preMap: Double) -> Double {
                return preMap
            }
        }
        typealias Dollars = SemanticType<Dollars_Spec>
        
        XCTAssertTrue(Dollars(5) < Dollars(5.1))
        XCTAssertTrue(Dollars(7) < Dollars(3934))
        XCTAssertTrue(Dollars(100) < Dollars(92345))
        XCTAssertTrue(Dollars(-235) < Dollars(2342342))
        XCTAssertTrue(Dollars(-235) < Dollars(-22))

        XCTAssertTrue(Dollars(10) > Dollars(-2342))
        XCTAssertTrue(Dollars(-22342) > Dollars(-234223424))
        XCTAssertTrue(Dollars(10) > Dollars(-2342))
        XCTAssertTrue(Dollars(1000) > Dollars(52))
    }
    
    func testErrorConformance() {
        struct SomeError: Swift.Error { }
        enum SpecialCaseError_Spec: ErrorlessSemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = SomeError
            static func gateway(preMap: SomeError) -> SomeError {
                return preMap
            }
        }
        typealias SpcialCaseError = SemanticType<SpecialCaseError_Spec>
        
        let throwSpecialCaseError: () throws -> () = {
            throw SpcialCaseError(.init())
        }
        
        XCTAssertThrowsError(try throwSpecialCaseError())
    }
    
    func testSequenceConformance() {
        enum ThreeLetterWordSequence_Spec<S: Sequence>: SemanticTypeSpec where S.Element == String {
            typealias BackingPrimitiveWithValueSemantics = S
            enum Error: Swift.Error {
                case foundWordWithMismatchedLength(word: String)
            }

            static func gateway(preMap: BackingPrimitiveWithValueSemantics) -> Result<BackingPrimitiveWithValueSemantics, Error> {
                if let mismatchedLengthWord = preMap.first(where: { $0.count != 3 }) {
                    return .failure(.foundWordWithMismatchedLength(word: mismatchedLengthWord))
                } else {
                    return .success(preMap)
                }
            }
        }
        typealias ThreeLetterWordSequence<S: Sequence> = SemanticType<ThreeLetterWordSequence_Spec<S>> where S.Element == String
        
        let aFewWords = try! ThreeLetterWordSequence
            .create(AnySequence(["elk", "pit", "cat", "dog", "bat", "try"]))
            .get()
        
        var enumeratedWords: [String] = []
        for word in aFewWords {
            enumeratedWords.append(word)
        }
        XCTAssertEqual(
            enumeratedWords,
            ["elk", "pit", "cat", "dog", "bat", "try"]
        )
    }
    
    func testCollectionConformance() {
        enum ThreeLetterWordCollection_Spec<C: Collection>: SemanticTypeSpec where C.Element == String {
            typealias BackingPrimitiveWithValueSemantics = C
            enum Error: Swift.Error {
                case foundWordWithMismatchedLength(word: String)
            }

            static func gateway(preMap: BackingPrimitiveWithValueSemantics) -> Result<BackingPrimitiveWithValueSemantics, Error> {
                if let mismatchedLengthWord = preMap.first(where: { $0.count != 3 }) {
                    return .failure(.foundWordWithMismatchedLength(word: mismatchedLengthWord))
                } else {
                    return .success(preMap)
                }
            }
        }
        typealias ThreeLetterWordCollection<C: Collection> = SemanticType<ThreeLetterWordCollection_Spec<C>> where C.Element == String
        
        
        let aFewWords = try! ThreeLetterWordCollection
            .create(AnyCollection(["elk", "pit", "cat", "dog", "bat", "try"]))
            .get()
        
        // a helper function to disamgiguate properties exposed through `Collection` conditional conformance extensions,
        // and properties exposed through the universal subscript extension.
        func processAsCollection<C: Collection>(aFewWords: C) {
            XCTAssertEqual(aFewWords.count, 6)
        }
        processAsCollection(aFewWords: aFewWords)
    }
    
    func testBidirectionalCollectionConformance() {
        enum ThreeLetterWordBidirectionalCollection_Spec<C: BidirectionalCollection>: SemanticTypeSpec where C.Element == String {
            typealias BackingPrimitiveWithValueSemantics = C
            enum Error: Swift.Error {
                case foundWordWithMismatchedLength(word: String)
            }

            static func gateway(preMap: BackingPrimitiveWithValueSemantics) -> Result<BackingPrimitiveWithValueSemantics, Error> {
                if let mismatchedLengthWord = preMap.first(where: { $0.count != 3 }) {
                    return .failure(.foundWordWithMismatchedLength(word: mismatchedLengthWord))
                } else {
                    return .success(preMap)
                }
            }
        }
        typealias ThreeLetterWordBidirectionalCollection<C: BidirectionalCollection> = SemanticType<ThreeLetterWordBidirectionalCollection_Spec<C>> where C.Element == String
        
        
        let aFewWords = try! ThreeLetterWordBidirectionalCollection
            .create(["elk", "pit", "cat", "dog", "bat", "try"])
            .get()
        
        // a helper function to disamgiguate properties exposed through `BidirectionalCollection` conditional conformance extensions,
        // and properties exposed through the universal subscript extension.
        func processAsBidirectionalCollection<C: BidirectionalCollection>(aFewWords: C) where C.Element == String, C.Index == Int {
            XCTAssertEqual(aFewWords.last, "try")
            XCTAssertEqual(
                Array(aFewWords.reversed()),
                ["try", "bat", "dog", "cat", "pit", "elk"]
            )
        }
        processAsBidirectionalCollection(aFewWords: aFewWords)
    }
    
    
    // MARK: `Encodable`/`Decodable` test
    
    // types used in Encodable/Decodable tests
    enum Age_Spec: ErrorlessSemanticTypeSpec {
        typealias BackingPrimitiveWithValueSemantics = Int
        static func gateway(preMap: Int) -> Int {
            return preMap
        }
    }
    typealias Age = SemanticType<Age_Spec>
    
    struct Person: Codable {
        var name: String
        var age: Age
    }
    
    enum YoungPerson_Spec: SemanticTypeSpec {
        typealias BackingPrimitiveWithValueSemantics = Person
        enum Error: Swift.Error {
            case tooOld(age: Age)
        }
        static func gateway(preMap: Person) -> Result<Person, Error> {
            guard preMap.age < 13
                else { return .failure(.tooOld(age: preMap.age)) }
            
            return .success(preMap)
        }
    }
    typealias YoungPerson = SemanticType<YoungPerson_Spec>

    
    func testEncodableConformance() {        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let agePersonJsonString: String = {
            let data = try! encoder.encode(
                Person(name: "John",
                       age: 6)
            )

            return String(data: data, encoding: .utf8)!
        }()
        
        let youngPersonJsonString: String = {
            let data = try! encoder.encode(
                try! YoungPerson(
                    .init(name: "John",
                          age: 6)
                )
            )
            return String(data: data, encoding: .utf8)!

        }()
        
        for personJsonString in [agePersonJsonString, youngPersonJsonString] {
            XCTAssertEqual(
                personJsonString,
                """
                {
                  "name" : "John",
                  "age" : 6
                }
                """
            )
        }
    }
    
    func testDecodableConformance() {
        let jsonString = """
        {
          "name" : "John",
          "age" : 6
        }
        """
        let decoder = JSONDecoder()
        
        let person = try! decoder.decode(Person.self,
                                         from: jsonString.data(using: .utf8)!)
        XCTAssertEqual(person.age, 6)
        XCTAssertEqual(person.name, "John")

        let youngPerson = try! decoder.decode(YoungPerson.self,
                                              from: jsonString.data(using: .utf8)!)
        XCTAssertEqual(youngPerson.age, 6)
        XCTAssertEqual(youngPerson.name, "John")
    }
    
    func testInteroperableEncodingDecoding() {
        struct PersonWithIntAge: Codable {
            var name: String
            var age: Int
        }

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let personData = try! encoder.encode(
            Person(name: "John",
                   age: 6)
        )
        let decodedPersonWithIntAge = try! decoder.decode(PersonWithIntAge.self, from: personData)
        XCTAssertEqual(decodedPersonWithIntAge.name, "John")
        XCTAssertEqual(decodedPersonWithIntAge.age, 6)
        
        
        let personWithIntAgeData = try! encoder.encode(
            PersonWithIntAge(name: "John",
                             age: 6)
        )
        let decodedPerson = try! decoder.decode(Person.self, from: personWithIntAgeData)
        XCTAssertEqual(decodedPerson.name, "John")
        XCTAssertEqual(decodedPerson.age, 6)        
    }
    
    
    static var allTests = [
        ("testCustomStringConvertibleConformance", testCustomStringConvertibleConformance),
        ("testCustomDebugStringConvertibleConformance", testCustomDebugStringConvertibleConformance),
        ("testHashableConformance", testHashableConformance),
        ("testEquatableConformance", testEquatableConformance),
        ("testComparableConformance", testComparableConformance),
        ("testErrorConformance", testErrorConformance),
        ("testSequenceConformance", testSequenceConformance),
        ("testCollectionConformance", testCollectionConformance),
        ("testBidirectionalCollectionConformance", testBidirectionalCollectionConformance),
        ("testEncodableConformance", testEncodableConformance),
        ("testDecodableConformance", testDecodableConformance),
        ("testInteroperableEncodingDecoding", testInteroperableEncodingDecoding),
    ]
}
