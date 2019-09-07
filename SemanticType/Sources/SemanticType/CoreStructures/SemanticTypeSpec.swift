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
    
    /// The type of the creation-associated metadata available on the `SemanticType`.
    ///
    /// The metadata must possess *value semantics* to insure that the structure of a value is
    /// not modified by outside forces after passing through the `SemanticType`'s `gateway` function
    /// and becoming stored inside of a `SemanticType` instance.
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
