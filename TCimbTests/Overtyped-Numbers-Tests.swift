//
//  Overtyped-Numbers-Tests.swift
//  TCimb
//
//  Created by Atai Barkai on 1/13/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TCimb

struct Kg: Overtyped{
	var value: Double = 0
}

struct Meters: Overtyped{
	var value: Double = 0
}


class Overtyped_Numbers_Tests: XCTestCase {
	
	func testNumberOvertypesCreation() {
		
		let myMass = Kg(87.4)
		let myHeight = Meters(1.87)
		
		XCTAssertEqual(myMass.value, 87.4)
		XCTAssertEqual(myHeight.value, 1.87)
	}

}
