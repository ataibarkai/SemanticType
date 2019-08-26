//
//  SemanticType.swift
//  
//
//  Created by Atai Barkai on 8/2/19.
//

// A very thin, easily-verifiable core for `SemanticType`,
// exposing a single, maximally-typed (`Result`-returning) factory method.
@dynamicMemberLookup
public struct SemanticType<Spec: GeneralizedSemanticTypeSpec> {
    
    public typealias Spec = Spec
    internal typealias GatewayMapOutput = (
        backingPrimitvie: Spec.BackingPrimitiveWithValueSemantics,
        metadata: Spec.GatewayMetadataWithValueSemantics
    )
    
    /// The (stored) primitive value backing this instance of `SemanticType`.
    /// Guarenteed to have been outputted by `Spec.gatewayMap` for some given input.
    ///
    ///
    /// This stored property is declared `private` to prevent any creation/initialization of a `SemanticType` instance other than
    /// through the creation path explicitly exposed by this file (namely, the [create](x-source-tag://create) factory method).
    ///
    /// Furthermore, since this property is the *only* property stored on instances of `SemanticType`,
    /// and since it is stored as a constant (i.e. as a `let`), the data underlying a `SemanticType` instance
    /// can in no way be modified post-initialization.
    /// This makes it easy to verify that `SemanticType` respects the `Spec.gatewayMap` function
    /// by examining the code in this file *in isolation from code in any other file*:
    /// as long as we make sure this property is always assigned a post-`Spec.gatewayMap` value
    /// *in the context of this file*, we can be sure that it is assigned a post-`Spec.gatewayMap` value
    /// under *all* circumstances.
    private let _storedBackingPrimitive: GatewayMapOutput
    
    /// A proxy internally exposing the `_storedBackingPrimitive` property to other files in this package.
    ///
    /// Being a *computed* property, the value exposition *does not* also make it possible
    /// to define any initializers circumventing the [create](x-source-tag://create) factory method.
    internal var _backingPrimitiveProxy: GatewayMapOutput { _storedBackingPrimitive }
    
    // MARK: init / factories
    /// An unsafe initializer intended to be used only from within the [create](x-source-tag://create) factory method.
    ///
    /// This initializer **does not** make sure that the `Spec.gatemapMap` function is being respected.
    /// Thus, the *caller* must be sure to call this initializer with a value outputted by the `Spec.gatemapMap` function.
    /// - Parameter _unsafeDirectlyAssignedBackingPrimitive: The `Spec.BackingPrimitive` object directly assigned to self.
    ///                                                      Must have been the output of a `Spec.gatewayMap` call.
    private init(_unsafeDirectlyAssignedBackingPrimitive: GatewayMapOutput) {
        self._storedBackingPrimitive = _unsafeDirectlyAssignedBackingPrimitive
    }
    
    /// The only way to create an instance of `SemanticType`.
    /// An obtained `SemanticType` is guarenteed to respect its `Spec.gatewayMap` function, in that
    /// its backing primitive is guarenteed to have been the output of a call to `Spec.gatewayMap`.
    ///
    /// - Parameter preMap: The value to be passed through the `Spec.gatemapMap` function.
    ///
    /// - Returns: A `SemanticType` instance wrapping the `.success` output of the `Sepc.gatewayMap` function,
    ///            or otherwise, the error captured by a `.failure` output of the `Sepc.gatewayMap` function.
    ///
    /// - Tag: create
    public static func create(_ preMap: Spec.BackingPrimitiveWithValueSemantics) -> Result<Self, Spec.Error> {
        return Spec
            .gatewayMap(preMap: preMap)
            .map(Self.init(_unsafeDirectlyAssignedBackingPrimitive:))
    }
}

