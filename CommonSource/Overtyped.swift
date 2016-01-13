//
//  GenericIsh.swift
//  TCimb
//
//  Created by Atai Barkai on 1/11/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation

/**

The `Overtyped` Protocol
========================

Purpose
-------
`Overtyped` is a protocol that enables the quick creation of types that wrap other types --
thereby increasing code safety and clarity.

Examples
--------

For `String`-containing `Overtyped` types:

	struct Name: Overtyped {
		var value: String = ""
	}

	struct SQLQuery: Overtyped {
		var value: String = ""
	}

	...

	func bookCharactersSqlQuery(forName name: Name) -> SQLQuery { ... }
	func findPersonsByPerformingSQLQuery(sqlQuery: SQLQuery) -> [Person] { ... }
	
For `SummableSubtractable`-containing `Overtyped` types:

	struct Kg: Overtyped{
		var value: Double = 0
	}

	struct Meters: Overtyped{
		var value: Double = 0
	}

	struct BMI: Overtyped {
		var value: Double = 0
	}
	
	func bmi(forMass mass: Kg, andHeight height: Meters) -> BMI { ... }


Details
-------

Types that conform to `Overtyped` can be used in a wide range of standard usecases,
intuitively reflecting their wrapped value's behavior:
* comparison (`<`, `==`)
* printing (`CustomStringConvertible`)
* as dictionary keys (using hashing)
* during debugging (`CustomDebugStringConvertible`)
* etc.

There is also built-in extended support for Overtyped sub-types that wrap a value of type
`String` or a value of type `SummableSubtractable`

*/
public protocol Overtyped: Comparable, CustomStringConvertible, CustomDebugStringConvertible, Hashable {
	
	typealias UnderlyingValueType: Comparable, CustomStringConvertible, Hashable
	
	var value: UnderlyingValueType {get set}
	init()
}



// Providing the default constructor
public extension Overtyped {
	init(_ value: UnderlyingValueType){
		self.init()
		self.value = value
	}
}

// Comparable compliance
public func == <T where T: Overtyped> (x: T, y: T) -> Bool {
	return
			(x.dynamicType == y.dynamicType) && // To be equal, types must be invariant, not covariant
			(x.value == y.value)
}

public func < <T where T: Overtyped> (x: T, y:T) -> Bool {
	return x.value < y.value
}

// CustomStringConvertible compliance
public extension Overtyped {
	var description: String {
		return self.value.description
	}
}

// CustomDebugStringConvertible compliance
public extension Overtyped {
	var debugDescription: String {
		return "(\(self.dynamicType)): \(self.value)"
	}
}

// Hashable compliance
public extension Overtyped {
	var hashValue: Int {
		return self.value.hashValue
	}
}





