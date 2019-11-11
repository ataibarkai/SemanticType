
// NOTE: Even when `SemanticType` is itself non-numeric,
// it makes sense to multiply a `SemanticType` instance by an instance of its backing primitive when possible.
extension SemanticType
    where
    Spec.RawValue: Numeric,
    Spec.Error == Never
{
    public static func * (lhs: Self, rhs: Self.Spec.RawValue) -> Self {
        return Self(lhs.backingPrimitive * rhs)
    }

    public static func * (lhs: Self.Spec.RawValue, rhs: Self) -> Self {
        Self(lhs * rhs.backingPrimitive)
    }

    public static func *= (lhs: inout Self, rhs: Self.Spec.RawValue) {
        lhs.backingPrimitive *= rhs
    }
}
