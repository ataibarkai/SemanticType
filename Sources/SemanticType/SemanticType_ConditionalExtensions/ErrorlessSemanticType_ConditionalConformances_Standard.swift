extension SemanticType: AdditiveArithmetic
    where
    Spec.RawValue: AdditiveArithmetic,
    Spec.Error == Never
{
    public static var zero: Self {
        return Self(Spec.RawValue.zero)
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
    Spec.RawValue: Strideable,
    Spec.Error == Never
{
    public typealias Stride = Spec.RawValue.Stride
    
    public func distance(to other: SemanticType<Spec>) -> Spec.RawValue.Stride {
        return backingPrimitive.distance(to: other.backingPrimitive)
    }
    
    public func advanced(by n: Spec.RawValue.Stride) -> SemanticType<Spec> {
        return SemanticType.init(
            backingPrimitive.advanced(by: n)
        )
    }

}

extension SemanticType: MutableCollection
    where
    Spec.RawValue: MutableCollection,
    Spec.Error == Never
{
    public subscript(position: Spec.RawValue.Index) -> Spec.RawValue.Element {
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
    Spec.RawValue: RangeReplaceableCollection,
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

