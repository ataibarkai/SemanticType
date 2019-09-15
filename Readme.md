
# `SemanticType`

---------

## What is it?

`SemanticType` is a Swift µFramework which enables the *quick*, *boilerplate-free* creation of types that
* Wrap primitive types used in specific circumstances, allowing the type-checker to enforce safe usage.
* Cleanly couple to runtime data transformations & validation checks.

---------


## Purpose
To allow for treating types as *restrictions* rather than merely as *data holders* -- thereby increasing code **safety** and **clarity**.

---------

## Inspiration

* https://realm.io/news/altconf-justin-spahr-summers-type-safety/
* http://www.johndcook.com/blog/2015/12/01/dimensional-analysis-and-types/
* http://www.joelonsoftware.com/articles/Wrong.html

---------

## Value

A  `SemanticType` wrapping a primitive "data-holding" type *automatically* gets
* conditional conformance for numerous standard-library protocols, including `Hashable`,  `Comparable`,  `Equatable`, `Sequence`, `Collection`, `AdditiveArithmetic`, `ExpressibleByLiteral` protocols, and many more.
* read/write to all variables defined on the underlying primitive value (via typed `@dynamicMemberLookup`  access)

---------

## Usage:

```swift
import SemanticType

```
SemanticType declerations:
```swift
enum SQLQuery_Spec: ErrorlessSemanticTypeSpec { typealias BackingPrimitiveWithValueSemantics = String }
typealias SQLQuery = SemanticType<SQLQuery_Spec>

enum Meters_Spec: ErrorlessSemanticTypeSpec { typealias BackingPrimitiveWithValueSemantics = Double }
typealias Meters = SemanticType<Meters_Spec>

enum Inches_Spec: ErrorlessSemanticTypeSpec { typealias BackingPrimitiveWithValueSemantics = Double }
typealias Inches = SemanticType<Inches_Spec>

```
SemanticType in practice:
```swift
let query = SQLQuery("SELECT * FROM SwiftFrameworks")
let metersClimbedToday = Meters(40) + Meters(2)
let truth = ( Meters(1000) > Meters(34) )

var distanceLeft = Meters(987.25)
distanceLeft -= Meters(10)

let lengthOfScreenDiagonal = Inches(13)

func performSQLQuery(sqlQuery: SQLQuery){
    // can only be called with a SQLQuery, not with just any String
}

```
The following would be a compile time error were it not commented-out
```swift
//let _ = Meters(845.235) + Inches(332)

```

### The `gatewayMap` Function
We may also define `ErrorlessSemanticTypeSpec`s with a static function `gatewayMap` where:

`static func gatewayMap(preMap: BackingPrimitiveWithValueSemantics) -> BackingPrimitiveWithValueSemantics`

The gateway map allows us to construct types which have an *inherent*
restriction on the range of allowed values.

For example, we may construct a `Username` type which is inherently case-insensitive.
This is achieved by having a `gatewayMap` which converts any input to its lowercase version:

```swift
enum Username_Spec: ErrorlessSemanticTypeSpec {
    typealias BackingPrimitiveWithValueSemantics = String
    
    static func gatewayMap(preMap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito{
        return preMap.lowercaseString
    }
}
typealias Username = SemanticType<Username_Spec>

```
From that point onwards, we may be **sure** that if we are given a `Username`,
whether it was constructed from lowercase or uppercase characters is inconsequential.

```swift
let lowercaseSteve = Username("steve@gmail.com")
let uppercaseSteve = Username("STEVE@GMAIL.COM")

assert(lowercaseSteve == uppercaseSteve)

```

The `gatewayMap` can come in handy whenever we have a restriction on our values
which is *inherent in our "mental" model of the type*, but *not in the underlying data type*.

Examples include:
* a `URL` type which is always url-escaped
* a `SQLCommand` type which is always sql-escaped (and not prone to SQL-injection attacks)
* a `LevelInSomeBuilding` type which does not allow values below -1 nor above 72 (the lowest and highest levels in SomeBuilding).
* etc.

We still have "type information" which is associated with runtime behavior rather than with compile-time behavior, but this information (and all associated testing!) is now restricted to the `gatewayMap()` function.



### Advanced Usage: `SemanticTypeSpec`

