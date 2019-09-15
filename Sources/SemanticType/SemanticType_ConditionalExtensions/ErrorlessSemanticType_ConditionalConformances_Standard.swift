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

extension SemanticType: Strideable
    where
    Spec.BackingPrimitiveWithValueSemantics: Strideable,
    Spec.Error == Never
{
    public typealias Stride = Spec.BackingPrimitiveWithValueSemantics.Stride
    
    public func distance(to other: SemanticType<Spec>) -> Spec.BackingPrimitiveWithValueSemantics.Stride {
        return backingPrimitive.distance(to: other.backingPrimitive)
    }
    
    public func advanced(by n: Spec.BackingPrimitiveWithValueSemantics.Stride) -> SemanticType<Spec> {
        return SemanticType.init(
            backingPrimitive.advanced(by: n)
        )
    }

}

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

