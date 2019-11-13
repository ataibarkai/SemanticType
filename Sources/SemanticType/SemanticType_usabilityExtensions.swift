// MARK: - Universal usability extensions -
extension SemanticType {
    public init(_ preMap: Spec.RawValue) throws {
        self = try Self.create(preMap).get()
    }
    
    public var rawValue: Spec.RawValue {
        get {
            _rawValue
        }
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Spec.RawValue, T>) -> T {
        get {
            rawValue[keyPath: keyPath]
        }
    }
    
    public func tryMap(
        _ map: (_ rawValue: Spec.RawValue) throws -> Spec.RawValue
    ) rethrows -> Result<Self, Spec.Error> {
        return Self.create(
            try map(rawValue)
        )
    }
    
    public mutating func mutatingTryMap(
        _ mutation: (_ rawValue: inout Spec.RawValue) throws -> ()
    ) throws {
        let mapped = try tryMap { original in
            var toBeModified = original
            try mutation(&toBeModified) // Here we make use of the assumption that `Spec.RawValue` has
                                        // value-semantics, i.e. that this mutation of `toBeModified: Spec.RawValue` would bear no
                                        // effect on `original: Spec.RawValue`.
            return toBeModified
        }
        
        self = try mapped.get()
    }
}


// MARK: - `Error == Never` extensions -
extension SemanticType where Spec.Error == Never {
    public init(_ preMap: Spec.RawValue) {
        self = Self.create(preMap).get()
    }
    
    /// The value assigned to `rawValue` is passed through the `Spec.gateway` function before making it to `self`.
    public var rawValue: Spec.RawValue {
        get {
            _rawValue
        }
        set {
            self = .init(newValue)
        }
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Spec.RawValue, T>) -> T {
        get {
            rawValue[keyPath: keyPath]
        }
        set {
            rawValue[keyPath: keyPath] = newValue
        }
    }
    
    public func map(
        _ map: (_ rawValue: Spec.RawValue) throws -> Spec.RawValue
    ) rethrows -> Self {
        return Self.init(
            try map(rawValue)
        )
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