`ErrorlessSemanticTypeSpec` is a protocol refinement (with default behavior provided via an extension) of the more basic `SemanticTypeSpec` protocol.
The `SemanticTypeSpec` protocol's more basic  `gatewayMap`  function may not only transform the incoming value, but also return some *error* if the value failed to pass some validation. 

For example:


```swift
enum EnglishLettersOnlyString_Spec: SemanticTypeSpec {
    typealias BackingPrimitiveWithValueSemantics = String
    
    enum Error: Swift.Error {
       case containsNonEnglishCharacters(nonEnglishCharacters: String)
    }
    
    static func gatewayMap(preMap: BackingPrimitiveWithValueSemantics) -> Result<String, Error> {
        let nonEnglishCharacters = preMap.stringByTrimmingCharactersInSet(NSCharacterSet.letterCharacterSet())
        if(nonEnglishCharacters == "") {
            return .success(preMap)
        }
        else{
            return .failure(.containsNonEnglishCharacters(nonEnglishCharacters: nonEnglishCharacters))
        }
    }
}
typealias EnglishLettersOnlyString = SemanticType<EnglishLettersOnlyString_Spec>

```
The following is made of only English letters, and therefore the initialization will not `throw`:
```swift
let actuallyOnlyLetters = try EnglishLettersOnlyString("abclaskjdf")

```
The following is *not* made of only English letters, and therefore the initializatino will `throw`:
```swift
let notOnlyLettes = try? EnglishLettersOnlyString("asdflkj12345")

```

A typed version of the error is available through the `Result`-returning `.create()` factory function:
```swift
let notOnlyLettes = EnglishLettersOnlyString.create("asdflkj12345")

```


### Most Advanced Usage: `GeneralizedSemanticTypeSpec`

`SemanticTypeSpec` is itself also a protocol refinement (with default behavior provided via an extension) of the **most** basic `GeneralizedSemanticTypeSpec` protocol.
The `GeneralizedSemanticTypeSpec` protocol's most basic  `gatewayMap`  function also defines a metadata value stored on the `SemanticType` instance which is publically available for access.
It may be used to encode a compiler-accessible fascet of the sub-structure of the wrapped value
which was veriried by the `gatewayMap` function.

As an example: suppose we create a `NonEmptyArray` `SemanticType`, i.e. a type whose instances wrap an `Array` -- but which could only be created when said `Array` is non-empty.

Unlike instances of `Array`, instances of `NonEmptyArray` are **guarenteed** to have `first` and `last` elements.
Thus we may expose `first: Element` and `last: Element` in place of `Array`'s corresponding *optional* properties.

Since we know that instances of `NonEmptyArray` are not empty, we _could_ implement said non-optionoal  `first` and `last` overrides by forwarding the call to `Array`'s optional properties and force-unwrapping the result. While *we* know this process ought to work, the *compiler* does not -- hence the need for the force-unwrapping. And so we lose the celebrated compiler verification normally characterizing idiomatic swift code.

Instead, we could implement `first` and `last` without circumventing compiler verifications by storing the `Array`'s `first` and `last`
values as *metadata* during the `gatewayMap`ing (where we could return an error if `first` and `last` are not available).
Then the non-optional `first` and `last` properties could be implemented by querying said metadata values.

For example:
```swift
enum NonEmptyIntArray_Spec: GeneralizedSemanticTypeSpec {
    typealias BackingPrimitiveWithValueSemantics = [Int]
    struct GatewayMetadataWithValueSemantics {
        var first: Int
        var last: Int
    }
    enum Error: Swift.Error {
        case arrayIsEmpty
    }
    
    static func gateway(preMap: [Int]) -> Result<GatewayOutput, Error> {
        
        // a non-empty array will always have first/last elements:
        guard
            let first = preMap.first,
            let last = preMap.last
            else {
                return .failure(.arrayIsEmpty)
        }
        
        return .success(.init(
            backingPrimitvie: preMap,
            metadata: .init(first: first,
                            last: last)
        ))
    }
}
typealias NonEmptyIntArray = SemanticType<NonEmptyIntArray_Spec>

extension NonEmptyIntArray {
    var first: Int {
        return gatewayMetadata.first
    }
    
    var last: Int {
        return gatewayMetadata.last
    }
}


// ...

let oneTwoThree = try! NonEmptyIntArray.create([1, 2, 3]).get()
XCTAssertEqual(oneTwoThree.first as Int, 1)
XCTAssertEqual(oneTwoThree.last as Int, 3)

```
