//
//  Overtyped-GeneralUsecases-Tests.swift
//  OvertypedFramework
//
//  Created by Atai Barkai on 1/13/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import OvertypedFramework

struct LowercaseUsername: Overtyped{
	private var _value = ""
	var value: String{
		get{
			return _value
		}
		set(newValue) {
			self._value = newValue.lowercaseString
		}
	}
}

class Overtyped_GeneralUsecases_Tests: XCTestCase {
	
	func testOvertypedValueMapping() {
		
		let lowercaseJoe = LowercaseUsername("joe")
		let uppercaseJoe = LowercaseUsername("Joe")
		
		XCTAssertEqual(lowercaseJoe, uppercaseJoe)
	}

}
