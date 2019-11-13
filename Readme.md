
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

The swift compiler draws a sharp distinction between a `foo: Person`  variable and a `bar: Robot` variable; there is no danger of accidentally passing a `Robot` to a function that expects a `Person`, and a quick *option-click* immediaely reveals the type of the variable -- and therefore the kinds of computations in which we could expect the variable to participate. 

The same is *not* true when we look at the `Int` instance fields introduced above.
Though the  `Person.age`, `Robot.id`, and `Robot.batteryPercentage` fields capture entirely different kinds of data, they are all typed as  `Int` s. And since **all the compiler sees is a variable's type,**  it can help us with neither clarity nor precision.

Passing the contents of `Robot.batteryPercentage` into a function expecting `Robot.id` would be just as nonesensical as passing a `Person` to a function expecting a `Robot`. However while the latter would be caught by the compiler, the former would not. 

#### What can we do about this?
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
Though ultimately each field is backed by an `Int`-encoded integer, the fields have different types -- which means that the semantic distinction between the fields is now visible to the compiler.

The compiler can then utilize this visible distinction between the fields to perform many sanity-checks on our behalf, such as making sure we never populate a `Person`'s age with some `ID` field, and that we never accidentally subtract `Years` from `BatteryPercentage` values.
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

The SemanticType library defines the `SemanticType` structure, which offers sensible convenience as well as carefully-implemented type-level constraint validation:
* `SemanticType`s *automatically* conform to numerous standard-library protocols -- whenever their underlying wrapped type conforms to them. The supported protocols include `Hashable`,  `Comparable`,  `Equatable`, `Sequence`, `Collection`, `AdditiveArithmetic`, `ExpressibleByLiteral` protocols, and **many, many, more**. This makes it easy to use `SemanticType` instances in the context of generic data-structures (e.g. as keys in a `Dictionary`), of protocol-oriented operations (e.g. in comparisons, additions, subtractions, etc.), as well as in the context of generic algorithms.
* `SemanticType`s expose *direct* read/write access all instance-variables defined on their `rawValue` (via typed `@dynamicMemberLookup`  access).
* `SemanticType` makes it easy to impose strict *transformations and validation constraints* on the allowable values of the `rawValue`s, while guarenteeing that said constraints are maintained across all operations. For instance, you can easily create  `OddNumber` and `EvenNumber` types which *guarentee* that all of their instances are odd/even, respectively (see [Advanced Usage](#advanced-usage-semantictypespec)).

---------

## Usage:

### Without further ado, some code
We will cover the different use-cases in detail below. But first some example code:

```swift
enum Seconds_Spec: ErrorlessSemanticTypeSpec { typealias RawValue = Double }
typealias Seconds = SemanticType<Seconds_Spec>

var step1Duration: Seconds = 5
let step2Duration: Seconds = 10

XCTAssertEqual(
    step1Duration + step2Duration,
    Seconds(15)
)

step1Duration += 7
XCTAssertEqual(
    step1Duration,
    Seconds(12)
)

XCTAssertEqual(
    step1Duration - step2Duration,
    Seconds(2)
)

// The following will fail to compile, because we try to add `Seconds` and `Double` together:
let notCompiling = step1Duration + Double(18)
```

```swift
enum CaselessString_Spec: ErrorlessSemanticTypeSpec {
    typealias RawValue = String
    
    static func gateway(preMap: String) -> String {
        return preMap.lowercased()
    }
}
typealias CaselessString = SemanticType<CaselessString_Spec>

var joe = CaselessString("Joe")
XCTAssertEqual(joe.rawValue, "joe")
joe.rawValue.removeLast()
joe.rawValue.append("SEPH")
XCTAssertEqual(joe.rawValue, "joseph")
```

```swift
struct ContactFormInput {
    var email: String
    var message: String
}
enum ProcessedContactFormInput_Spec: ErrorlessSemanticTypeSpec {
    typealias RawValue = ContactFormInput
    
    static func gateway(preMap: ContactFormInput) -> ContactFormInput {
        return .init(
            email: preMap.email.lowercased(),
            message: preMap.message
        )
    }
}
typealias ProcessedContactFormInput = SemanticType<ProcessedContactFormInput_Spec>

let joesProcessedContactFormInput = ProcessedContactFormInput(ContactFormInput.init(
    email: "joe.shmoe@GMAIL.com",
    message: "What a great library!"
))
XCTAssertEqual(joesProcessedContactFormInput.email, "joe.shmoe@gmail.com")
XCTAssertEqual(joesProcessedContactFormInput.message, "What a great library!")
```

```swift
struct Person: Equatable {
    var name: String
    var associatedGreeting: String
    
    init(name: String) {
        self.name = name
        self.associatedGreeting = "Hello, my name is \(name)." // initialize greeting to default
    }
}
enum PersonWithShortName_Spec: ValidatedSemanticTypeSpec {
    typealias RawValue = Person
    enum Error: Swift.Error, Equatable {
        case nameIsTooLong(name: String)
    }
    
    static func gateway(preMap: Person) -> Result<Person, PersonWithShortName_Spec.Error> {
        guard preMap.name.count < 5
            else { return .failure(.nameIsTooLong(name: preMap.name)) }
        
        return .success(preMap)
    }
}
typealias PersonWithShortName = SemanticType<PersonWithShortName_Spec>

let tim = try! PersonWithShortName(Person(name: "Tim"))
XCTAssertEqual(tim.rawValue, Person(name: "Tim")
XCTAssertEqual(tim.name, "Tim")
XCTAssertEqual(tim.associatedGreeting, "Hello, my name is Tim.")


let joe = try! PersonWithShortName(Person(name: "Joe"))
let lowercaseJoeResult = joe.tryMap { person in
    var person = person
    person.associatedGreeting = person.associatedGreeting.lowercased()
    return person
}
let lowercaseJoe = try! lowercaseJoeResult.get()
```

### Background

A `SemanticType` is defined by a `SemanticTypeSpec` type, of the  `SemanticTypeSpec` protocol family.

A `SemanticTypeSpec` type has 3 roles:
1. It serves as a marker type, bringing about a type-level distinction between  `SemanticType` instantiations.
2. It defines the `RawValue` type wrapped by its associated `SemanticType` instantiation.
3. It defines how `RawValue` values are transformed and validated before making their way into a `SemanticType` value.

The `SemanticTypeSpec` protocol family consists of a base protocol, and 2 (successive) protocol refinements:

`ErrorlessSemanticTypeSpec`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;***\~\~refines\~\~>*** `ValidatedSemanticTypeSpec`<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;***\~\~refines\~\~>*** `MetaValidatedSemanticTypeSpec`

At the core of the `SemanticTypeSpec` lies the `gateway` function, which (aptly) serves as a gateway between `RawValue`s and `SemanticType` instances. The `gateway` dictates how values of the underlying `RawValue` type behave as they are transformed into values of a `SemanticType` instantiation.

| Protocol                        | `gateway` function type                             |
|---------------------------------|-----------------------------------------------------|
| `ErrorlessSemanticTypeSpec`     | `(RawValue) -> RawValue`                            |
| `ValidatedSemanticTypeSpec`     | `(RawValue) -> Result<RawValue, Error>`             |
| `MetaValidatedSemanticTypeSpec` | `(RawValue) -> Result<(RawValue, Metadata), Error>` |



### `ErrorlessSemanticTypeSpec`
`ErrorlessSemanticTypeSpec` is the simplest (and most refined) `SemanticTypeSpec` protocol.
It is used when we don't need to validate our `RawValue` payload in any way (i.e. when every `RawValue` instance can be made to correspond to a `SemanticType` instance).

By default, `ErrorlessSemanticTypeSpec`'s `gateway` function is simply the identify function (i.e. it doesn't transform the `RawValue` in any way).
Instantiations of `SemanticType` often support the same operations as their `RawTypes` -- but only *within the same type*, not *across types*:
```swift
enum Years_Spec: ErrorlessSemanticTypeSpec { typealias RawValue = Double }
typealias Years = SemanticType<Years_Spec>

let fiveYears: Years = 5
let threeYears: Years = 3
let eigthYears: Years = fiveYears + threeYears
let truth = ( Years(151) > Years(34) )


enum Inches_Spec: ErrorlessSemanticTypeSpec { typealias RawValue = Double }
typealias Inches = SemanticType<Inches_Spec>

let tenInches: Inches = 10
let fourInches: Inches = 4

let anotherTruth = ( fourInches <= tenInches )

---

// The following examples would not compile, as they mix-up `Years` and `Inches`:
let willNotCompile1 = Years(5) + Inches(1)
let willNotCompile2 = Yeras(19) > Inches(32)
```

We can also consider cases where the `gateway` function is explicitly specified -- allowing us to specify an arbitrary transformation to be applied to a `RawValue` before it is transformed into a `SemanticType`.
The `gateway` function can be leveraged to construct types which have an *inherent* restriction on the range of the allowed values.

For instance, consider the following `CaseInsensitiveString` type which is *inherently* case-insensitive:
```swift
enum CaseInsensitiveString_Spec: ErrorlessSemanticTypeSpec {
    typealias RawValue = String
    
    static func gateway(preMap: String) -> String {
        return preMap.lowercased()
    }
}
typealias CaseInsensitiveString = SemanticType<CaseInsensitiveString_Spec>

let hello1: CaseInsensitiveString = "hELlo"
let hello2: CaseInsensitiveString = "HelLO"
let _ = (hello1 == hello2) // true
```

From this point onwards, we can be **sure** that if we have a `CaseInsensitiveString` instance, no operation on it would depend on any casing information.

Other examples include a `SQLCommand` type which is always sql-escaped (and not prone to SQL-injection attacks), a `LevelInSomeBuilding` type which clamps values to values above -1 and below 72 (the lowest and highest levels in `SomeBuilding`), etc.

While we still have "type information" which is associated with runtime behavior rather than with compile-time behavior, this information **(and all associated testing!)** is now restricted to the `gateway` function.
This can come in handy whenever we have a restriction on our values which is *inherent in our "mental" model of the type*, but *not in the underlying data type*.



### `ValidatedSemanticTypeSpec`

The aforementioned `ErrorlessSemanticTypeSpec` is a protocol refinement (with default behavior provided via an extension) of the more general `ValidatedSemanticTypeSpec` protocol.
The `ValidatedSemanticTypeSpec` protocol's more general  `gateway`  function may not only transform the incoming value, but also return some *error* if the value failed to pass some validation. 

For example:
```swift
enum EnglishLettersOnlyString_Spec: SemanticTypeSpec {
    typealias RawValue = String
    
    enum Error: Swift.Error {
       case containsNonEnglishCharacters(nonEnglishCharacters: String)
    }
    
    static func gatewayMap(preMap: RawValue) -> Result<String, Error> {
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
let actuallyOnlyLetters = try EnglishLettersOnlyString("abclaskjdf") // will succeed
```

The following is *not* made of only English letters, and therefore the initializatino will `throw`:
```swift
let notOnlyLettes = try? EnglishLettersOnlyString("asdflkj12345") // will throw
```

A typed version of the error is available through the `Result`-returning `.create()` factory function:
```swift
let englishLettersCreationResult: Result<EnglishLettersOnlyString, EnglishLettersOnlyString_Spec.Error> = EnglishLettersOnlyString.create("asdflkj12345")
```



### `MetaValidatedSemanticTypeSpec`

`ValidatedSemanticTypeSpec` is itself also a protocol refinement (with default behavior provided via an extension) of the **most** generic `MetaValidatedSemanticTypeSpec` protocol.
The `MetaValidatedSemanticTypeSpec` protocol's most generic  `gateway`  function, in addition to the transformed `RawValue` to back the  `SemanticType` instance, returns an arbitrarily-typed *metadata value* which is then stored on the `SemanticType` instance and made publically available for access.
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
    typealias RawValue = [Int]
    struct Metadata {
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
            rawValue: preMap,
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
XCTAssertEqual(oneTwoThree.first, 1)
XCTAssertEqual(oneTwoThree.last, 3)

```


## Subtleties

### A note on `Numeric` support

`Numeric` is the protocol Swift uses to support *multiplication and division* within a given type.

`Numeric` support may not make sense for all `SemanticType`s, even when their `RawValue` types are themselves `Numeric`. For instance, [`Second` * `Second` = `Second`] does not make semantic sense.

In other situations, `Numeric` support *does* make sense. For instance [`EvenInteger` * `EvenInteger` = `EvenInteger`].

We allow the `SemanticTypeSpec` backing the `SemanticType` to signal whether `Numeric` support should be provided by conforming to the `ShouldBeNumeric` marker protocol.
