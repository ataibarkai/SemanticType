//
//  FailableTypeBurrito-Hashing-Tests.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 6/26/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TypeBurritoFramework

enum _FailableNameOfPerson: FailableTypeBurritoSpec {
    typealias TheTypeInsideTheBurrito = String
    
    static func gatewayMap(premap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito? {
        return premap
    }
}
typealias FailableNameOfPerson = FailableTypeBurrito<_FailableNameOfPerson>

class FailableTypeBurrito_Hashing_Tests: XCTestCase {
    
    
    func testDictionaryHashing() {
        
        var favoriteFoodMap = [FailableNameOfPerson : Food]()
        
        let personName1 = FailableNameOfPerson("George Costanza")!
        let food1 = Food("Calzone")
        
        let personName2 = FailableNameOfPerson("Jerry Seinfeld")!
        let food2 = Food("Pickino's Pizza")
        
        let personName3 = FailableNameOfPerson("Elaine Benes")!
        let food3 = Food("(pro-choice) Duck")
        
        favoriteFoodMap[personName1] = food1
        favoriteFoodMap[personName2] = food2
        favoriteFoodMap[personName3] = food3
        
        XCTAssertEqual(favoriteFoodMap[personName1], food1)
        XCTAssertEqual(favoriteFoodMap[personName2], food2)
        XCTAssertEqual(favoriteFoodMap[personName3], food3)
        XCTAssertNotEqual(favoriteFoodMap[personName1], food3)
        
    }
    
}
