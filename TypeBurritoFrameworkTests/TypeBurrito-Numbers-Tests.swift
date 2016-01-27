//
//  TypeBurrito-Numbers-Tests.swift
//  TypeBurrito
//
//  Created by Atai Barkai on 1/13/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TypeBurritoFramework



class TypeBurrito_Numbers_Tests: XCTestCase {
	enum _Kg: TypeBurritoSpec {	typealias TheTypeInsideTheBurrito = Double }
	typealias Kg = TypeBurrito<_Kg>
	
	
	enum _Meters: TypeBurritoSpec {	typealias TheTypeInsideTheBurrito = Double }
	typealias Meters = TypeBurrito<_Meters>
	
	enum _Steps: TypeBurritoSpec{ typealias TheTypeInsideTheBurrito = Int }
	typealias Steps = TypeBurrito<_Steps>
	
	
	enum _DoubleWrapper: TypeBurritoSpec{ typealias TheTypeInsideTheBurrito = Double }
	typealias DoubleWrapper = TypeBurrito<_DoubleWrapper>
	
	enum _FloatWrapper: TypeBurritoSpec{ typealias TheTypeInsideTheBurrito = Float }
	typealias FloatWrapper = TypeBurrito<_FloatWrapper>
	
	
	enum _IntWrapper: TypeBurritoSpec{ typealias TheTypeInsideTheBurrito = Int }
	typealias IntWrapper = TypeBurrito<_IntWrapper>
	
	
	enum _MusicVolume: TypeBurritoSpec{
		typealias TheTypeInsideTheBurrito = Double
		
		// we want MusicVolume to only be between 0 and 100
		static func gatewayMap(preMap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito{
			switch preMap{
			case (-Double.infinity)..<0:
				return 0
			case 100..<(Double.infinity):
				return 100
			default:
				return preMap
			}
		}
	}
	typealias MusicVolume = TypeBurrito<_MusicVolume>
	
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
	
	func testModifyingAdditionSubtraction() {
		var stepsTraveled = Steps(0)
		var stepsRemaining = Steps(100)
		
		while (stepsRemaining > Steps(0) ){
			let travellingNow = Steps(1)
			
			stepsTraveled += travellingNow
			stepsRemaining -= travellingNow
		}
		
		XCTAssertEqual(stepsTraveled, Steps(100))
	}
	
	func testGatewayMap() {
		
		let minimumVolume = MusicVolume(0)
		let maximumVolume = MusicVolume(100)
		
		let belowMinimum_1 = MusicVolume(-101)
		let belowMinimum_2 = MusicVolume(-1873487.01)
		XCTAssertEqual(belowMinimum_1, minimumVolume)
		XCTAssertEqual(belowMinimum_2, minimumVolume)
		
		let withinRange_1 = MusicVolume(33.56)
		let withinRange_2 = MusicVolume(28.366)
		XCTAssertEqual(withinRange_1.primitiveValueInside, 33.56)
		XCTAssertEqual(withinRange_2.primitiveValueInside, 28.366)
		
		let aboveMaximum_1 = MusicVolume(101)
		let aboveMaximum_2 = MusicVolume(2344723.3101)
		XCTAssertEqual(aboveMaximum_1, maximumVolume)
		XCTAssertEqual(aboveMaximum_2, maximumVolume)
		
	}
	
}

