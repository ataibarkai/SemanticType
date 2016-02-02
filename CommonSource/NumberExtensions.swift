//
//  NumberExtensions.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 2/2/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation

public protocol SummableSubtractable{
	func +(lhs: Self, rhs: Self) -> Self
	func -(lhs: Self, rhs: Self) -> Self
}

extension Int: SummableSubtractable {}
extension Int8: SummableSubtractable {}
extension Int16: SummableSubtractable {}
extension Int32: SummableSubtractable {}
extension Int64: SummableSubtractable {}
extension UInt: SummableSubtractable {}
extension UInt8: SummableSubtractable {}
extension UInt16: SummableSubtractable {}
extension UInt32: SummableSubtractable {}
extension UInt64: SummableSubtractable {}
extension Float: SummableSubtractable {}
extension Double: SummableSubtractable {}
