# The `TypeBurrito` Protocol

```swift
```

## Purpose

`TypeBurrito` is a protocol that enables the quick, *boilerplate-free* creation of types that wrap other types --
thereby increasing **code safety** and **code clarity**.


```swift

```

## Walkthrough

We will explore the micro-framework by considering a stripped-down example.


```swift

import Foundation
import TypeBurritoFramework



```
## Points to Remember
* Empty lines end the single line comment delimiter rich text block
* Comment content ends at a newline
* Any commands that work in a comment block work in single line
    * This **includes** text formatting commands

```swift
struct Username_Naive {
	var value: String = ""
}
```

