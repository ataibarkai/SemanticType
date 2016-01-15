//
//  TypeBurrito.swift
//  TypeBurrito
//
//  Created by Atai Barkai on 1/11/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation

public protocol TypeBurrito: Comparable, CustomStringConvertible, CustomDebugStringConvertible, Hashable {
	
	typealias UnderlyingValueType: Comparable, CustomStringConvertible, Hashable
	
	/// The value wrapped by this TypeBurrito subtype
	var value: UnderlyingValueType {get set}
	init()
}


// Providing the default constructor
public extension TypeBurrito {
	init(_ value: UnderlyingValueType){
		self.init()
		self.value = value
	}
}

// Comparable compliance
public func == <T where T: TypeBurrito> (x: T, y: T) -> Bool {
	return
			(x.dynamicType == y.dynamicType) && // To be equal, types must be invariant, not covariant
			(x.value == y.value)
}

public func < <T where T: TypeBurrito> (x: T, y:T) -> Bool {
	return x.value < y.value
}

// CustomStringConvertible compliance
public extension TypeBurrito {
	var description: String {
		return self.value.description
	}
}

// CustomDebugStringConvertible compliance
public extension TypeBurrito {
	var debugDescription: String {
		return "(\(self.dynamicType)): \(self.value)"
	}
}

// Hashable compliance
public extension TypeBurrito {
	var hashValue: Int {
		return self.value.hashValue
	}
}





