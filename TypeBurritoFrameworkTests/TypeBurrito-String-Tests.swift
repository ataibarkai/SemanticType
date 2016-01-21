//
//  TypeBurrito-String-Tests.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 1/12/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TypeBurritoFramework





class TypeBurrito_String_Tests: XCTestCase {
	
	class _Name: TypeBurritoSpec {
		typealias TheTypeInsideTheBurrito = String
	}
	typealias Name = TypeBurrito<_Name>
	
	
	
	class _Hometown: TypeBurritoSpec {
		typealias TheTypeInsideTheBurrito = String
	}
	typealias Hometown = TypeBurrito<_Hometown>
	
	class _SQLQuery: TypeBurritoSpec {
		typealias TheTypeInsideTheBurrito = String
	}
	typealias SQLQuery = TypeBurrito<_SQLQuery>
	
	
	
	struct Person {
		var name: Name
		var hometown: Hometown
	}
	
	class _FavoriteShow: TypeBurritoSpec {
		typealias TheTypeInsideTheBurrito = String
	}
	typealias FavoriteShow = TypeBurrito<_FavoriteShow>
	
	
	class _Username: TypeBurritoSpec {
		typealias TheTypeInsideTheBurrito = String
	}
	typealias Username = TypeBurrito<_Username>

	
	
	func testTypeBurritoStringCreation() {
		
		let joe = Username("joe")
		let eric = Username("eric")
		XCTAssertEqual(joe.value, "joe")
		XCTAssertEqual(eric.value, "eric")
		
		let drWhoString = "Doctor Who"
		let drWho = FavoriteShow(drWhoString)
		let breakingBad = FavoriteShow("Breaking Bad")
		XCTAssertEqual(drWho.value, drWhoString)
		XCTAssertEqual(breakingBad.value, "Breaking Bad")
	}
	
	func testTypeBurritoStringComparison(){
		let joeString = "joe"
		let joe1 = Username(joeString)
		let joe2 = Username(joeString)
		let eric = Username("eric")
		XCTAssertEqual(joe1, joe2)
		XCTAssertNotEqual(joe1, eric)
		
		let drWhoString = "Doctor Who"
		let drWho1 = FavoriteShow(drWhoString)
		let drWho2 = FavoriteShow(drWhoString)
		let breakingBad = FavoriteShow("Breaking Bad")
		XCTAssertEqual(drWho1, drWho2)
		XCTAssertNotEqual(drWho1, breakingBad)
		
		
		let a = Username("a")
		let b = Username("b")
		XCTAssertLessThan(a, b)
		XCTAssertGreaterThan(b, a)

		
		// The below should give a compile time error
		//		XCTAssertNotEqual(joe1, drWho1)
	}
		
	
	func testTypeBurritoStringCompilation() {
		
		func bookCharactersSqlQuery(forHometown hometown: Hometown) -> SQLQuery{
			return SQLQuery("SELECT * FROM BookCharacters WHERE Name = \(hometown);")
		}
		
		func findPersonsByPerformingSQLQuery(sqlQuery: SQLQuery) -> [Person]{
			// perform sql query...
			return [Person(name: Name("Lazas Long"), hometown: Hometown("Basoom"))]
		}
		
		let results = findPersonsByPerformingSQLQuery(bookCharactersSqlQuery(forHometown: Hometown("Basoom")))
		XCTAssert(results.count == 1)
	}


}


