//
//  SemanticTypeSpec.swift
//  
//
//  Created by Atai Barkai on 8/2/19.
//

public protocol SemanticTypeSpec {
    
    /// The backing primitive must possess *value semantics* to insure that its structure is not modified by outside forces
    /// after passing through the `gatewayMap` function and becoming stored inside of a `SemanticType` object.
    associatedtype BackingPrimitiveWithValueSemantics
    associatedtype Error: Swift.Error
    
    /// - Tag: SemanticTypeSpec.gatewayMap
    static func gatewayMap(
       preMap: BackingPrimitiveWithValueSemantics
    ) -> Result<BackingPrimitiveWithValueSemantics, Error>
}


// This extension provides the **identiy** map as the default gatewayMap implementation
// for error-less semantic types.
 extension SemanticTypeSpec where Error == Never {
    public static func gatewayMap(
        preMap: BackingPrimitiveWithValueSemantics
    ) -> Result<BackingPrimitiveWithValueSemantics, Error> {
        return .success(preMap)
    }
}
