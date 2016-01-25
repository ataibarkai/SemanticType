
# The `TypeBurrito` Protocol

---------

## Purpose

`TypeBurrito` is a protocol that enables the quick, *boilerplate-free* creation of types that wrap other types --
thereby increasing **code safety** and **code clarity**.


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
TypeBurrito declerations
```swift
enum _SQLQuery: TypeBurritoSpec { typealias TheTypeInsideTheBurrito = String }
typealias SQLQuery = TypeBurrito<_SQLQuery>

enum _CupsOfWater: TypeBurritoSpec { typealias TheTypeInsideTheBurrito = Int }
typealias CupsOfWater = TypeBurrito<_CupsOfWater>

enum _Meters: TypeBurritoSpec { typealias TheTypeInsideTheBurrito = Double }
typealias Meters = TypeBurrito<_Meters>

enum _Inches: TypeBurritoSpec { typealias TheTypeInsideTheBurrito = Double }
typealias Inches = TypeBurrito<_Inches>

```
TypeBurritos in practice
```swift
let query = SQLQuery("SELECT * FROM SwiftFrameworks")
let cupsDrankThisWeek = CupsOfWater(40) + CupsOfWater(2)
let truth = ( Meters(1000) > Meters(34) )

var distanceLeft = Meters(987.25)
distanceLeft -= Meters(10)

let sizeOfScreenDiagonal = Inches(13)

func performSQLQuery(sqlQuery: SQLQuery){
	// can only be called with a SQLQuery, not with just any String
}

```
The following would be a compile time error were it not commented-out
```swift
//let _ = Meters(845.235) + Inches(332)

```

## Installation:

### Carthage
Add the following to your cartfile:

`github "ataibarkai/TypeBurritoFramework"`


