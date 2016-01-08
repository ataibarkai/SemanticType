//
//  Stringish.swift
//  T-CIMB
//
//  Created by Atai Barkai on 1/6/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation

public protocol Stringish: Comparable, CustomStringConvertible, CustomDebugStringConvertible, Hashable{
	var value: String {get set}
	init()
}

// Providing the default constructor
extension Stringish {
	init(_ value: String){
		self.init()
		self.value = value
	}
}

// Comparable compliance
func == <T where T: Stringish> (x: T, y: T) -> Bool {
	return
		(x.dynamicType == y.dynamicType) && // To be equal, types must be invariant, not covariant
		(x.value == y.value)
}
func < <T where T: Stringish> (x: T, y:T) -> Bool {
	return x.value < y.value
}

// CustomStringConvertible compliance
extension Stringish {
	var description: String {
		return self.value
	}
}

// CustomDebugStringConvertible compliance
extension Stringish {
	var debugDescription: String {
		return "(\(self.dynamicType)): \(self.value)"
	}
}

// Hashable compliance
extension Stringish {
	var hashValue: Int {
		return self.value.hash
	}
}


