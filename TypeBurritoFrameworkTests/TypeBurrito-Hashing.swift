//
//  TypeBurrito-Hashing.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 1/13/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
import Foundation
@testable import TypeBurritoFramework


enum _NameOfPerson: TypeBurritoSpec {
	typealias TheTypeInsideTheBurrito = String
}
typealias NameOfPerson = TypeBurrito<_NameOfPerson>


enum _Food: TypeBurritoSpec {
	typealias TheTypeInsideTheBurrito = String
}
typealias Food = TypeBurrito<_Food>




class TypeBurrito_Hashing: XCTestCase {
	
	func testDictionaryHashing() {
		
		var favoriteFoodMap = [NameOfPerson : Food]()
		
		let personName1 = NameOfPerson("George Costanza")
		let food1 = Food("Calzone")
		
		let personName2 = NameOfPerson("Jerry Seinfeld")
		let food2 = Food("Pickino's Pizza")
		
		let personName3 = NameOfPerson("Elaine Benes")
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

