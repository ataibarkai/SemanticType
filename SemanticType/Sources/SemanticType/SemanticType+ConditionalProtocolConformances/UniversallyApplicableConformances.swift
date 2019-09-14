//
//  UniversallyApplicableConformances.swift
//
//
//  Created by Atai Barkai on 8/2/19.
//

// Conditional protocol conformances applicable to all `SemanticType`s:

extension SemanticType: CustomStringConvertible where Spec.BackingPrimitiveWithValueSemantics: CustomStringConvertible {
    public var description: String {
        return backingPrimitive.description
    }
}

extension SemanticType: CustomDebugStringConvertible where Spec.BackingPrimitiveWithValueSemantics: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(type(of: self))): \(backingPrimitive.debugDescription)"
    }
}

extension SemanticType: Hashable where Spec.BackingPrimitiveWithValueSemantics: Hashable {
    public func hash(into hasher: inout Hasher) {
        backingPrimitive.hash(into: &hasher)
    }
}

extension SemanticType: Equatable where Spec.BackingPrimitiveWithValueSemantics: Equatable {
    public static func == (left: Self, right: Self) -> Bool {
        return left.backingPrimitive == right.backingPrimitive
    }
}

extension SemanticType: Comparable where Spec.BackingPrimitiveWithValueSemantics: Comparable {
    public static func < (left: Self, right: Self) -> Bool {
        return left.backingPrimitive < right.backingPrimitive
    }
}

extension SemanticType: Error where Spec.BackingPrimitiveWithValueSemantics: Error { }

extension SemanticType: Sequence where Spec.BackingPrimitiveWithValueSemantics: Sequence {
    public typealias Element = Spec.BackingPrimitiveWithValueSemantics.Element
    public typealias Iterator = Spec.BackingPrimitiveWithValueSemantics.Iterator
    
    public func makeIterator() -> Spec.BackingPrimitiveWithValueSemantics.Iterator {
        return backingPrimitive.makeIterator()
    }
}

extension SemanticType: Collection where Spec.BackingPrimitiveWithValueSemantics: Collection {
    public typealias Index = Spec.BackingPrimitiveWithValueSemantics.Index

    public subscript(position: Spec.BackingPrimitiveWithValueSemantics.Index) -> Spec.BackingPrimitiveWithValueSemantics.Element {
        return backingPrimitive[position]
    }
    
    public var startIndex: Spec.BackingPrimitiveWithValueSemantics.Index {
        return backingPrimitive.startIndex
    }
    
    public var endIndex: Spec.BackingPrimitiveWithValueSemantics.Index {
        return backingPrimitive.endIndex
    }
    
    public func index(after i: Spec.BackingPrimitiveWithValueSemantics.Index) -> Spec.BackingPrimitiveWithValueSemantics.Index {
        return backingPrimitive.index(after: i)
    }
}

extension SemanticType: BidirectionalCollection where Spec.BackingPrimitiveWithValueSemantics: BidirectionalCollection {
    public func index(before i: Spec.BackingPrimitiveWithValueSemantics.Index) -> Spec.BackingPrimitiveWithValueSemantics.Index {
        return backingPrimitive.index(before: i)
    }
}

extension SemanticType: RandomAccessCollection where Spec.BackingPrimitiveWithValueSemantics: RandomAccessCollection { }

extension SemanticType: CustomPlaygroundDisplayConvertible where Spec.BackingPrimitiveWithValueSemantics: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return backingPrimitive.playgroundDescription
    }
}

// MARK: `Codable`
extension SemanticType: Encodable where Spec.BackingPrimitiveWithValueSemantics: Encodable {
  public func encode(to encoder: Encoder) throws {
    try backingPrimitive.encode(to: encoder)
  }
}

extension SemanticType: Decodable where Spec.BackingPrimitiveWithValueSemantics: Decodable {
  public init(from decoder: Decoder) throws {
    try self.init(
        try .init(from: decoder)
    )
  }
}
