//
//  Doublish.swift
//  T-CIMB
//
//  Created by Atai Barkai on 1/6/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation

// Addition for appropriate TypeBurrito types
public func + <Spec where Spec.TheTypeInsideTheBurrito: SummableSubtractable>
	(left: TypeBurrito<Spec>, right: TypeBurrito<Spec>) -> TypeBurrito<Spec> {
	return TypeBurrito<Spec>.init((left.value + right.value))
}

// Subtraction for appropriate TypeBurrito types
public func - <Spec where Spec.TheTypeInsideTheBurrito: SummableSubtractable>
	(left: TypeBurrito<Spec>, right: TypeBurrito<Spec>) -> TypeBurrito<Spec> {
		return TypeBurrito<Spec>.init((left.value - right.value))
}

public func += <Spec where Spec.TheTypeInsideTheBurrito: SummableSubtractable>
	(inout left: TypeBurrito<Spec>, right: TypeBurrito<Spec>) {
		left.value = (left.value + right.value)
}

public func -= <Spec where Spec.TheTypeInsideTheBurrito: SummableSubtractable>
	(inout left: TypeBurrito<Spec>, right: TypeBurrito<Spec>) {
		left.value = (left.value - right.value)
}

//extension TypeBurrito where Spec.TheTypeInsideTheBurrito: SummableSubtractable{}


