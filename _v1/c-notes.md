---
layout: compsci-note
title: C Notes
categories: [language]
description: Some notes on C
order: 20
sitemap: false
---

## Contents

* [Basics](#basics)
  * [printf](#printf)
  * [static](#static)
  * [enum](#enum)
* [Stack & heap](#stack-and-heap)
* [Operator precedence](#operator-precedence)

## Style guide

[I agreed with most of what was said here](https://users.ece.cmu.edu/~eno/coding/CCodingStandard.html#formatting)

Summary:

* 79 column rule (nope...)
* `_` delimiter
* `g_` prefix for globals
* UPPERCASE for `enum`, `#define`

## Basics

```c
// arrays
char buf[2] = "";      // same as: char buf[10] = {0, 0};

char *p1 = "String";  // NOTE: this is read-only
char p2[] = "String";
char p3[7] = "String"; // NULL terminated

// length of an array
int arr[4] = {1, 2, 3};
int num_elements = sizeof(arr)/sizeof(arr[0]);  // total_size/element_size

strncpy(p3, p2, sizeof(p1)-1); // strncpy doesn't auto NULL terminate

// ternary operator
// boolean_expr ? true : false;
int x = (true)
        ? 1
        : 2;
((i < 3) ? i : j) = 7;  // more confusing example up example
(false) ? printf("Always false!\n")
        : printf("Won't reach here ever..\n");
```

### printf

* `%6d`: print as a decimal integer with a width of at least 6 wide.
* `%4f`: print as a floating point with a width of at least 4 wide.
* `%.4f`: print as a floating point with a precision of four characters after the decimal point.
* `%3.2f`: print as a floating point at least 3 wide and a precision of 2.
* `%.10s`:  prints the string, but print only 10 characters of the string.
* `%-10s`: prints the string, but prints at least 10 characters. If the string is smaller “whitespace” is added at the end.

### static

* A `static` variable **inside** a function keeps its value between invocations.
* A `static` **global** variable or a function is "seen" only in the file it's declared in

```c
void foo() {
    int a = 10; static int sa = 10;
    a += 5;
    sa += 5;
    printf("a = %d, sa = %d\n", a, sa);
}

int main() {
    int i;
    for (i = 0; i < 10; ++i)
        foo();
}

/* PRINTS:
a = 15, sa = 15
a = 15, sa = 20
a = 15, sa = 25
*/

int var1;         // has global scope and static allocation
static int var2;  // has file scope and static allocation
```

### enum

```c
// default values are 0, 1..
// to get a string representation, you need to have an
// array of strings for each index - or macro hacks
// the elements must be unique in its scope - can't have
// two 'MON', even if different enums
// UPPERCASE_UNDERSCORE is standard
typedef enum weekday {
    MON, TUES, WED, THURS, FRI, SAT, SUN
} weekday;  // so we don't need to do this: enum weekday day = Mon;

typedef enum boolean {
    TRUE = 1,  // we can assign them values instead
    FALSE = 0  // and they can have the same values
} boolean;

boolean t_f = FALSE;

```

## Stack and Heap

```c
void *foo(int **second_array) {
    // malloc int array[10] in heap like normal
    int *ptr = (int *)malloc(sizeof(int)*10);

    // malloc a second array using the reference passed in
    // note: de-referencing  will point to the original pointer!
    *second_array = (int *)malloc(sizeof(int)*10);

    // casting as (void *) can be useful for allocating
    // memory for 'generic' types
    // you need to remember to free this pointer!
    return (void *)ptr;
}

int main(int argc, char **argv) {
    // your normal stack variables
    // generally there's a stack size limit hence you normally
    // don't declare super large variables here
    // also malloc'ing memory allows it to survive the life cycle
    // of this function - useful for nested functions
    int stack_var = 10;

    int *reference_pointer;  // we want to obtain a array of ints
    foo(&reference_pointer); // so we pass by reference
    free(reference_pointer);

    return 0;
}
```

## Prefix and Postfix operands

* Prefix operator `++x`, returns the value of its operand **after** adding one.
* Postfix operator `x++`, returns the value of its operand **before** adding one.

```c
int i = 10;
int j = ++i;  // j == 11
int k = i++;  // k == 11
```

## Operator precedence

|Precedence | Operator        |Description                           | Associativity|
|-----------|-----------------|--------------------------------------|--------------|
|2          |`a++` `a--`      |Suffix/postfix increment and decrement| Left-Right |
|           |`type()` `type{}`|Functional cast                       |
|           |`a()`            |Function call                         |
|           |`a[]`            |Subscript                             |
|           |`.` `->`         |Member access                         |
|3          |`++a` `--a`      |Prefix increment and decrement        | Right-to-left|
|           |`+a` `-a`        |Unary plus and minus                  |
|           |`!` `~`          |Logical NOT and bitwise NOT           |
|           |`(type)`         |C-style cast                          |
|           |`*a`             |Indirection (dereference)             |
|           |`&a`             |Address-of                            |
|           |`sizeof`         |Size-of<sup>**1**</sup>               |
|           |`new` `new[]`    |Dynamic memory allocation             |
|           |`delete` `delete[]`|Dynamic memory deallocation           |
|4          |`.*` `->* `      |Pointer-to-member                     |Left-to-right|
|5          |`a*b` `a/b` `a%b`|Multiplication, division, and remainder|
|6          |`a+b` `a-b`      |Addition and subtraction              |
|7          |`<<` `>>`        |Bitwise left shift and right shift    |
|8          |`<` `<=`         |For relational operators `<` and `≤` respectively|
|           |`>` `>=`         |For relational operators `>` and `≥` respectively|
|9          |`==` `!=`        |For relational operators `=` and `≠` respectively|
|10         |`a&b`            |Bitwise AND                           |
|11         |`^`              |Bitwise XOR (exclusive or)            |
|12         |`\|`             |Bitwise OR (inclusive or)             |
|13         |`&&`             |Logical AND                           |
|14         |`\|\|`           |Logical OR                            |
|15         |`a ? b : c`      |Ternary conditional<sup>**2**</sup>   |Right-to-left|
|           |`throw`          |throw operator                        |
|           |`=`              |Direct assignment (provided by default for C++ classes)  |
|           |`+=` `-=`        |Compound assignment by sum and difference                |
|           |`*=` `/=` `%=`   |Compound assignment by product, quotient, and remainder  |
|           |`<<=` `>>=`      |Compound assignment by bitwise left shift and right shift|
|           |`&=` `^=` `\|=`  |Compound assignment by bitwise AND, XOR, and OR          |
|16         |`,`              |Comma                                  |Left-to-right    |

* **<sup>1</sup>**: The operand of `sizeof` can't be a C-style type cast: the expression `sizeof (int) * p` is unambiguously interpreted as `(sizeof(int)) * p`, but **not** `sizeof((int)*p)`.
* **<sup>2</sup>**: The expression in the middle of the conditional operator (between ? and :) is parsed as if **parenthesized**: its precedence relative to `?:` is **ignored**.

### Associativity

Operators that have the same precedence are bound to their arguments in the direction of their associativity.

For example the expressions:

* `a = b = c` is parsed as `a = (b = c)` and **not** as `(a = b) = c` because of *right-to-left* associativity of assignment.
* `a + b - c` is parsed as `(a + b) - c` and **not** as `a + (b - c)` because of *left-to-right* associativity of addition and subtraction.

Associativity specification is redundant for unary operators and is only shown for completeness: unary prefix operators always associate right-to-left `(delete ++*p is delete(++(*p)))` and unary postfix operators always associate left-to-right `(a[1][2]++ is ((a[1])[2])++)`.

Note that the associativity is meaningful for member access operators, even though they are grouped with unary postfix operators: `a.b++` is parsed `(a.b)++` and **not** `a.(b++)`.