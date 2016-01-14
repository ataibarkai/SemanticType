The `TypeBurrito` Protocol
========================

Purpose
-------
`TypeBurrito` is a protocol that enables the quick creation of types that wrap other types --
thereby increasing **code safety** and **code clarity**.

Examples
--------

For `String`-containing `TypeBurrito` types:

	struct Name: TypeBurrito {
		var value: String = ""
	}

	struct SQLQuery: TypeBurrito {
		var value: String = ""
	}

	...

	func bookCharactersSqlQuery(forName name: Name) -> SQLQuery { ... }
	func findPersonsByPerformingSQLQuery(sqlQuery: SQLQuery) -> [Person] { ... }
	
For `SummableSubtractable`-containing `TypeBurrito` types:

	struct Kg: TypeBurrito{
		var value: Double = 0
	}

	struct Meters: TypeBurrito{
		var value: Double = 0
	}

	struct BMI: TypeBurrito {
		var value: Double = 0
	}
	
	func bmi(forMass mass: Kg, andHeight height: Meters) -> BMI { ... }


Details
-------

Types that conform to `TypeBurrito` can be used in a wide range of standard usecases,
intuitively reflecting their wrapped value's behavior:
* comparison (`<`, `==`)
* printing (`CustomStringConvertible`)
* as dictionary keys (using hashing)
* during debugging (`CustomDebugStringConvertible`)
* etc.

For types that wrap number types (`SummableSubtractable`), we also get
* Addition (between identical types only)
* Subtraction (between identical types only)

For types that wrap `String`s, we also get special functionality:
* To be added

e.g.

	struct Meters: TypeBurrito {
		var value: Double = 0
	}

	struct Feet: TypeBurrito {
		var value: Double = 0
	}
	
	let distanceAB = Meters(375.25)
	let distanceBC = Meters(341.77)
	
	// we can subtract 2 double-wrappers of the same type
	let distanceAC = distanceAB-distanceBC

	// distanceCD is of type Feet, not of type Meters!
	let distanceCD = Feet(324235)
	
	// Compile-time error. We cannot add Feet to Meters.
	// Crisis averted!
	let distanceAD = distanceAC + distanceCD

	// Compile-time error. We cannot compare Feet to Meters.
	// Crisis averted!
	if (distanceAC < distanceCD) { ... }


Advanced
--------

TypeBurrito can also be used in more advanced cases, e.g. where we want a `String`-wrappeing type
which **guarentees** case incensitivity:

	struct LowercaseUsername: TypeBurrito{
		private var _value = ""
		var value: String{
			get{
				return _value
			}
			set(newValue) {
				self._value = newValue.lowercaseString
			}
		}
	}

	let lowercaseJoe = LowercaseUsername("joe")
	let uppercaseJoe = LowercaseUsername("Joe")
	
	// true:
	if(lowercaseJoe == uppercaseJoe) { ... }
