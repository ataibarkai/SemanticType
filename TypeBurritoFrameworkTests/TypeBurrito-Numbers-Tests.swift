//
//  TypeBurrito-Numbers-Tests.swift
//  TypeBurrito
//
//  Created by Atai Barkai on 1/13/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TypeBurritoFramework


enum _Kg: TypeBurritoSpec {
	typealias TheTypeInsideTheBurrito = Double
}
typealias Kg = TypeBurrito<_Kg>


enum _Meters: TypeBurritoSpec {
	typealias TheTypeInsideTheBurrito = Double
}
typealias Meters = TypeBurrito<_Meters>


enum _DoubleWrapper: TypeBurritoSpec{
	typealias TheTypeInsideTheBurrito = Double
}
typealias DoubleWrapper = TypeBurrito<_DoubleWrapper>

enum _FloatWrapper: TypeBurritoSpec{
	typealias TheTypeInsideTheBurrito = Float
}
typealias FloatWrapper = TypeBurrito<_FloatWrapper>


enum _IntWrapper: TypeBurritoSpec{
	typealias TheTypeInsideTheBurrito = Int
}
typealias IntWrapper = TypeBurrito<_IntWrapper>



class TypeBurrito_Numbers_Tests: XCTestCase {
	
	func testCreation() {
		
		let myMass = Kg(87.4)
		let myHeight = Meters(1.87)
		
		XCTAssertEqual(myMass.value, 87.4)
		XCTAssertEqual(myHeight.value, 1.87)
	}
	
	func testAdditionSubtraction() {
		
		let num1_Double: Double = 3432.343
		let num2_Double: Double = 234.5
		let num1_DoubleWrapped = DoubleWrapper(num1_Double)
		let num2_DoubleWrapped = DoubleWrapper(num2_Double)
		XCTAssertEqual(
			(num2_DoubleWrapped-num1_DoubleWrapped).value,
			num2_Double-num1_Double
		)
		
		let num1_Float: Float = 3432.343
		let num2_Float: Float = 234.5
		let num1_FloatWrapped = FloatWrapper(num1_Float)
		let num2_FloatWrapped = FloatWrapper(num2_Float)
		XCTAssertEqual(
			(num2_FloatWrapped-num1_FloatWrapped).value,
			num2_Float-num1_Float
		)
		
		let num1_Int: Int = 42
		let num2_Int: Int = 293
		let num1_IntWrapped = IntWrapper(num1_Int)
		let num2_IntWrapped = IntWrapper(num2_Int)
		XCTAssertEqual(
			(num2_IntWrapped-num1_IntWrapped).value,
			num2_Int-num1_Int
		)
		
		// the following should produce compile-time errors:
//		let anImpossibility = Kg(284) + Meters(34)
//		if (Kg(34) < Meters(35)) { }
	}
	
}

