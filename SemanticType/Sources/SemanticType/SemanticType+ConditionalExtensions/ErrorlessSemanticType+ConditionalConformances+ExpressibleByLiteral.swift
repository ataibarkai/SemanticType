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
