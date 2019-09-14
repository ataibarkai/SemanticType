/// A specification object statically determining the properties of a `SemanticType` object
/// associated with it.
public protocol GeneralizedSemanticTypeSpec {
    
    /// The type of the primitive value wrapped by the `SemanticType`.
    ///
    /// The backing primitive must possess *value semantics* to insure that the structure of a value is
    /// not modified by outside forces after passing through the `SemanticType`'s `gateway` function
    /// and becoming stored inside of a `SemanticType` instance.
    associatedtype BackingPrimitiveWithValueSemantics
    
    /// The type of the gateway-associated metadata available on the `SemanticType`.
    ///
    /// The metadata must possess *value semantics* to ensure that the structure of a value is
    /// not modified by outside forces after passing through the `SemanticType`'s `gateway` function
    /// and becoming stored inside of a `SemanticType` instance.
    ///
    /// ---
    ///
    /// The metadata value is stored on the `SemanticType` instance and is publically available for access.
    /// It may be used to encode a compiler-accessible fascet of the sub-structure of the wrapped value
    /// which was veriried by the `gatewayMap` function.
    ///
    /// As an example: suppose we create a `NonEmptyArray` `SemanticType`, i.e.
    /// a type whose instances wrap an `Array` -- but which could only be created when said `Array` is non-empty.
    /// Unlike instances of `Array`, instances of `NonEmptyArray` are **guarenteed** to have `first` and `last` elements.
    /// Thus we may expose `first: Element` and `last: Element` in place of `Array`'s corresponding *optional* properties.
    /// Since we know that instances of `NonEmptyArray` are not empty, we _could_ implement said non-optionoal
    /// `first` and `last` overrides by forwarding the call to `Array`'s optional properties and force-unwrapping the result.
    /// While *we* know this process ought to work, the *compiler* does not -- hence the need for the force-unwrapping.
    /// And so we lose the celebrated compiler verification normally characterizing idiomatic swift code.
    /// Instead, we could implement `first` and `last` without circumventing compiler verifications by storing the `Array`'s `first` and `last`
    /// values as *metadata* during the `gatewayMap`ing (where we could return an error if `first` and `last` are not available).
    /// Then the non-optional `first` and `last` properties could be implemented by querying said metadata values.
    associatedtype GatewayMetadataWithValueSemantics
    
    /// The type of the error which could be returned when attempting to create instance of the `SemanticType`.
    associatedtype Error: Swift.Error
    
    /// The output of the [gatewayMap function](x-source-tag://SemanticTypeSpec.gateway).
    /// See additional documentation on the [struct definition](x-source-tag://GeneralizedSemanticTypeSpec_GatewayOutput)
    ///
    /// - Tag: GeneralizedSemanticTypeSpec.GatewayOutput
    typealias GatewayOutput = GeneralizedSemanticTypeSpec_GatewayOutput<BackingPrimitiveWithValueSemantics, GatewayMetadataWithValueSemantics>
    
    /// A function gating the creation of all `SemanticType` instances associated with this Spec.
    ///
    /// - Parameter preMap: The primitive value to be analyzed and modified for association with a `SemanticType` instance.
    /// - Returns: If a `SemanticType` instance should be created given the provided input, returns the backing primitive
    /// - Tag: SemanticTypeSpec.gateway
    static func gateway(
       preMap: BackingPrimitiveWithValueSemantics
    ) -> Result<GatewayOutput, Error>
}
/// The output of the [gatewayMap function](x-source-tag://SemanticTypeSpec.gateway).
///
///
/// NOTE: Since Swift does not currently support nesting definitions of types nested inside a protocol,
/// we utilize a naming convention + [a typealias on the target protocol](x-source-tag://GeneralizedSemanticTypeSpec.GatewayOutput)
/// to effectively achieve this goal.
/// In other words, this type should be viewed as if it were nested under the `GeneralizedSemanticTypeSpec` protocol.
///
/// - Tag: GeneralizedSemanticTypeSpec_GatewayOutput
public struct GeneralizedSemanticTypeSpec_GatewayOutput<BackingPrimitiveWithValueSemantics, GatewayMetadataWithValueSemantics> {
    
    /// The primitive value to back a succesfully-created `SemanticType` instance.
    /// The behavior of the `SemanticType` manifestation largely revolves around this type
    /// (see [SemanticType](x-source-tag://SemanticType)).
    var backingPrimitvie: BackingPrimitiveWithValueSemantics
    
    /// Additinoal metadata object available to the successfully-created `SemanticType` instance.
    /// May be utilized to provide compiler-verified extensions on the SemanticType, taking advantage of the
    /// constraints satisfied by the distilled primitive.
    var metadata: GatewayMetadataWithValueSemantics
}


/// A `SemanticTypeSpec` with no gateway metadata.
public protocol SemanticTypeSpec: GeneralizedSemanticTypeSpec where GatewayMetadataWithValueSemantics == () {
    static func gateway(
       preMap: BackingPrimitiveWithValueSemantics
    ) -> Result<BackingPrimitiveWithValueSemantics, Error>
}
extension SemanticTypeSpec {
    public static func gateway(
       preMap: BackingPrimitiveWithValueSemantics
    ) -> Result<GatewayOutput, Error> {
        return gateway(preMap: preMap)
            .map { .init(backingPrimitvie: $0, metadata: ()) }
    }
}

/// A `SemanticTypeSpec` whose `gateway` function never errors.
public protocol ErrorlessSemanticTypeSpec: SemanticTypeSpec where Error == Never {
    static func gateway(
       preMap: BackingPrimitiveWithValueSemantics
    ) -> BackingPrimitiveWithValueSemantics
}
extension ErrorlessSemanticTypeSpec {
    public static func gateway(
       preMap: BackingPrimitiveWithValueSemantics
    ) -> Result<BackingPrimitiveWithValueSemantics, Error> {
        return .success(gateway(preMap: preMap))
    }
}
