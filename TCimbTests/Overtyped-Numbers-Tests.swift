//
//  Overtyped-Numbers-Tests.swift
//  Overtyped
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


struct DoubleWrapper: Overtyped{
	var value: Double = 0
}

struct FloatWrapper: Overtyped{
	var value: Float = 0
}

struct IntWrapper: Overtyped {
	var value: Int = 0
}


class Overtyped_Numbers_Tests: XCTestCase {
	
	
	
	func testNumberOvertypesCreation() {
		
		let myMass = Kg(87.4)
		let myHeight = Meters(1.87)
		
		XCTAssertEqual(myMass.value, 87.4)
		XCTAssertEqual(myHeight.value, 1.87)
	}
	
	func testNumberOvertypesAdditionSubtraction() {
		
		let num1_Double: Double = 3432.343
		let num2_Double: Double = 234.5
		let num1_DoubleWrapped = DoubleWrapper(num1_Double)
		let num2_DoubleWrapped = DoubleWrapper(num2_Double)
		XCTAssertEqual((num2_DoubleWrapped-num1_DoubleWrapped).value, num2_Double-num1_Double)
		
		
		let num1_Float: Float = 3432.343
		let num2_Float: Float = 234.5
		let num1_FloatWrapped = FloatWrapper(num1_Float)
		let num2_FloatWrapped = FloatWrapper(num2_Float)
		XCTAssertEqual((num2_FloatWrapped-num1_FloatWrapped).value, num2_Float-num1_Float)
		
		
	}
	
}
