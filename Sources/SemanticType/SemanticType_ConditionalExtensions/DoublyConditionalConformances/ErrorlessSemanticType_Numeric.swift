/// A marker protocol to be conformed to by a `SemanticTypeSpec` type
/// to conditionally provide `Numeric` support for its associated `SemanticType`.
///
/// If a `SemanticTypeSpec` conforms to this protocol, its associated `SemanticType`
/// will conform to `Numeric`.
public protocol ShouldBeNumeric: GeneralizedSemanticTypeSpec
    where
    BackingPrimitiveWithValueSemantics: Numeric { }

extension SemanticType: Numeric
    where
    Spec: ShouldBeNumeric,  // `Numeric` support may not make sense for all
                            // `SemanticType`s associated with a `Numeric` `BackingPrimitiveWithValueSemantics`
                            // (for instance, [`Second` * `Second` = `Second`] does not make semantic sense).
                            // Nevertheless, we *can* provide an implementation in all such cases.
                            //
                            // We allow the `Spec` backing the `SemanticType` to signal whether `Numeric`
                            // support should be provided by conforming to the `ShouldBeNumeric` marker protocol.
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
    Spec: ShouldBeNumeric,
    Spec.BackingPrimitiveWithValueSemantics: SignedNumeric,
    Spec.Error == Never
{ }

