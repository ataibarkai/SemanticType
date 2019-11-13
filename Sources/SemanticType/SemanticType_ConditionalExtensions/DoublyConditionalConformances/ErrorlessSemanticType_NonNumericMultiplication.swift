/// A marker protocol.
/// If a `SemanticTypeSpec` conforms to this protocol, its associated `SemanticType`
/// will support multiplication/division operations with instances of its `RawValue` type.
/// Also see [ShouldBeNumeric](x-source-tag://ShouldBeNumeric).
///
/// `Numeric` support may not make sense for all
/// `SemanticType`s associated with a `Numeric` `RawValue`
/// (for instance, [`Second` * `Second` = `Second`] does not make semantic sense).
/// Nevertheless, we *can* provide an implementation in all such cases.
///
/// We allow the `Spec` backing the `SemanticType` to signal whether `Numeric`
/// support should be provided by conforming to the `ShouldBeNumeric` marker protocol.
/// - Tag: SupportsMultiplicationWithRawValue
public protocol SupportsMultiplicationWithRawValue: MetaValidatedSemanticTypeSpec
    where
    RawValue: Numeric { }

// NOTE: Even when `SemanticType` is itself non-numeric,
// it makes sense to multiply a `SemanticType` instance by an instance of its `RawValue` when possible.
extension SemanticType
    where
    Spec: SupportsMultiplicationWithRawValue,
    Spec.Error == Never
{
    public static func * (lhs: Self, rhs: Self.Spec.RawValue) -> Self {
        return Self(lhs.rawValue * rhs)
    }

    public static func * (lhs: Self.Spec.RawValue, rhs: Self) -> Self {
        Self(lhs * rhs.rawValue)
    }

    public static func *= (lhs: inout Self, rhs: Self.Spec.RawValue) {
        lhs.rawValue *= rhs
    }
}
