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
    
    
    func testHashable() {
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
    
    
    func testEquatable() {
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
    
    
    
    static var allTests = [
        ("testCustomStringConvertibleConformance", testCustomStringConvertibleConformance),
        ("testCustomDebugStringConvertibleConformance", testCustomDebugStringConvertibleConformance),
        ("testHashable", testHashable),
    ]
}
