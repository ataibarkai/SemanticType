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
        enum UniquelyStrangeString_Spec: SemanticTypeSpec {
            typealias BackingPrimitiveWithValueSemantics = StrangeString
            typealias Error = Never
            static func gatewayMap(preMap: StrangeString) -> Result<StrangeString, Never> {
                return .success(preMap)
            }
        }
        typealias UniquelyStrangeString = SemanticType<UniquelyStrangeString_Spec>
        
        let uniquelyStrangeBobString = UniquelyStrangeString(.init(str: "Bob"))
        XCTAssertEqual("\(uniquelyStrangeBobString)", "Bob... how strange...")
    }
    
//    func testCustomStringConvertibleConformance() {
//        struct StrangeString: CustomStringConvertible {
//            var str: String
//            
//            var description: String {
//                "\(str)... how strange..."
//            }
//        }
//        enum UniquelyStrangeString_Spec: SemanticTypeSpec {
//            typealias BackingPrimitiveWithValueSemantics = StrangeString
//            typealias Error = Never
//            static func gatewayMap(preMap: StrangeString) -> Result<StrangeString, Never> {
//                return .success(preMap)
//            }
//        }
//        typealias UniquelyStrangeString = SemanticType<UniquelyStrangeString_Spec>
//        
//        let uniquelyStrangeBobString = UniquelyStrangeString(.init(str: "Bob"))
//        XCTAssertEqual("\(uniquelyStrangeBobString)", "Bob... how strange...")
//    }
    
    static var allTests = [
        ("testCustomStringConvertibleConformance", testCustomStringConvertibleConformance),
    ]
}
