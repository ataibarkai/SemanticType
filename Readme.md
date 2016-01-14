The `TypeBurrito` Protocol
==========================

Purpose
-------
`TypeBurrito` is a protocol that enables the quick, *boilerplate-free* creation of types that wrap other types --
thereby increasing **code safety** and **code clarity**.

For a broader discussion see:
* https://realm.io/news/altconf-justin-spahr-summers-type-safety/
* http://nomothetis.svbtle.com/types-as-units

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

e.g.

	struct NameOfPerson: TypeBurrito{
		var value = "John Doe"
	}

	struct FavoriteFood: TypeBurrito {
		var value = "Burrito!"
	}

	...
	
	var favoriteFoodMap = [NameOfPerson : FavoriteFood]()

	let personName1 = NameOfPerson("George Costanza")
	let food1 = FavoriteFood("Calzone")

	let personName2 = NameOfPerson("Jerry Seinfeld")
	let food2 = FavoriteFood("Pickino's Pizza")

	let personName3 = NameOfPerson("Elaine Benes")
	let food3 = FavoriteFood("(pro-choice) Duck")

	favoriteFoodMap[personName1] = food1 // we can use PersonName as a dictionary key without any boilerplate!
	favoriteFoodMap[personName2] = food2
	favoriteFoodMap[personName3] = food3
	
	if(favoriteFoodMap[personName1] == food1) {
	print(favoriteFoodMap[personName1]) // we can print a FavoriteFood without any boilerplate!
	}

For types that wrap number types (`SummableSubtractable`), we also get
* Addition (between identical types only)
* Subtraction (between identical types only)

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

