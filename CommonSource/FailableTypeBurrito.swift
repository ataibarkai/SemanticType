//
//  FailableTypeBurrito.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 2/2/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation

public protocol FailableTypeBurritoSpec {
	typealias TheTypeInsideTheBurrito: Comparable, CustomStringConvertible, Hashable
	
	static func gatewayMap(preMap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito?
}




public struct FailableTypeBurrito <Spec: FailableTypeBurritoSpec>: Comparable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
	
	// The variable we use to store the value.
	// It is private and should NOT (and cannot) be accessed directly.
	// Instead it should be accessed through the value var
	private var _value: Spec.TheTypeInsideTheBurrito
	
	// The variable we use to access the value.
	// It is read/write (for instance so we can implement += and -=),
	// but it is *internal*, meaning inaccesible for users of the framework.
	internal var value: Spec.TheTypeInsideTheBurrito{
		get {
			return _value
		}
	}
	
	// This is a read-only field which is declared *public*,
	// meaning it is accessible to users of the framework.
	// It allows users to get ahold of the stored primitive inside the TypeBurrito
	public var primitiveValueInside: Spec.TheTypeInsideTheBurrito {
		return self.value
	}
	
	public init?(_ value: Spec.TheTypeInsideTheBurrito){
		
		if let mappedValue = Spec.gatewayMap(value){
			self._value = mappedValue
		}
		else{
			return nil
		}
		
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
public func  == <Spec: FailableTypeBurritoSpec>
	(left: FailableTypeBurrito<Spec>, right: FailableTypeBurrito<Spec>) -> Bool {
		return left.value == right.value
}
public func < <Spec: FailableTypeBurritoSpec>
	(left: FailableTypeBurrito<Spec>, right: FailableTypeBurrito<Spec>) -> Bool {
		return left.value < right.value
}
