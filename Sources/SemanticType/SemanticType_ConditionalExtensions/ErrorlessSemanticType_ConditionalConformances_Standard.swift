extension SemanticType: AdditiveArithmetic
    where
    Spec.RawValue: AdditiveArithmetic,
    Spec.Error == Never
{
    public static var zero: Self {
        return Self(Spec.RawValue.zero)
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.rawValue + rhs.rawValue)
    }
    public static func += (lhs: inout Self, rhs: Self) {
        lhs.rawValue += rhs.rawValue
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.rawValue - rhs.rawValue)
    }
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.rawValue -= rhs.rawValue
    }
}

extension SemanticType: Strideable
    where
    Spec.RawValue: Strideable,
    Spec.Error == Never
{
    public typealias Stride = Spec.RawValue.Stride
    
    public func distance(to other: SemanticType<Spec>) -> Spec.RawValue.Stride {
        return rawValue.distance(to: other.rawValue)
    }
    
    public func advanced(by n: Spec.RawValue.Stride) -> SemanticType<Spec> {
        return SemanticType.init(
            rawValue.advanced(by: n)
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
            return rawValue[position]
        }
        set {
            rawValue[position] = newValue
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
        rawValue.replaceSubrange(subrange, with: newElements)
    }
}

