//
//  FailableTypeBurrito-Numbers.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 2/2/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation


// Addition for appropriate TypeBurrito types
public func + <Spec where Spec.TheTypeInsideTheBurrito: SummableSubtractable>
	(left: FailableTypeBurrito<Spec>, right: FailableTypeBurrito<Spec>) -> FailableTypeBurrito<Spec>? {
		return FailableTypeBurrito<Spec>.init((left.value + right.value))
}

// Subtraction for appropriate TypeBurrito types
public func - <Spec where Spec.TheTypeInsideTheBurrito: SummableSubtractable>
	(left: FailableTypeBurrito<Spec>, right: FailableTypeBurrito<Spec>) -> FailableTypeBurrito<Spec>? {
		return FailableTypeBurrito<Spec>.init((left.value - right.value))
}