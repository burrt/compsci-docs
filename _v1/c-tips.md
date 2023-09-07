---
layout: compsci-note
title: C Tips
categories: [language, tips]
description: Some tips and tricks with C
---

## Contents

* [Mallocing by reference](#mallocing-by-reference)
* [Function pointers](#function-pointers)
* [Typedef](#typedef)
* [Indexing a 2D array with pointers](#indexing-a-2d-array-with-pointers)
* [Types](#types)

## Mallocing by reference

```c
int main(int argc, char **argv)
{
    int *buffer;
    alloc_memory(&buffer); // pass by reference
}

// Notice we are applying an additional level of indirection
// We could have simply returned a pointer to the malloc'd
// memory like normally but we can do this via parameters as well
void alloc_memory(int **b)
{
    *b = (int *)malloc(10); // dereferencing gives us the
                            // original pointer
    assert(*b != NULL);
}
```

## Function pointers

Useful for passing functions as parameters to a different function.

```c
// Normal function
int addInt(int n, int m) {
    return n+m;
}

// Define a pointer to a function which receives 2 ints and returns an int.
int (*functionPtr)(int,int);
functionPtr = &addInt;           // Now we can safely point to our function
int sum = (*functionPtr)(2, 3);  // sum == 5

// Passing the pointer to another function is basically the same.
int add2to3( int (*functionPtr)(int, int) )
{
    return (*functionPtr)(2, 3); // function pointer is a parameter to add2to3
}

// this is a function called functionFactory which receives parameter n
// and returns a pointer to another function which receives two ints
// and it returns another int
int (*functionFactory(int n))(int, int)
{
    printf("Got parameter %d", n);
    int (*functionPtr)(int,int) = &addInt;  // func ptr -> &func
    return functionPtr;
}

// But it's much nicer to use a typedef function pointer
// myFuncDef is the name to replace
typedef int (*myFuncDef)(int, int);

// only the parameter and func name is retained
myFuncDef functionFactory(int n)
{
    printf("Got parameter %d", n);
    myFuncDef functionPtr = &addInt; // Alternate is func_ptr = addInt;
    return functionPtr;
}
```

## typedef

```c
// better this way
typedef struct S {} S;

// equivalent
struct S {};
typedef struct S S;
```

## Indexing a 2D array with pointers

```c
    u8 l_matrix[10][20];
    u8 (*matrix_ptr)[20] = l_matrix;

    matrix_ptr[0][1] = ...;
```

## Debugging

```c
void foo ()
{
    // __FILE___ and ___line___ are existing macros
    printf("Debug print: inside %s; at line %d\n", __FILE__, ___line___);
}
```

```c
#include <string.h>
#include <errno.h>

fprintf(stderr, "ERROR: %s\n", strerror(errno));
perror("My error string") // Just use perror(), much easier
```

```c
#define assert(expr) \
            if(!(expr)) \
            { \
                printf("Assertion failure: " #expr); \
                printf(" in %s at line: %d\r\n", __FILE__, __LINE__); \
                __sys_term(); \
            }
```

## Types

* `45U` is an unsigned int constant.
* `45UL` is an unsigned long int.

|Type             |Storage size | Value range                                            |
|-----------------|-------------|--------------------------------------------------------|
|char             |1 byte       |-128 to 127 or <br> 0 to 255                            |
|unsigned char    |1 byte       |0 to 255                                                |
|signed char      |1 byte       |-128 to 127                                             |
|int              |2 or 4 bytes |-32,768 to 32,767 or <br>-2,147,483,648 to 2,147,483,647|
|unsigned int     |2 or 4 bytes | 0 to 65,535  or <br>0 to 4,294,967,295                 |
|short            |2 bytes      |-32,768 to 32,767                                       |
|unsigned short   |2 bytes      |0 to 65,535                                             |
|long             |4 bytes      |-2,147,483,648 to 2,147,483,647                         |
|unsigned long    |4 bytes      | 0 to 4,294,967,295                                     |
|float            |4 bytes      |1.2E-38 to 3.4E+38 (6 decimal places)                   |
|double           |8 bytes      |2.3E-308 to 1.7E+308 (15 decimal places)                |
|long double      |10 bytes     |3.4E-4932 to 1.1E+4932 (19 decimal places)              |
