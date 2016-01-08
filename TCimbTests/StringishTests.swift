//
//  StringishTests.swift
//  TCIMB
//
//  Created by Atai Barkai on 1/6/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TCimb

struct Username: Stringish{ var value: String = "" }
struct FavoriteShow: Stringish{ var value: String = "Unspecified" }


class StringishTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStringishCreation() {
		
		let joe = Username("joe")
		let eric = Username("eric")
		let emptyUser = Username()

		let drWhoString = "Doctor Who"
		let drWho = FavoriteShow(drWhoString)
		let breakingBad = FavoriteShow("Breaking Bad")
		let emptyShow = FavoriteShow()
		
		
		XCTAssertEqual(joe.value, "joe")
		XCTAssertEqual(eric.value, "eric")
		XCTAssertEqual(emptyUser.value, "")
		
		XCTAssertEqual(drWho.value, drWhoString)
		XCTAssertEqual(breakingBad.value, "Breaking Bad")
		XCTAssertEqual(emptyShow.value, "Unspecified")
    }
	
	func testStringishComparison(){
		let joeString = "joe"
		let joe1 = Username(joeString)
		let joe2 = Username(joeString)
		let eric = Username("eric")
		let emptyUser1 = Username()
		let emptyUser2 = Username()
		
		let drWhoString = "Doctor Who"
		let drWho1 = FavoriteShow(drWhoString)
		let drWho2 = FavoriteShow(drWhoString)
		let breakingBad = FavoriteShow("Breaking Bad")
		let emptyShow1 = FavoriteShow()
		let emptyShow2 = FavoriteShow()
		
		
		XCTAssertEqual(joe1, joe2)
		XCTAssertNotEqual(joe1, eric)
		XCTAssertNotEqual(joe1, emptyUser1)
		XCTAssertEqual(emptyUser1, emptyUser2)
		
		XCTAssertEqual(drWho1, drWho2)
		XCTAssertNotEqual(drWho1, breakingBad)
		XCTAssertNotEqual(drWho1, emptyShow1)
		XCTAssertEqual(emptyShow1, emptyShow2)
		
		// The below should give a compile time error
//		XCTAssertNotEqual(joe1, drWho1)

	}
	

}
