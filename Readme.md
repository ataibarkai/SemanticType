
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


# `TypeBurritoFramework`

---------

## What is it?

`TypeBurritoFramework` is a Swift µFramework which enables the *quick*, *boilerplate-free* creation of types that
* Wrap primitive types used in specific circumstances, allowing the type-checker to enforce safe usage.
* Cleanly couple to runtime data transformations & checks.

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

A type which adopts `TypeBurrito` *automatically* gets sane behavior and compliance for:
* `hashValue` (`Hashable` -> can be used as a dictionary key)
* `<`, `==` (`Comparable`, ***but only across the same subtype***)
* it is `CustomStringConvertible`, meaning we can print it and use it inside `String`s
* it is `CustomDebugStringConvertible`

If the underlying type wrapped by a `TypeBurrito` is a number, then we also *automatically* get:
* `+` (***but only across the same subtype***)
* `-` (***but only across the same subtype***)
* `+=` (***but only across the same subtype***)
* `-=` (***but only across the same subtype***)

---------

## Usage:

```swift
import TypeBurritoFramework

```
TypeBurrito declerations:
```swift
enum SQLQuery_Spec: TypeBurritoSpec { typealias TheTypeInsideTheBurrito = String }
typealias SQLQuery = TypeBurrito<SQLQuery_Spec>

enum Meters_Spec: TypeBurritoSpec { typealias TheTypeInsideTheBurrito = Double }
typealias Meters = TypeBurrito<Meters_Spec>

enum Inches_Spec: TypeBurritoSpec { typealias TheTypeInsideTheBurrito = Double }
typealias Inches = TypeBurrito<Inches_Spec>

```
TypeBurritos in practice:
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
We may also define `TypeBurritoSpec`s with a static function `gatewayMap` where:

`static func gatewayMap(preMap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito`

The gateway map allows us to construct types which have an *inherent*
restriction on the range of allowed values.

For example, we may construct a `Username` type which is inherently case-insensitive.
This is achieved by having a `gatewayMap` which converts any input to its lowercase version:

```swift
enum _Username: TypeBurritoSpec {
	typealias TheTypeInsideTheBurrito = String
	
	static func gatewayMap(preMap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito{
		return preMap.lowercaseString
	}
}
typealias Username = TypeBurrito<_Username>

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


```swift
```

### Advanced Usage: `FailableTypeBurrito`

There exists a `FailableTypeBurrito` (and a corresponding `FailableTypeBurritoSpec`)
which is directly analogous to the `TypeBurrito`.

However its `gatewayMap` function may return a `nil`, which would cause the `FailableTypeBurrito` to be `nil`.

For example:


```swift
enum EnglishLettersOnlyString_Spec: FailableTypeBurritoSpec {
	typealias TheTypeInsideTheBurrito = String
	
	static func gatewayMap(preMap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito? {
		
		if(preMap.stringByTrimmingCharactersInSet(NSCharacterSet.letterCharacterSet()) == "") {
			return preMap
		}
		else{
			return nil
		}
	}
}
typealias EnglishLettersOnlyString = FailableTypeBurrito<EnglishLettersOnlyString_Spec>

```
The following is made of only English letters, and therefore the resultant value is non-`nil`.
```swift
let actuallyOnlyLetters = EnglishLettersOnlyString("abclaskjdf")

```
The following is *not* made of only English letters, and therefore the resultant value is `nil`.
```swift
let notOnlyLettes = EnglishLettersOnlyString("asdflkj12345")


```

## Installation:

### Carthage
Add the following to your `Cartfile`:

`github "ataibarkai/TypeBurritoFramework"`


### CocoaPods
Add the following to your `Podfile`:

`pod 'TypeBurritoFramework', :git => 'https://github.com/ataibarkai/TypeBurritoFramework.git'`


