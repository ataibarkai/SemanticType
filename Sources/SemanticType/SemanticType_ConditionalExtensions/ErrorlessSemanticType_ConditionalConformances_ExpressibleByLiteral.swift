extension SemanticType: ExpressibleByIntegerLiteral
    where
    Spec.RawValue: ExpressibleByIntegerLiteral,
    Spec.Error == Never
{
    public typealias IntegerLiteralType = Spec.RawValue.IntegerLiteralType
    
    public init(integerLiteral value: Self.IntegerLiteralType) {
        self.init(
            .init(integerLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByFloatLiteral
    where
    Spec.RawValue: ExpressibleByFloatLiteral,
    Spec.Error == Never
{
    public typealias FloatLiteralType = Spec.RawValue.FloatLiteralType
   
    public init(floatLiteral value: Self.FloatLiteralType) {
        self.init(
            .init(floatLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByUnicodeScalarLiteral
    where
    Spec.RawValue: ExpressibleByUnicodeScalarLiteral,
    Spec.Error == Never
{
    public typealias UnicodeScalarLiteralType = Spec.RawValue.UnicodeScalarLiteralType
    
    public init(unicodeScalarLiteral value: Self.UnicodeScalarLiteralType) {
        self.init(
            .init(unicodeScalarLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByExtendedGraphemeClusterLiteral
    where
    Spec.RawValue: ExpressibleByExtendedGraphemeClusterLiteral,
    Spec.Error == Never
{
    public typealias ExtendedGraphemeClusterLiteralType = Spec.RawValue.ExtendedGraphemeClusterLiteralType
    
    public init(extendedGraphemeClusterLiteral value: Self.ExtendedGraphemeClusterLiteralType) {
        self.init(
            .init(extendedGraphemeClusterLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByStringLiteral
    where
    Spec.RawValue: ExpressibleByStringLiteral,
    Spec.Error == Never
{
    public typealias StringLiteralType = Spec.RawValue.StringLiteralType
    
    public init(stringLiteral value: Self.StringLiteralType) {
        self.init(
            .init(stringLiteral: value)
        )
    }
}

extension SemanticType: ExpressibleByBooleanLiteral
    where
    Spec.RawValue: ExpressibleByBooleanLiteral,
    Spec.Error == Never
{
    public typealias BooleanLiteralType = Spec.RawValue.BooleanLiteralType

  public init(booleanLiteral value: Self.BooleanLiteralType) {
    self.init(
        .init(booleanLiteral: value)
    )
  }
}
