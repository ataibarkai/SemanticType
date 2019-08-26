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
    associatedtype GatewayMetadataWithValueSemantics
    associatedtype Error: Swift.Error
    
    typealias GatewayOutput = (
        backingPrimitvie: BackingPrimitiveWithValueSemantics,
        metadata: GatewayMetadataWithValueSemantics
    )
    
    /// - Tag: SemanticTypeSpec.gateway
    static func gateway(
       preMap: BackingPrimitiveWithValueSemantics
    ) -> Result<GatewayOutput, Error>
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
        return gateway(preMap: preMap).map { ($0, ()) }
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
