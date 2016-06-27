//
//  FailableTypeBurrito-Numbers.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 2/2/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

// -----------------------------
// SummableSubtractable extensions
// -----------------------------

public func + <Spec where Spec.TheTypeInsideTheBurrito: SummableSubtractable>
	(left: FailableTypeBurrito<Spec>, right: FailableTypeBurrito<Spec>) -> FailableTypeBurrito<Spec>? {
		return FailableTypeBurrito<Spec>.init((left.value + right.value))
}

public func - <Spec where Spec.TheTypeInsideTheBurrito: SummableSubtractable>
	(left: FailableTypeBurrito<Spec>, right: FailableTypeBurrito<Spec>) -> FailableTypeBurrito<Spec>? {
		return FailableTypeBurrito<Spec>.init((left.value - right.value))
}


// -----------------------------
// MultipliableDivisible extensions
// -----------------------------

public func * <Spec where Spec.TheTypeInsideTheBurrito: MultipliableDivisible>
	(left: FailableTypeBurrito<Spec>, right: FailableTypeBurrito<Spec>) -> FailableTypeBurrito<Spec>? {
	return FailableTypeBurrito<Spec>.init((left.value * right.value))
}

public func / <Spec where Spec.TheTypeInsideTheBurrito: MultipliableDivisible>
	(left: FailableTypeBurrito<Spec>, right: FailableTypeBurrito<Spec>) -> FailableTypeBurrito<Spec>? {
	return FailableTypeBurrito<Spec>.init((left.value / right.value))
}
