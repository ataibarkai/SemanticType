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
    
    func testComparable() {
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
    
    
    
    static var allTests = [
        ("testCustomStringConvertibleConformance", testCustomStringConvertibleConformance),
        ("testCustomDebugStringConvertibleConformance", testCustomDebugStringConvertibleConformance),
        ("testHashable", testHashable),
        ("testComparable", testComparable),
    ]
}
