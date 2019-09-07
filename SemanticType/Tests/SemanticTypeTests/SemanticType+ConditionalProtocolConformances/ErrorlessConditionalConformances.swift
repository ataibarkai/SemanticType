//
//  File.swift
//  
//
//  Created by Atai Barkai on 9/6/19.
//

import Foundation
import XCTest
@testable import SemanticType

final class SemanticType_ConditioinalProtocolConformances_ErrorlessConditionalConformancesTests: XCTestCase {
    
    func testAdditiveArithmeticConformance() {
        enum Seconds_Spec: ErrorlessSemanticTypeSpec {

            static func gateway(preMap: Double) -> Double {
                return preMap
            }
            
        }
    }
    
    static var allTests = [
        ("testAdditiveArithmeticConformance", testAdditiveArithmeticConformance),
    ]

}
