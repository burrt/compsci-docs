---
layout: compsci-note
title: Go Notes
categories: [language]
description: Some notes on Go lang
order: 20
sitemap: false
---

## Contents

* [Basics](#basics)
* [Slices](#slices)
* [Defers](#defers)

## Basics

[Compulsory docs link](https://golang.org/doc/)

### Docstrings

See more [here](https://blog.golang.org/godoc-documenting-go-code).

The convention is simple: to document a type, variable, constant, function, or even a package, write a regular comment directly preceding its declaration, with no intervening blank line. Godoc will then present that comment as text alongside the item it documents. For example, this is the documentation for the `fmt` package's `Fprint` function:

```go
// Fprint formats using the default formats for its operands and writes to w.
// Spaces are added between operands when neither is a string.
// It returns the number of bytes written and any write error encountered.
func Fprint(w io.Writer, a ...interface{}) (n int, err error) {
```

### Types

* `int`
* `float32`, `float64`
* `bool`
* `string`
* `byte`: alias for `uint8`

```go
// programs by default are written in main

// importing multiple packages
import (
    "fmt"
    "math"
)

// declaring variables
var x, y = 1, 2
a, b := 3, 4
const c = 65  // not :=

// variables can be declared in an if stmt!
// they are only in the scope until the end of the if!
// notice no parens but must have {}
if v := 1; v = true {
    fmt.Println("Cool eh?")
} else {
    fmt.Println("Yeah")
}

// switch statement auto adds the break stmt!
// so it won't pass through multiple cases!
// it doesn't need a condition!
switch x := 1; x {
    case 1:
        fmt.Println("Yeah")
    case 2:
        fmt.Println("Never reached!")
    default:
        fmt.Println("Seems normal C")
}

// structs
type Vertex struct {
    X, Y int
}

var (
    v1 = Vertex{1, 2}  // has type Vertex
    v2 = Vertex{X: 1}  // Y:0 is implicit
    v3 = Vertex{}      // X:0 and Y:0
    p  = &Vertex{1, 2} // has type *Vertex
)

// arrays
var arr [10]string // literally an array of strings!
arr[0] = "start of"
arr[1] = "a super long string!"
primes := [6]int{2, 3, 5, 7, 11, 13}

// slices - list magic equivalent
// very efficient - basically pointers
s := []int{2, 3, 5, 7, 11, 13}
a := make([]int, x) // dynamic
a := make([]int, length, capacity) // dynamic


// if you specify a lower bound when slicing
// this will affect the capacity!
// otherwise specifying an upper bound doesn't!
s = s[1:] // cap -= 1
s = [:0] // no change in cap, only in len


// function declarations
// this syntax is to avoid the disgusting C function pointers
func swap(x, y string) (string, string) {
    return y, x
}

// main function
func main() {
    a, b := swap("hello", "world")  // like Python :D
    fmt.Println(a, b)
}


```

#### Printing

```go
s := "go is interesting"  // double quotes matter!
fmt.Printf("Type: %T, val: %v\n", 100, 100)
fmt.Printf("Type: %T, without quotes: %v, with quotes: %q\n", s, s, s)
```

### Slices

Slices deserves its own space - really awesome data structure like lists in Python but better and a bit more magic.

* length of a slice is the number of elements it contains.
* capacity of a slice is the number of elements in the underlying array, counting from the first element in the slice.
* `len(s)` and `cap(s)`.

```go
// more interesting ones
s := []struct {
        i int
        b bool
    }{
        {11, false},
        {13, true},
    }

// extending a slice
// actually allocates in multiples of 2
var s []int            // len(0), cap(0)
s = append(s, 0, 1)    // len(3), cap(2)
s = append(s, 2, 3, 4) // len(5), cap(8)

// array literal
a := [3]bool{true, true, false};
// this creates the same array as above, then builds a slice that references it
a := []bool{true, true, false}

// iterate slice with range
for i, v := range a {
    fmt.Printf("index: %d = val: %d\n", i, v)
}
```

#### make

The make function allocates a zeroed array and *returns a slice* that refers to that array:

```go
a := make([]int, 5)  // len(a)=5

// to specify a capacity, pass a third argument to make:
b := make([]int, 0, 5) // len(b)=0, cap(b)=5

b = b[:cap(b)] // len(b)=5, cap(b)=5
b = b[1:]      // len(b)=4, cap(b)=4

```

### Defers

[See more here](https://blog.golang.org/defer-panic-and-recover)
