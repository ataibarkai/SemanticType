
# The `TypeBurrito` Protocol

---------

## Purpose

`TypeBurrito` is a protocol that enables the quick, *boilerplate-free* creation of types that wrap other types --
thereby increasing **code safety** and **code clarity**.

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

---------

## Usage:

```swift
import TypeBurritoFramework

struct SQLQuery: TypeBurrito {
	var value: String = ""
}

struct CupsOfWater: TypeBurrito {
	var value: Int = 0
}

struct Meters: TypeBurrito {
	var value: Double = 0
}

let _ = SQLQuery("SELECT * FROM SwiftFrameworks")
let _ = CupsOfWater(40) + CupsOfWater(2)
let _ = Meters(987.25)

```

## Installation:

### Carthage
Add the following to your cartfile:

`github "ataibarkai/TypeBurritoFramework"`


## Walkthrough

**Note:** If you get tired of the motivating examples and just want to see `TypeBurrito` in action,
just skip to **"`Attempt 3`"** below.

**Also note:** The readme.md was generated from the `TypeBurritoExamplePlayground`.
To follow along, open the *workspace* (*not* the `.playground`) inside of the `ExamplePlayground` folder. Make sure you build the `TypeBurritoFramework` before running the Playground.

---------


Suppose we wish to create a simple app for managing a top-secret spy network. Our requirements are:
* Each spy has a politician she is assigned to spy on.
* A spy can tell us how heavy her cargo is from her latest mission:
	* If the weight of the cargo is below a certain threshold, we use the agency's standard-issue jetpack.
	* Otherwise, we tell the spy to order an Uber.


We deicde on an architecture for the task:
* We will store a dictionary mapping each spy to a politician
* We will store the weight threshold, and compare the total weigt of the spy's cargo to that threshhold. We will then issue directions to the spy accordingly.


```swift




```
### Attempt 1

```swift
// We build the dictionary of each spy's assigned politician (the spy is referred to by code, of course):
var spyPoliticianDictionary_1: [String : String] = [
	"Slick Silver" : "Vladimir Putin",
	"Micky Mouse" : "Donuld Trump",
	"Blackfish" : "Barack Obama",
	"JarJar" : "Hillary Clinton",
]

// Each spy has a jetpack which can carry a maximum load of 220 lbs.
let jetpackMaximumLoad_1: Double = 220.0

```
Our desk agents just realized they got Blackfish's and JarJar's assigned politicians switched!
Not to worry, they just change them back:
```swift
spyPoliticianDictionary_1["Barack Obama"] = "Blackfish"
spyPoliticianDictionary_1["Hillary Clinton"] = "JarJar"

```
Did you notice something amiss?
Let's print our dictionary and see what it looks like:
```swift
print(spyPoliticianDictionary_1)

```

Whoops. Our dictionary is keyed by spy, not by politician.
When our desk agents tried to switch the spy's assignments, they had inadvertently corrupted our data.

That's a nasty **run-time error** which may cause endless confusion in an entirely different area in our application.

The error occurs because from the compiler's point of view, a politician and a spy are equivalent.
They are both just `String`s.
However to the programmer they are not equivalent.

*There is an additional typing going on in the programmer's mind, which is not reflected to the compiler*.

The programmer just offloaded the job of keeping the types straight onto his own feeble mind.


```swift
```

Now, let's look at Micky Mouse's cargo.
He managed to get ahold of Donald Trump's barber's hair-grooming kit,
which our spy wishes to submit for further analysis.
He also managed to get ahold of a few bottles from Trump's European wine collection.
Our spy is not going to pass this up.
* our spy weighs 200 lbs.
* the hair-grooming kit weighs 5 lbs.
* the European wine bottles weigh 10 kg.

```swift
let allWeights_1: [Double] = [200, 5.0, 10.0]

// we calculate the total weight of our load
let totalWeight_1 = allWeights_1.reduce(0.0, combine: +)


func createMessage_1(forSpy spy: String, forTotalWeight totalWeight: Double, maximumLoad: Double ) -> String{
	var messageToSpy = ""
	if (totalWeight < maximumLoad){
		messageToSpy = "Go ahead \(spy), take the jetpack. Your total weight is just \(totalWeight) lbs"
	}
	else {
		messageToSpy = "Your weight is too heavy \(spy). Hit the gym or take an Uber."
	}
	
	return messageToSpy
}

let messageForMickyMouse = createMessage_1(
	forSpy: "Micky Mouse",
	forTotalWeight: totalWeight_1,
	maximumLoad: jetpackMaximumLoad_1
)
```

