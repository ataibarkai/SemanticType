extension SemanticType: CustomStringConvertible where Spec.RawValue: CustomStringConvertible {
    public var description: String {
        return rawValue.description
    }
}

extension SemanticType: CustomDebugStringConvertible where Spec.RawValue: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(type(of: self))): \(rawValue.debugDescription)"
    }
}


extension SemanticType: CustomPlaygroundDisplayConvertible where Spec.RawValue: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return rawValue.playgroundDescription
    }
}

extension SemanticType: Hashable where Spec.RawValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        rawValue.hash(into: &hasher)
    }
}

extension SemanticType: Equatable where Spec.RawValue: Equatable {
    public static func == (left: Self, right: Self) -> Bool {
        return left.rawValue == right.rawValue
    }
}

extension SemanticType: Comparable where Spec.RawValue: Comparable {
    public static func < (left: Self, right: Self) -> Bool {
        return left.rawValue < right.rawValue
    }
}

extension SemanticType: Error where Spec.RawValue: Error { }

// MARK: List-Like Protocols
extension SemanticType: Sequence where Spec.RawValue: Sequence {
    public typealias Element = Spec.RawValue.Element
    public typealias Iterator = Spec.RawValue.Iterator
    
    public func makeIterator() -> Spec.RawValue.Iterator {
        return rawValue.makeIterator()
    }
}

extension SemanticType: Collection where Spec.RawValue: Collection {
    public typealias Index = Spec.RawValue.Index

    public subscript(position: Spec.RawValue.Index) -> Spec.RawValue.Element {
        return rawValue[position]
    }
    
    public var startIndex: Spec.RawValue.Index {
        return rawValue.startIndex
    }
    
    public var endIndex: Spec.RawValue.Index {
        return rawValue.endIndex
    }
    
    public func index(after i: Spec.RawValue.Index) -> Spec.RawValue.Index {
        return rawValue.index(after: i)
    }
}

extension SemanticType: BidirectionalCollection where Spec.RawValue: BidirectionalCollection {
    public func index(before i: Spec.RawValue.Index) -> Spec.RawValue.Index {
        return rawValue.index(before: i)
    }
}

extension SemanticType: RandomAccessCollection where Spec.RawValue: RandomAccessCollection { }


// MARK: `Codable`
extension SemanticType: Encodable where Spec.RawValue: Encodable {
  public func encode(to encoder: Encoder) throws {
    try rawValue.encode(to: encoder)
  }
}

extension SemanticType: Decodable where Spec.RawValue: Decodable {
  public init(from decoder: Decoder) throws {
    try self.init(
        try .init(from: decoder)
    )
  }
}
