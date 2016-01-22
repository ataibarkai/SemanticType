//
//  TypeBurrito.swift
//  TypeBurrito
//
//  Created by Atai Barkai on 1/11/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation

public protocol TypeBurritoSpec {
	typealias TheTypeInsideTheBurrito: Comparable, CustomStringConvertible, Hashable
}

public struct TypeBurrito <Spec: TypeBurritoSpec>: Comparable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
	
	public var value: Spec.TheTypeInsideTheBurrito
	
	public init(_ value: Spec.TheTypeInsideTheBurrito){
		self.value = value
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


