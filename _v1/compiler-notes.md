---
layout: compsci-note
title: Comilers
categories: [compilers]
description: Some notes on Compilers
---

## Compilers

* [Lexical Analysis](#lexical-analysis)
* [Syntax Analysis](#syntax-analysis)
* [Semantic Analysis](#syntax-analysis)
* [Intermediate Code Generation](#intermediate-code-generation)
* [Code Optimization](#code-optimization)
* [Code Generation](#code-generation)
* [Symbol-Table Management](#symbol-table-management)
* [Grouping of Phases into Passes](#grouping-of-phases-into-passes)

## Overview

*Disclaimer*: these notes will be heavily based on the Dragon Book.

### A Compiler

It is a program that can read a program in one language - *source* language and translate it to an equivalent program in another language - *target* language.

If the target program is an executable machine-language program, it can then be called by the user to process inputs and produce outputs.

```text
# Compiling
source program
      |
      v
+-------------+
|   Compiler  |
+-------------+
      |
      v
target program

# Running
         +--------------+
input -->|Target program|--> output
         +--------------+
```

### An Interpreter

Instead of producing a target program as a translation, it appears to directly execute the operations specified in the source program on the inputs supplied by the user.

```text
source program -->+-----------+
         input -->|Interpreter|--> output
                  +-----------+
```

### Example: Java

A Java source program may first be compiled into an intermediate form called **bytecodes**. The bytecodes can then be interpreted by a virtual machine.

Some Java compilers - *just-in-time* compilers - translates the bytecodes into machine language immediately before they run the intermediate program to process the input.

```text
source program
      |
      v
+-------------+
| Translator  |
+-------------+
      |
      v
intermediate program -->+--------+
               input -->|   VM   |--> output
                        +--------+
```

### Example: Hybrid Compiler

Several other programs may be required to create an executable target program. A source program may be divided into modules store in separate files.

A **preprocessor** program may be entrusted to collect the source program and expand any shorthands e.g. macros, into source language statements.

The *modified* source program is fed into the **compiler**. It can produce assembly-language program as its output because it's easier to output and debug.

The assembly-language program is then processed by an **assembler** that produces *relocatable* machine code as its output.

Large programs are often compiled in pieces so the relocatable machine code may have to be *linked* together with other relocatable object files and library files into the code that actually runs on the machine.

The **linker** resolves external memory addresses, where the code in one file may refer to a location in another file.

The **loader** then puts all of the executable object files into memory for execution.

```text
source program
      |
      v
+--------------+
| Preprocessor |
+--------------+
      |
      v
modified source program
      |
      v
+--------------+
| Compiler     |
+--------------+
      |
      v
target assembly program
      |
      v
+--------------+
| Assembler    |
+--------------+
      |
      v
relocatable machine code
      |
      v
+--------------+
| Linker/Loader|<-library files and relocatable objects
+--------------+
      |
      v
target machine code
```

## Lexical Analysis

The **first** phase of a compiler is called **lexical analysis** or **scanning**.

The lexical analyzer reads the stream of characters making up the source program and groups the characters into meaningful sequences called **lexemes**.

For each lexeme, the lexical analyzer produces an output **token** of the form:

```text
<token-name, attribute-value>

token-name:      abstract symbol used for syntax analysis
attribute-value: points to an entry in the symbol table
```

Example:

| Token  | Token Type     | Lexeme |
|--------|----------------|--------|
| rate_1 | ID             | rate_1 |
| i      | ID             | i      |
| <=     | <=             | <=     |
| while  | while          | while  |
| 100    | INTLITERAL     | 100    |
| 1.1e2  | FLOATLITERAL   | 1.1e2  |
| true   | BOOLEANLITERAL | true   |

The token is then passed to the subsequent phase, syntax analysis.

## Syntax Analysis

## Semantic Analysis

## Intermediate Code Generation

## Code Optimization

## Code Generation

## Symbol-Table Management

## Grouping of Phases into Passes
