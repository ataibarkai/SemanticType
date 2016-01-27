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
	
	// A String-bound TypeBurrito
	enum _TvShow: TypeBurritoSpec {	typealias TheTypeInsideTheBurrito = String }
	typealias TvShow = TypeBurrito<_TvShow>
	
	// A String-bound TypeBurrito
	enum _Username: TypeBurritoSpec { typealias TheTypeInsideTheBurrito = String }
	typealias Username = TypeBurrito<_Username>
	
	enum _CaseInsensitiveUsername: TypeBurritoSpec {
		typealias TheTypeInsideTheBurrito = String
		
		static func gatewayMap(preMap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito{
			return preMap.lowercaseString
		}
	}
	typealias CaseInsensitiveUsername = TypeBurrito<_CaseInsensitiveUsername>
		
	func testCreation() {
		let joe = Username("joe")
		let eric = Username("eric")
		
		// make sure the value is saved internally as expected
		XCTAssertEqual(joe.value, "joe")
		XCTAssertEqual(eric.value, "eric")
		XCTAssertNotEqual(joe.value, eric.value)
	}
	
	func testComparison(){
		
		// test equality:
		let joeString = "joe"
		let joe1 = Username(joeString)
		let joe2 = Username(joeString)
		let eric = Username("eric")
		XCTAssertEqual(joe1, joe2)
		XCTAssertNotEqual(joe1, eric)
		
		// test comparison:
		let aShow = TvShow("a")
		let bShow = TvShow("b")
		let cShow = TvShow("c")
		XCTAssertLessThan(aShow, bShow)
		XCTAssertGreaterThan(cShow, bShow)

		// The below should give a compile time error
//		XCTAssertNotEqual(joe1, aShow)
	}
	
	func testGatewayMap() {
		
		let lowercaseJoe = CaseInsensitiveUsername("joe")
		let uppercaseJoe = CaseInsensitiveUsername("JOE")
		
		XCTAssertEqual(lowercaseJoe, uppercaseJoe)
	}
	
	func testTypeComposition() {
		
		// create a struct which uses TypeBurrito's as fields
		struct NetflixUser {
			let username: Username
			let favoriteShow: TvShow
			
			init(_ username: Username, _ favoriteShow: TvShow){
				self.username = username
				self.favoriteShow = favoriteShow
			}
			
			init(withUsername username: Username){
				
				// a function from a TypeBurrito to a TypeBurrito
				func makeUpTvShow(forUsername username: Username) -> TvShow{
					return TvShow("The Sweet Life of \(username)")
				}
				
				self.username = username
				self.favoriteShow = makeUpTvShow(forUsername: username)
			}
		}

		
		let walterWhiteNetflixUser = NetflixUser(withUsername: Username("Walter.White"))
		let walterWhiteExpectedNetflixUser = NetflixUser(
			Username("Walter.White"),
			TvShow("The Sweet Life of Walter.White")
		)
		
		XCTAssertEqual(walterWhiteNetflixUser.username, walterWhiteExpectedNetflixUser.username)
		XCTAssertEqual(walterWhiteNetflixUser.favoriteShow, walterWhiteExpectedNetflixUser.favoriteShow)
			
	}


}


