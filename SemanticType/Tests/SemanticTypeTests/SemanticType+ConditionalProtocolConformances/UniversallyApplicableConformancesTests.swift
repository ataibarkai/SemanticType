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
        
        // a helper function to disamgiguate the `.count` we get from the `Collection` conditional conformance extensions,
        // from the `.count` we get from the universal subscript extension.
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
            .create(AnyBidirectionalCollection(["elk", "pit", "cat", "dog", "bat", "try"]))
            .get()
        
        // a helper function to disamgiguate the `.count` we get from the `Collection` conditional conformance extensions,
        // from the `.count` we get from the universal subscript extension.
        func processAsBidirectionalCollection<C: BidirectionalCollection>(aFewWords: C) where C.Element == String {
            XCTAssertEqual(aFewWords.last!, "try")
            XCTAssertEqual(
                Array(aFewWords.reversed()),
                ["try", "bat", "dog", "cat", "pit", "elk"]
            )
        }
        processAsBidirectionalCollection(aFewWords: aFewWords)

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
    ]
}
