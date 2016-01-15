/*:
# The `TypeBurrito` Protocol


## Purpose

`TypeBurrito` is a protocol that enables the quick, *boilerplate-free* creation of types that wrap other types --
thereby increasing **code safety** and **code clarity**.


## Walkthrough

Suppose we wish to create a simple app for managing a top-secret spy network. Our requirements are:
* Each spy has a politician she is assigned to spy on.
* A spy can tell us how heavy her cargo is from her latest mission:
	* If the weight of the cargo is below a certain threshold, we use the agency's standard-issue jetpack.
	* Otherwise, we tell the spy to order an Uber.


We deicde on an architecture for the task:
* We will store a dictionary mapping each spy to a politician
* We will store the weight threshold, and compare the total weigt of the spy's cargo to that threshhold. We will then issue directions to the spy accordingly.
*/

//: ### Attempt 1

// We build the dictionary of each spy's assigned politician (the spy is referred to by code, of course):
var spyPoliticianDictionary: [String : String] = [
	"Slick Silver" : "Vladimir Putin",
	"Micky Mouse" : "Donuld Trump",
	"Blackfish" : "Barack Obama",
	"JarJar" : "Hillary Clinton",
]

// Each spy carries a jetpack which can carry a maximum load of 220 lbs.
let jetpackMaximumLoad: Double = 220.0

//: Our desk agents just realized they got Blackfish's and JarJar's assigned politicians switched!
//: Not to worry, they just change them back:
spyPoliticianDictionary["Barack Obama"] = "Blackfish"
spyPoliticianDictionary["Hillary Clinton"] = "JarJar"

//: Did you notice something amiss?
//: Let's print our dictionary and see what it looks like:
print(spyPoliticianDictionary)

//: Whoops. Our dictionary is keyed by spy, not by politician.
//: When our desk agents tried to switch the spy's assignments, they had inadvertently corrupted our data.
//:
//: That's a nasty **run-time error** which may cause endless confusion in an entirely different area in our application.

/*:
Now, let's look at Micky Mouse's cargo.
He managed to get ahold of Donald Trump's barber's hair-grooming kit,
which our spy wishes to submit for further analysis.
He also managed to get ahold of a few bottles from Trump's European wine collection.
Our spy is not going to pass this up.
* our spy weighs 200 lbs.
* the hair-grooming kit weighs 5 lbs.
* the European wine bottles weigh 10 kg.
*/
let allWeights: [Double] = [200, 5.0, 10.0]

// we calculate the total weight of our load
let totalWeight = allWeights.reduce(0.0, combine: +)


func messageToSpy(forTotalWeight totaWeight: Double) -> String{
	var messageToSpy = ""
	if (totalWeight < jetpackMaximumLoad){
		messageToSpy = "Go ahead, take the jetpack. Your total weight is just \(totalWeight) lbs"
	}
	else {
		messageToSpy = "Your weight is too heavy, take "
	}
	
	return messageToSpy
}

let messageForMickyMouse = messageToSpy(forTotalWeight: totalWeight)
/*:
Whoops again.

We just killed our spy, Micky Mouse. RIP Micky Mouse.

What happend?
The wine bottles weigh 10 kgs! Not 10 lbs!
Units killed our spy (and he wasn't the first).
*/






