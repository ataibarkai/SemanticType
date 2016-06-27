//
//  FailableTypeBurrito-Numbers-Tests.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 6/26/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TypeBurritoFramework

class FailableTypeBurrito_Numbers_Tests: XCTestCase {
    
    enum _DoubleWrapperBetween0And100: FailableTypeBurritoSpec {
        typealias TheTypeInsideTheBurrito = Double
        
        static func gatewayMap(premap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito? {
            return (0...100 ~= premap) ? premap : nil
        }
    }
    typealias DoubleWrapperBetween0And100 = FailableTypeBurrito<_DoubleWrapperBetween0And100>
    
    
    func testCreation() {
        
        // test succesful createion of failable type burritos
        let validCandidate1 = DoubleWrapperBetween0And100(3)
        let validCandidate2 = DoubleWrapperBetween0And100(83)
        let validCandidate3 = DoubleWrapperBetween0And100(0)
        let validCandidate4 = DoubleWrapperBetween0And100(100)
        
        XCTAssertNotNil(validCandidate1)
        XCTAssertNotNil(validCandidate2)
        XCTAssertNotNil(validCandidate3)
        XCTAssertNotNil(validCandidate4)
        

        // test unsuccesful createion of failable type burritos
        let invalidCandidate1 = DoubleWrapperBetween0And100(-3)
        let invalidCandidate2 = DoubleWrapperBetween0And100(-83)
        let invalidCandidate3 = DoubleWrapperBetween0And100(-1)
        let invalidCandidate4 = DoubleWrapperBetween0And100(101)
        
        XCTAssertNil(invalidCandidate1)
        XCTAssertNil(invalidCandidate2)
        XCTAssertNil(invalidCandidate3)
        XCTAssertNil(invalidCandidate4)
    }
    
    func testAdditionSubtraction() {
        
        let num1_Double: Double = 0.34353
        let num2_Double: Double = 93.324324
        let num1_DoubleWrapped = DoubleWrapperBetween0And100(num1_Double)!
        let num2_DoubleWrapped = DoubleWrapperBetween0And100(num2_Double)!
        
        XCTAssertEqual(
            (num2_DoubleWrapped - num1_DoubleWrapped)!.value,
            num2_Double - num1_Double
        )
        XCTAssertEqual(
            (num2_DoubleWrapped + num1_DoubleWrapped)!.value,
            num2_Double + num1_Double
        )
        XCTAssertNotEqual(
            (num2_DoubleWrapped + num1_DoubleWrapped)!.value,
            num2_Double + num1_Double + 0.001
        )
    }
    
    func testMultiplicationDivision() {
        
        let num1_Double: Double = 0.34353
        let num2_Double: Double = 93.324324
        let num1_DoubleWrapped = DoubleWrapperBetween0And100(num1_Double)!
        let num2_DoubleWrapped = DoubleWrapperBetween0And100(num2_Double)!
        
        XCTAssertEqual(
            (num2_DoubleWrapped * num1_DoubleWrapped)!.value,
            num2_Double * num1_Double
        )
        XCTAssertEqual(
            (num1_DoubleWrapped / num2_DoubleWrapped)!.value,
            num1_Double / num2_Double
        )
        XCTAssertNotEqual(
            (num1_DoubleWrapped / num2_DoubleWrapped)!.value,
            num1_Double / num2_Double - 0.001
        )
    }
    
}
