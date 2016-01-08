//
//  Doublish.swift
//  T-CIMB
//
//  Created by Atai Barkai on 1/6/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation


public protocol Doublish: Comparable, CustomStringConvertible, Hashable /*, FloatingPointType */ {
	var value: Double {get set}
	init()
}


// Providing the default constructor
public extension Doublish {
	init(_ value: Double){
		self.init()
		self.value = value
	}
}

// Comparable compliance
public func == <T where T: Doublish> (x: T, y: T) -> Bool {
	return (x.value == y.value)
}
public func < <T where T: Doublish> (x: T, y:T) -> Bool {
	return x.value < y.value
}


// CustomStringConvertible compliance
public extension Doublish {
	var description: String {
		return self.value.description
	}
}


// Hashable compliance
public extension Doublish {
	var hashValue: Int {
		return self.value.hashValue
	}
}


// Addition
public func +<T where T: Doublish>(left: T, right: T) -> T {
	return T.init((left.value + right.value))
}

// Subtract
public func -<T where T: Doublish>(left: T, right: T) -> T {
	return T.init((left.value - right.value))
}



/*

// Stridable compliance
extension Doublish {
	typealias Stride = Double
	
	func advancedBy(n: Double) -> Self{
		return Self.init(self.value.advancedBy(n))
	}
	
	func distanceTo(other: Self) -> Double{
		return self.value.distanceTo(other.value)
	}

}

// FloatingPointType compliance
extension Doublish {
	
	// initializers
	init(_ value: Int) {
		self.init(Double(value))
	}
	init(_ value: Int8) {
		self.init(Double(value))
	}
	init(_ value: Int16) {
		self.init(Double(value))
	}
	init(_ value: Int32) {
		self.init(Double(value))
	}
	init(_ value: Int64) {
		self.init(Double(value))
	}
	init(_ value: UInt) {
		self.init(Double(value))
	}
	init(_ value: UInt8) {
		self.init(Double(value))
	}
	init(_ value: UInt16) {
		self.init(Double(value))
	}
	init(_ value: UInt32) {
		self.init(Double(value))
	}
	init(_ value: UInt64) {
		self.init(Double(value))
	}

	// static variables
	static var NaN: Self{
		return self.init(Double.NaN)
	}
	static var infinity: Self{
		return self.init(Double.infinity)
	}
	static var quietNaN: Self{
		return self.init(Double.quietNaN)
	}
	
	// instance variables
	var floatingPointClass: FloatingPointClassification {
		return self.value.floatingPointClass
	}
	var isFinite: Bool{
		return self.value.isFinite
	}
	var isInfinite: Bool{
		return self.value.isInfinite
	}
	var isNaN: Bool{
		return self.value.isNaN
	}
	var isNormal: Bool{
		return self.value.isNormal
	}
	var isSignMinus: Bool{
		return self.value.isSignMinus
	}
	var isSignaling: Bool{
		return self.value.isSignaling
	}
	var isSubnormal: Bool{
		return self.value.isSubnormal
	}
	var isZero: Bool{
		return self.value.isZero
	}
}

*/