Whoops again.

We just killed our spy, Micky Mouse. RIP Micky Mouse.

What happend?
The wine bottles weigh 10 kgs! Not 10 lbs!
Units killed our spy (and he wasn't the first).


```swift




```
### Attempt 2

Let's try again. A safer, more restrictive type system would have saved us from our errors.

Let's try to create one:

We create a `Spy` type, and a `Politican` type.
Although both types are essentially just wrapers around a `String`,
they are distinct types and enjoy all compile-time analysis and compilation gurantees.

```swift
struct Spy_2 {
	var value = ""
}

struct Politician_2 {
	var value = ""
}


```
Now, let's create our dictionary:
```swift
// The code below does not compile:
//var spyPoliticianDictionary_2: [Spy_2 : Politician_2] = []

```
Our code does not compile, because an object must be hashable in order to be used as a dictionary key.
We add `hashable` as an `extension` on `Spy`.
In order to comply to `Hashable`, our object must also be `Equatable`. So we add this too.
```swift
extension Spy_2: Equatable, Hashable {
	var hashValue: Int{
		return self.value.hashValue
	}
}
func == (x: Spy_2, y: Spy_2) -> Bool{
	return x.value == y.value
}

```
We can now create our dictionary and populate it:
```swift
var spyPoliticianDictionary_2: [Spy_2 : Politician_2] = [
	Spy_2(value: "Slick Silver") : Politician_2(value: "Vladimir Putin"),
	Spy_2(value: "Micky Mouse") : Politician_2(value: "Donuld Trump"),
	Spy_2(value: "Blackfish") : Politician_2(value: "Barack Obama"),
	Spy_2(value: "JarJar") : Politician_2(value: "Hillary Clinton"),
]

```
Let's see what happens if we make the same mistake as before:
```swift
//spyPoliticianDictionary_2[Politician_2(value: "Barack Obama")] = Spy_2(value: "JarJar")
//spyPoliticianDictionary_2[Politician_2(value: "Hillary Clinton")] = Spy_2(value: "Blackfish")

```

Success! Our code does not even compile!

Why is that a success? Because we don't *want* our code to compile. It's *wrong*.

**We just turned a run-time error into a compile-timer error**.

We caught the error well before we even made it. *Minority Report*, anyone?


```swift
```
We are still suseptible to errors of some kind, but thsoe are much less subtle and far easier to catch.
For example we may do:
```swift
spyPoliticianDictionary_2[Spy_2(value: "Barack Obama")] = Politician_2(value: "JarJar")

```
I mean, Barack Obama may be a spy, but *JarJar, a politican?* Nah... :-J

```swift
```
Similarly with our jetpack load:
```swift
struct Lbs_2 {
	var value: Double = 0
}
struct Kgs_2 {
	var value: Double = 0
}

let jetpackMaximumLoad_2: Lbs_2 = Lbs_2(value: 220.0)

// The code does not compile
//let allWeights_2: [Lbs] = [Lbs(value: 200), Lbs(value: 5.0), Kgs(value: 10.0)]

```
Again, our code does not compile because of a type error:
`Kgs` types cannot be stored in a `[Lbs]` array.

```swift
extension Lbs_2 {
	init(_ kgs: Kgs_2){
		self.init(value: kgs.value * 2.2)
	}
}

let allWeights_2: [Lbs_2] = [Lbs_2(value: 200), Lbs_2(value: 5.0), Lbs_2(Kgs_2(value: 10.0))]

let totalWeight_2_attempt1 = allWeights_2.reduce(Lbs_2(value: 0)) {
	Lbs_2(value: $0.value + $1.value)
}

```
That's a bit ugly.
Let's implement a few functions on `Lbs` to allow us to more naturally perform this.
While we're at it, we'll implement a few more protocols and functions which we'll need later on.

```swift
extension Lbs_2: CustomStringConvertible, Equatable, Comparable {
	var description: String{
		return self.value.description
	}
}
func == (x: Lbs_2, y: Lbs_2) -> Bool {
	return x.value == y.value
}
func < (x:Lbs_2, y: Lbs_2) -> Bool {
	return x.value < y.value
}
func + (x: Lbs_2, y: Lbs_2) -> Lbs_2 {
	return Lbs_2(value: x.value + y.value)
}
func - (x: Lbs_2, y: Lbs_2) -> Lbs_2 {
	return Lbs_2(value: x.value - y.value)
}

```
Phew. That's quite a bit of boilerplate.
But if that's the price we have to pay, then that's the price we have to pay. Right?
Let's go on.

```swift
let totalWeight_2_attemp2 = allWeights_2.reduce(Lbs_2(value: 0), combine: +)

func createMessage_2(forSpy spy: Spy_2, forTotalWeight totalWeight: Lbs_2, maximumLoad: Lbs_2 ) -> String{
	var messageToSpy = ""
	if (totalWeight < maximumLoad){
		messageToSpy = "Go ahead \(spy), take the jetpack. Your total weight is just \(totalWeight) lbs"
	}
	else {
		messageToSpy = "Your weight is too heavy. Hit the gym or take an Uber."
	}
	
	return messageToSpy
}


let messageForMickyMouse_2 = createMessage_2(
	forSpy: Spy_2(value: "Micky Mouse"),
	forTotalWeight: totalWeight_2_attemp2,
	maximumLoad: jetpackMaximumLoad_2
)


```

Using our new-and-improved type system, We managed to get our job done.

Our spy did not die in a horrible jetpack accident, and (more importantly) our data was not corrupted.

But we also had to write *quite a bit* of boilerplate to get even the simplest of scenarios working.
Is there a better way?


```swift




```


# The `TypeBurrito` Solution

---------
### Attempt 3

Enter `TypeBurrito` and `Swift`'s awesome type system.

We can achieve type wrapping with all the sane behaviors, without any of the boilerplate.

All we have to do is adopt `TypeBurrito` in our type defintion.


```swift
import TypeBurritoFramework

struct Spy_3: TypeBurrito{
	var value: String = ""
}
struct Politician_3: TypeBurrito{
	var value: String = ""
}

```
We can jump right into dictionary creation. And we even avoid the `value: ...` in our constructors.
```swift
var spyPoliticianDictionary_3: [Spy_3 : Politician_3] = [
	Spy_3("Slick Silver") : Politician_3("Vladimir Putin"),
	Spy_3("Micky Mouse") : Politician_3("Donuld Trump"),
	Spy_3("Blackfish") : Politician_3("Barack Obama"),
	Spy_3("JarJar") : Politician_3("Hillary Clinton"),
]

```
Again, illegal actions are recognized as compile-time errors:
```swift
// The code below does not compile:
//spyPoliticianDictionary_3[Politician_3("Barack Obama")] = Spy_3("JarJar")

```
We can also create number-based `TypeBurritos`,
which also automatically implement `+` and `-` operations.
```swift
struct Lbs_3: TypeBurrito{
	var value: Double = 0.0
}

struct Kgs_3: TypeBurrito {
	var value: Double = 0.0
}

```
We can also extend `Lbs_3` to be initializable using `Kgs_3`
```swift
extension Lbs_3 {
	init(_ kgs: Kgs_3){
		self.init(kgs.value * 2.2)
	}
}

```
Now we simply create our weight-analysis logic:

```swift
let jetpackMaximumLoad_3: Lbs_3 = Lbs_3(220.0)

let allWeights_3: [Lbs_3] = [Lbs_3(200), Lbs_3(5.0), Lbs_3(Kgs_3(10.0))]
let totalWeight_3 = allWeights_3.reduce(Lbs_3(0), combine: +)

func createMessage_3(forSpy spy: Spy_3, forTotalWeight totalWeight: Lbs_3, maximumLoad: Lbs_3 ) -> String{
	var messageToSpy = ""
	if (totalWeight < maximumLoad){
		messageToSpy = "Go ahead \(spy), take the jetpack. Your total weight is just \(totalWeight) lbs"
	}
	else {
		messageToSpy = "Your weight is too heavy. Hit the gym or take an Uber."
	}
	
	return messageToSpy
}

let messageForMickyMouse_3 = createMessage_3(
	forSpy: Spy_3("Micky Mouse"),
	forTotalWeight: totalWeight_3,
	maximumLoad: jetpackMaximumLoad_3
)

```

That's it!

We get all the strengths that come with a highly-typed system, with none of the inconveniences!
Code safety, without the boilerplate.


```swift




```
### Advanced
There is more we can do with such a strong type system.
For example, we can create a type that **gurantees** case-incensitivity,
for example when dealing with usernames.

```swift
struct Username: TypeBurrito{
	private var _value: String = ""
	var value: String {
		get{
			return _value
		}
		set{
			self._value = newValue.lowercaseString
		}
	}
}

```
Now, let's create 2 users that we *want* to treat as equivalent,
however they are initialized using different `String`s
```swift
let joe1 = Username("joe@gmail.com")
let joe2 = Username("Joe@GMAIL.com")

if(joe1 == joe2){
	print("Success!")
	print("joe1 is equal to joe2")
}


```

