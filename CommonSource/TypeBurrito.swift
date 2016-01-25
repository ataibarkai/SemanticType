//
//  TypeBurrito.swift
//  TypeBurrito
//
//  Created by Atai Barkai on 1/11/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation

/**
A protocol to be adopted by types that specify and describe a TypeBurrito.

e.g.:

```
enum _Kgs: TypeBurritoSpec { typealias TheTypeInsideTheBurrito = Double }
typealias Kgs = TypeBurrito<_Kgs>

let _ = Kgs(234.2)

```
*/
public protocol TypeBurritoSpec {
	typealias TheTypeInsideTheBurrito: Comparable, CustomStringConvertible, Hashable
}

public struct TypeBurrito <Spec: TypeBurritoSpec>: Comparable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
	
	// The variable we use to store the value.
	// It is read/write (for instance so we can implement += and -=),
	// but it is *internal*, meaning inaccesible for users of the framework.
	internal var value: Spec.TheTypeInsideTheBurrito
	
	// This is a read-only field which is declared *public*,
	// meaning it is accessible to users of the framework.
	// It allows users to get ahold of the stored primitive inside the TypeBurrito
	public var primitiveValueInside: Spec.TheTypeInsideTheBurrito {
		return self.value
	}
	
	public init(_ value: Spec.TheTypeInsideTheBurrito){
		self.value = (value)
	}
	
	// CustomStringConvertible compliance
	public var description: String {
		return self.value.description
	}
	
	// CustomDebugStringConvertible compliance
	public var debugDescription: String {
		return "(\(self.dynamicType)): \(self.value)"
	}
	
	// Hashable compliance
	public var hashValue: Int {
		return self.value.hashValue
	}

}


// Comparable compliance
public func  == <Spec: TypeBurritoSpec>
	(left: TypeBurrito<Spec>, right: TypeBurrito<Spec>) -> Bool {
	return left.value == right.value
}
public func < <Spec: TypeBurritoSpec>
	(left: TypeBurrito<Spec>, right: TypeBurrito<Spec>) -> Bool {
		return left.value < right.value
}


