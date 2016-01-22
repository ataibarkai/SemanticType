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


enum _FavoriteFood: TypeBurritoSpec {
	typealias TheTypeInsideTheBurrito = String
}
typealias FavoriteFood = TypeBurrito<_FavoriteFood>




class TypeBurrito_Hashing: XCTestCase {
	
	func testDictionaryHashing() {
		
		var favoriteFoodMap = [NameOfPerson : FavoriteFood]()
		
		let personName1 = NameOfPerson("George Costanza")
		let food1 = FavoriteFood("Calzone")
		
		let personName2 = NameOfPerson("Jerry Seinfeld")
		let food2 = FavoriteFood("Pickino's Pizza")
		
		let personName3 = NameOfPerson("Elaine Benes")
		let food3 = FavoriteFood("(pro-choice) Duck")
		
		favoriteFoodMap[personName1] = food1
		favoriteFoodMap[personName2] = food2
		favoriteFoodMap[personName3] = food3
		
		XCTAssertEqual(favoriteFoodMap[personName1], food1)
		XCTAssertEqual(favoriteFoodMap[personName2], food2)
		XCTAssertEqual(favoriteFoodMap[personName3], food3)
		

	}
	
	
}

