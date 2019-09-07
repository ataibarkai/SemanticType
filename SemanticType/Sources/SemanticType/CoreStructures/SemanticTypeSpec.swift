//
//  SemanticTypeSpec.swift
//  
//
//  Created by Atai Barkai on 8/2/19.
//

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
    
    associatedtype Error: Swift.Error
    
    typealias GatewayOutput = GeneralizedSemanticTypeSpec_GatewayOutput<BackingPrimitiveWithValueSemantics, GatewayMetadataWithValueSemantics>
    
    /// - Tag: SemanticTypeSpec.gateway
    static func gateway(
       preMap: BackingPrimitiveWithValueSemantics
    ) -> Result<GatewayOutput, Error>
}
public struct GeneralizedSemanticTypeSpec_GatewayOutput<BackingPrimitiveWithValueSemantics, GatewayMetadataWithValueSemantics> {
    var backingPrimitvie: BackingPrimitiveWithValueSemantics
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
