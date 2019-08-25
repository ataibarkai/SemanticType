//
//  SemanticType+usabilityExtensions.swift
//  
//
//  Created by Atai Barkai on 8/8/19.
//

// MARK: - Universal usability extensions -
extension SemanticType {
    public init(_ preMap: Spec.BackingPrimitiveWithValueSemantics) throws {
        self = try Self.create(preMap).get()
    }
    
    public var backingPrimitive: Spec.BackingPrimitiveWithValueSemantics {
        get {
            _backingPrimitiveProxy
        }
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Spec.BackingPrimitiveWithValueSemantics, T>) -> T {
        get {
            backingPrimitive[keyPath: keyPath]
        }
    }
    
    public func tryMap(
        _ map: (_ backingPrimitive: Spec.BackingPrimitiveWithValueSemantics) throws -> Spec.BackingPrimitiveWithValueSemantics
    ) rethrows -> Result<Self, Spec.Error> {
        return Self.create(
            try map(backingPrimitive)
        )
    }
    
    public mutating func mutatingTryMap(
        _ mutation: (_ backingPrimitive: inout Spec.BackingPrimitiveWithValueSemantics) throws -> ()
    ) throws {
        let mapped = try tryMap { original in
            var toBeModified = original
            try mutation(&toBeModified) // Here we make use of the assumption that `Spec.BackingPrimitiveWithValueSemantics` has
                                        // value-semantics, i.e. that this mutation of `backingPrimitiveCopy` would bear no
                                        // effect on the original `backingPrimitive`.
            return toBeModified
        }
        
        self = try mapped.get()
    }
}


// MARK: - `Error == Never` extensions -
extension SemanticType where Spec.Error == Never {
    public init(_ preMap: Spec.BackingPrimitiveWithValueSemantics) {
        self = Self.create(preMap).get()
    }
    
    /// The value assigned to `backingPrimitive` is passed through the `Spec.gatewayMap` function before making it to `self`.
    public var backingPrimitive: Spec.BackingPrimitiveWithValueSemantics {
        get {
            _backingPrimitiveProxy
        }
        set {
            self = .init(newValue)
        }
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Spec.BackingPrimitiveWithValueSemantics, T>) -> T {
        get {
            backingPrimitive[keyPath: keyPath]
        }
        set {
            backingPrimitive[keyPath: keyPath] = newValue
        }
    }
    
    public func map(
        _ map: (_ backingPrimitive: Spec.BackingPrimitiveWithValueSemantics) throws -> Spec.BackingPrimitiveWithValueSemantics
    ) rethrows -> Self {
        return Self.init(
            try map(backingPrimitive)
        )
    }
    
    public mutating func mutatingMap(
        _ mutation: (_ backingPrimitive: inout Spec.BackingPrimitiveWithValueSemantics) throws -> ()
    ) rethrows {
        let mapped = try map { original in
            var toBeModified = original
            try mutation(&toBeModified) // Here we make use of the assumption that `Spec.BackingPrimitiveWithValueSemantics` has
                                        // value-semantics, i.e. that this mutation of `backingPrimitiveCopy` would bear no
                                        // effect on the original `backingPrimitive`.
            return toBeModified
        }
        
        self = mapped
    }
    
}


// Declared `internal` so that it's available for tests as well.
internal extension Result where Failure == Never {
    
    /// A variant of `Result.get()` specific to error-less `Result` instances
    /// -- which is therefore statically guarenteed to never `throw`.
    ///
    /// - Returns: The `Success` value wrapped by this error-less `Result` instance
    func get() -> Success {
        switch self {
        case .success(let success):
            return success
        case .failure(let never):
            switch never { }
        }
    }
}
