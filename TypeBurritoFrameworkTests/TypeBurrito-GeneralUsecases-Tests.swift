//
//  TypeBurrito-GeneralUsecases-Tests.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 1/13/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TypeBurritoFramework

struct LowercaseUsername: TypeBurrito{
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

class TypeBurrito_GeneralUsecases_Tests: XCTestCase {
	
	func testTypeBurritoValueMapping() {
		
		let lowercaseJoe = LowercaseUsername("joe")
		let uppercaseJoe = LowercaseUsername("Joe")
		
		XCTAssertEqual(lowercaseJoe, uppercaseJoe)
	}

}
