//
//  NeverErrorConformances.swift
//
//
//  Created by Atai Barkai on 8/2/19.
//

// Conditional protocol conformances applicable to `SemanticType`s which
// may be created without the possibility of error (i.e. where `Spec.Error == Never`):

extension SemanticType: AdditiveArithmetic
    where
    Spec.BackingPrimitiveWithValueSemantics: AdditiveArithmetic,
    Spec.Error == Never
{
    public static var zero: Self {
        return Self(Spec.BackingPrimitiveWithValueSemantics.zero)
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.backingPrimitive + rhs.backingPrimitive)
    }
    public static func += (lhs: inout Self, rhs: Self) {
        lhs.backingPrimitive += rhs.backingPrimitive
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.backingPrimitive - rhs.backingPrimitive)
    }
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.backingPrimitive -= rhs.backingPrimitive
    }
}

extension SemanticType: Numeric
    where
    Spec.BackingPrimitiveWithValueSemantics: Numeric,
    Spec.Error == Never
{
    public typealias Magnitude = Spec.BackingPrimitiveWithValueSemantics.Magnitude

    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let inside = Spec.BackingPrimitiveWithValueSemantics.init(exactly: source)
            else { return nil }
        
        self.init(inside)
    }
    
    public var magnitude: Spec.BackingPrimitiveWithValueSemantics.Magnitude {
        backingPrimitive.magnitude
    }
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(lhs.backingPrimitive * rhs.backingPrimitive)
    }
    
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs.backingPrimitive *= rhs.backingPrimitive
    }
}

extension SemanticType: SignedNumeric
    where
    Spec.BackingPrimitiveWithValueSemantics: SignedNumeric,
    Spec.Error == Never
{ }

extension SemanticType: MutableCollection
    where
    Spec.BackingPrimitiveWithValueSemantics: MutableCollection,
    Spec.Error == Never
{
    public subscript(position: Spec.BackingPrimitiveWithValueSemantics.Index) -> Spec.BackingPrimitiveWithValueSemantics.Element {
        get {
            return backingPrimitive[position]
        }
        set {
            backingPrimitive[position] = newValue
        }
    }
    
}

extension SemanticType: RangeReplaceableCollection
    where
    Spec.BackingPrimitiveWithValueSemantics: RangeReplaceableCollection,
    Spec.Error == Never
{
    public init() {
        self.init(
            .init()
        )
    }
    
    public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C)
        where
        C : Collection,
        R : RangeExpression,
        Element == C.Element,
        Index == R.Bound
    {
        backingPrimitive.replaceSubrange(subrange, with: newElements)
    }
}


extension SemanticType: ExpressibleByIntegerLiteral
    where
    Spec.BackingPrimitiveWithValueSemantics: ExpressibleByIntegerLiteral,
    Spec.Error == Never
{
    public typealias IntegerLiteralType = Spec.BackingPrimitiveWithValueSemantics.IntegerLiteralType
    
    public init(integerLiteral value: Self.IntegerLiteralType) {
        self.init(
            .init(integerLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByFloatLiteral
    where
    Spec.BackingPrimitiveWithValueSemantics: ExpressibleByFloatLiteral,
    Spec.Error == Never
{
    public typealias FloatLiteralType = Spec.BackingPrimitiveWithValueSemantics.FloatLiteralType
   
    public init(floatLiteral value: Self.FloatLiteralType) {
        self.init(
            .init(floatLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByUnicodeScalarLiteral
    where
    Spec.BackingPrimitiveWithValueSemantics: ExpressibleByUnicodeScalarLiteral,
    Spec.Error == Never
{
    public typealias UnicodeScalarLiteralType = Spec.BackingPrimitiveWithValueSemantics.UnicodeScalarLiteralType
    
    public init(unicodeScalarLiteral value: Self.UnicodeScalarLiteralType) {
        self.init(
            .init(unicodeScalarLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByExtendedGraphemeClusterLiteral
    where
    Spec.BackingPrimitiveWithValueSemantics: ExpressibleByExtendedGraphemeClusterLiteral,
    Spec.Error == Never
{
    public typealias ExtendedGraphemeClusterLiteralType = Spec.BackingPrimitiveWithValueSemantics.ExtendedGraphemeClusterLiteralType
    
    public init(extendedGraphemeClusterLiteral value: Self.ExtendedGraphemeClusterLiteralType) {
        self.init(
            .init(extendedGraphemeClusterLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByStringLiteral
    where
    Spec.BackingPrimitiveWithValueSemantics: ExpressibleByStringLiteral,
    Spec.Error == Never
{
    public typealias StringLiteralType = Spec.BackingPrimitiveWithValueSemantics.StringLiteralType
    
    public init(stringLiteral value: Self.StringLiteralType) {
        self.init(
            .init(stringLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByBooleanLiteral
    where
    Spec.BackingPrimitiveWithValueSemantics: ExpressibleByBooleanLiteral,
    Spec.Error == Never
{
    public typealias BooleanLiteralType = Spec.BackingPrimitiveWithValueSemantics.BooleanLiteralType

  public init(booleanLiteral value: Self.BooleanLiteralType) {
    self.init(
        .init(booleanLiteral: value)
    )
  }
}
