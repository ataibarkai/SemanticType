
# `SemanticType`

---------

## Purpose

To make it easy to create types used as *restrictions* rather than merely as *data holders* -- and to thereby improve code **safety** and **clarity**.

---------

## Inspiration

* https://realm.io/news/altconf-justin-spahr-summers-type-safety/
* http://www.johndcook.com/blog/2015/12/01/dimensional-analysis-and-types/
* http://www.joelonsoftware.com/articles/Wrong.html

---------

## What is it?

A `SemanticType` is a *context-specific type* which wraps an underlying value used in specific circumstances.
It's a type created to capture and convey some *meaning* about a value *which isn't already captured by the type used to encode the value*.


### What?
Say your program contains the `Person` and `Robot` types:
```swift
struct Person {
    var name: String    
    var age: Int
}

struct Robot {
    var id: Int
    var batteryPercentage: Int
}
```

The swift compiler draws a sharp distinction between a `foo: Person`  variable and a `bar: Robot` variable; there is no danger of accidentally passing a `Robot` to a function that expects a `Person`, and a quick *option-click* type-reveal immediaely reveals the kinds of computations in which we could expect the variable to participate. 

However the same is *not* true when we look at the `Int` fields introduced above. Though  `Person.age`, `Robot.id`, and `Robot.batteryPercentage` fields capture entirely different kinds of dat, they are all given by the `Int` type.
Clearly, passing the contents of `Robot.batteryPercentage` into a function expecting `Robot.id` is as nonesensical as passing a `Person` to a function expecting a `Robot`. However since in the former case **all the compiler sees are `Int`s,**  it can help us with neither clarity nor precision.

This issue would disappear if our types were richer:
```swift
struct Person {
    var name: String    
    var age: Years
}

struct Robot {
    var id: ID
    var batteryPercentage: BatteryPercentage
}
```

We now have `age: Years`, `id: ID`, and `batteryPercentage: BatteryPercentage` (where `Years`, `ID`, and `BatteryPercentage` are distinct types, rather than `typealias`es for  `Int`).
Though ultimately each field is backed by an `Int`-encoded integer, the fields have different types -- which means that the distinction between the fields is now visible to the compiler.

The compiler can then utilize this visible distinction between the fields to perform many sanity-checks on our behalf, such as making sure we never populate a `Person`'s age with some `ID` field, and that we never accidentally add up or subtract `Years` and `BatteryPercentage` values (what is 45 years + 20% battery percentage?).
Besides, it's nice to be able to quickly see whether a given variable captures `Years`, an `ID`, `BatteryPercentage` -- or some other structure of significance.

---------


## Why do I need this library? Can't I make my own rich types?

You could of course trivially create purpose-specific structures to wrap an underlying backing value used in particular circumstances.
For instance, you could do:
```swift
struct Years {
    var value: Int
}
```

So why do you need this library?



The SemanticType library defines the `SemanticType` structure, which gives you:
*Automatic* conformance to numerous standard-library protocols whenever the underlying wrapped type conforms to them. The supported protocols include `Hashable`,  `Comparable`,  `Equatable`, `Sequence`, `Collection`, `AdditiveArithmetic`, `ExpressibleByLiteral` protocols, and many, many, more. This makes it easy to use `SemanticType` instances in the context of generic data-structures (e.g. as keys in a `Dictionary`), of protocol-oriented operations (e.g. in comparisons, additions, subtractions, etc.), as well as in the context of generic algorithms.
* `SemanticType`s expose *direct* read/write access all instance-variables/functions defined on their backing primitive value (via typed `@dynamicMemberLookup`  access)
* `SemanticType` makes it easy to impose strict *transformations and validation constraints* on the allowable values of the backing primitives, while guarenteeing that said constraints are maintained across all operations. For instance, you can easily create  `OddNumber` and `EvenNumber` types which *guarentee* that all of their instances are odd/even, respectively.

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
The following would result in a compile time error were it not commented-out:
```swift
//let _ = Meters(845.235) + Inches(332)

```

### The `gatewayMap` Function
We may also define `ErrorlessSemanticTypeSpec`s with a static function `gatewayMap` where:

`static func gatewayMap(preMap: BackingPrimitiveWithValueSemantics) -> BackingPrimitiveWithValueSemantics`

The gateway map allows us to construct types which have an *inherent*
restriction on the range of the allowed values.

For example, we may construct a `Username` type which is inherently case-insensitive.
This is achieved by having a `gatewayMap` which converts any input to its lowercase version:

```swift
enum Username_Spec: ErrorlessSemanticTypeSpec {
    typealias BackingPrimitiveWithValueSemantics = String
    
    static func gatewayMap(preMap: BackingPrimitiveWithValueSemantics) -> BackingPrimitiveWithValueSemantics {
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

`ErrorlessSemanticTypeSpec` is a protocol refinement (with default behavior provided via an extension) of the more general `SemanticTypeSpec` protocol.
The `SemanticTypeSpec` protocol's more general  `gatewayMap`  function may not only transform the incoming value, but also return some *error* if the value failed to pass some validation. 

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
        } else{
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
let englishLettersCreationResult: Result<EnglishLettersOnlyString, EnglishLettersOnlyString_Spec.Error> = EnglishLettersOnlyString.create("asdflkj12345")

```


### Most Advanced Usage: `GeneralizedSemanticTypeSpec`

`SemanticTypeSpec` is itself also a protocol refinement (with default behavior provided via an extension) of the **most** generic `GeneralizedSemanticTypeSpec` protocol.
The `GeneralizedSemanticTypeSpec` protocol's most generic  `gatewayMap`  functio, in addition to the transformed primitive to back a  `SemanticTypeSpec` value, returns an arbitrarily-typed *metadata value* which is then stored on the `SemanticType` instance and made publically available for access.
This metadata value may be used to encode a compiler-accessible fascet of the sub-structure of the wrapped value
which was veriried by the `gatewayMap` function.

As an example: suppose we create a `NonEmptyArray` `SemanticType`, i.e. a type whose instances wrap an `Array` -- but which could only be created when said `Array` is non-empty.

Unlike instances of `Array`, instances of `NonEmptyArray` are **guarenteed** to have `first` and `last` elements.
Thus we may expose `first: Element` and `last: Element` in place of `Array`'s corresponding *optional* properties.

Since we know that instances of `NonEmptyArray` are not empty, we _could_ implement said non-optionoal  `first` and `last` overrides by forwarding the call to `Array`'s optional properties and force-unwrapping the result. While *we* know this process ought to work, the *compiler* does not -- hence the need for the force-unwrapping. And so we lose the celebrated compiler verification normally characterizing idiomatic swift code.

Instead, we could implement `first` and `last` without circumventing compiler verifications by storing the `Array`'s `first` and `last` values as *metadata* during the `gatewayMap`ing (where we could return an error if `first` and `last` are not available).
The non-optional `first` and `last` properties could then be implemented by querying said metadata values.

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
