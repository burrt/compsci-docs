---
layout: compsci-note
title: C# Notes
categories: [language]
description: Some notes on C#
order: 20
sitemap: false
---

# C# Revision

## Links

[MS C# Guide](https://docs.microsoft.com/en-us/dotnet/csharp/index)

## Contents

* [Terms](#terms)
* [Types](#types)
  * [Struct](#struct)
  * [Enum](#enum)
  * [Implicit types](#implicit-types)
  * [Dynamic](#dynamic)
* [Expressions](#expressions)
  * [Lambda expressions](#lambda-expressions)
* [Operators](#operators)
* [Equality](#equality)
* [Delegates](#delegates)
* [Exceptions](#exceptions)
* [Misc examples](#misc-examples)
* [Classes](#classes)
  * [Accessibility](#accessibility)
  * [Parameters](#parameters)
  * [Methods](#methods)
  * [Abstract](#abstract)
  * [Partial](#partial)
  * [Property](#property)
  * [Inheritance & Polymorphism](#inheritance-and-polymorphism)
  * [Constructors](#constructors)
* [Interfaces](#interfaces)
* [Static](#static)
* [Enumerating](#enumerating)
* [Indexers](#indexers)
* [Generics](#generics)
* [LINQ](#linq)
* [Namespaces](#namescapes)
* [Null](#null)
* [Async](#async)

## Style guide

* Use `PascalCasing` for all identifies **except** parameters which use `camelCasing`. Also `_privateMemberCamelCase`.

### Do Not's

* Avoid underscores
* Avoid abbreviations and acronyms

## Terms

### Variance

See more [here from the MS Docs](https://docs.microsoft.com/en-us/dotnet/standard/generics/covariance-and-contravariance).

#### Covariance

Allows interface methods to have more derived **return** types that that defined by the generic type parameters.

#### Contravariance

Contravariance allows interface methods to have argument types that are less derived than that specified by the generic parameters.

#### Variant

A generic interface that has covariant or contravariant generic type parameters is called variant.

## Types

### Value types

* Simple:
  * `sbyte`, `short`, `int`, `long`
  * `byte`, `ushort`, `uint`, `ulong`
  * `char` - UTF-16
  * `float`, `double`
  * `decimal` - high precision
  * `bool`
* Enum types
  * User-defined types of the form `enum E {...}`
* Struct types
  * User-defined types of the form `struct S {...}`
* Nullable value types
  * Extensions of all other value types with a `null` value

### Reference types

* Class types
  * Ultimate base class of all other types: `object`
  * Unicode strings: `string` - UTF-16
  * User-defined types of the form `class C {...}`
* Interface types
  * User-defined types of the form `interface I {...}`
* Array types
  * Single and multi-dimensional, for example, `int[]` and `int[,]`
* Delegate types
  * User-defined types of the form delegate `int D(...)`

### Struct

* They are **value** types - pass by value to methods hence field changes don't persist
* Can implement interfaces, can be used as a nullable type and assigned `null`
* Does not support `protected` since it cannot inherit classes etc.
* Fields can't be initialised on declaration unless `static` or `const`
* Generally less expensive than classes and used for small objects/entities

```cs
public struct CoOrds
{
    public int x, y;
    // You can't have an empty constructor, all fields must be initialised
    public CoOrds(int p1, int p2)
    {
        x = p1;
        y = p2;
    }
}

CoOrds point = new CoOrds();
// You can omit the new keyword since structs are value types
// All fields must be initialised before using
CoOrds point = new CoOrds(1, 1);
CoOrds point;
point.x = 1;
point.y = 1;
```

Remember that you can override the `ToString()` method since everything inherits `object`.

### Enum

They are converted to numeric literals at compile time hence if you refer to enums or constants from external sources, this may cause potential issues.
They can be of the following types: `byte`, `sbyte`, `short`, `ushort`, `int`, `uint`, `long`, or `ulong`.

```cs
enum Day : byte {Sat=1, Sun, Mon, Tue, Wed, Thu, Fri};
int y = (int)Day.Fri;  // Explicit cast is necessary

enum Range : long { Max = 2147483648L, Min = 255L };
```

You can do more interesting things to print the string value and combinations of enums with [System.FlagsAttribute](https://docs.microsoft.com/en-us/dotnet/api/system.flagsattribute?view=netframework-4.7.2).

### Implicit types

* Make the compiler infer the type from the RHS expression using `var`
* Can only be used when a local variable is declared and initialised in the same statement; the variable cannot be initialised to null, or to a method group or an anonymous function
* Cannot be used on fields at class scope

```cs
// a is compiled as int[]
var a = new[] { 0, 1, 2 };

// anon is compiled as an anonymous type
var anon = new { Name = "Terry", Age = 34 };
anon.Name;

foreach(var item in list) {...}

// More interesting with LINQ
var words = new[] { "aPPLE", "BlUeBeRrY", "cHeRry" };
var upperLowerWords =
    from w in words
    select new { Upper = w.ToUpper(), Lower = w.ToLower() };

// Execute the query
foreach (var ul in upperLowerWords)
{
    Console.WriteLine("Uppercase: {0}, Lowercase: {1}", ul.Upper, ul.Lower);
}
```

### Boxing

Boxing is the process of converting a value type to the type `object` or to any interface type implemented by this value type. When the CLR boxes a value type, it wraps the value inside a `System.Object` and stores it on the managed **heap**. Unboxing extracts the value type from the object. Boxing is implicit; unboxing is explicit. This comes at a large performance cost at runtime.

```cs
int i = 123;
// The following line boxes i.
object o = i;

//The object o can then be unboxed and assigned to integer variable i:
o = 123;
i = (int)o;  // unboxing
```

### Dynamic

These are reference types that are **not** checked at compile time so expressions have limited validity checks. Dynamic also behaves like `object` in cases like `somevar is dynamic` will always return `true` unless `somevar` is `null`.

```cs
static void Main(string[] args)
{
    ExampleClass ec = new ExampleClass();
    // The following call to exampleMethod1 causes a compiler error
    // if exampleMethod1 has only one parameter. Uncomment the line
    // to see the error.
    //ec.exampleMethod1(10, 4);

    dynamic dynamic_ec = new ExampleClass();
    // The following line is not identified as an error by the
    // compiler, but it causes a run-time exception.
    dynamic_ec.exampleMethod1(10, 4);

    // The following calls also do not cause compiler errors, whether
    // appropriate methods exist or not.
    dynamic_ec.someMethod("some argument", 7, null);
    dynamic_ec.nonexistentMethod();
}
```

### Nested types

This is more seen as nested classes. You can have a nested class which can access all the members of the parent class.

```cs
public class Container
{
    public class Nested
    {
        private Container parent;  // needs to be initialised

        // default constructor
        public Nested()
        {}
        public Nested(Container parent)
        {
            this.parent = parent;
        }
    }
}
```

## Expressions

[More here](https://docs.microsoft.com/en-us/dotnet/csharp/tour-of-csharp/expressions).

Some interesting ones:

* `new T(...)`: Object and delegate creation
* `new T(...){...}`: Object creation with initializer
* `new {...}`: Anonymous object initializer
* `new T[...]`: Array creation
* `typeof(T)`: Obtain Type object for T
* `checked(x)`: Evaluate expression in checked context
* `unchecked(x)`: Evaluate expression in unchecked context
* `default(T)`: Obtain default value of type T
* `delegate {...}`: Anonymous function (anonymous method)
* `x is T`: Return `true` if `x` is a `T`, `false` otherwise
  * Checks for inheritance of objects - e.g. downcasting isn't valid unless polymorphism
* `x as T`: Return `x` typed as `T`, or `null` if `x` is not a `T`
  * Same as casting but doesn't throw an exception if invalid, returns `null` instead
* `x ?? y`: Evaluates to `y` if `x` is `null`, to `x` otherwise
* `x ? y : z`: Evaluates `y` if `x` is `true`, `z` if `x` is `false`
* `(T x) => y`: Anonymous function (lambda expression)

### Lambda expressions

A horrible way to do nothing:

```cs
delegate void delegateFunc();
private static void Main()
{
    delegateFunc f = () =>
    {
        Console.WriteLine("Delegate & lambda function");
        Console.WriteLine("Exiting delegate & lambda function");
    }
    f();
}
```

Other maybe more useful e.g. in LINQ:

```cs
// Say in a Class
public override string ToString() => $"{fname} {lname}".Trim();
public Point Move(int dx, int dy) => new Point(x + dx, y + dy);

// The Enumerable.Where has two methods overloads
var shortDigits = digits.Where((digit, index) => digit.Length < index);
IEnumerable<string> query = fruits.Where(fruit => fruit.Length < 6);
```

## Operators

[Full list from MS docs](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/).

## Some interesting ones

### Null coalescing

```cs
// returns the left-hand operand if the operand is not null
// otherwise it returns the right hand operand.
Person p = FooBar ?? DeadBeef;
```

### Null conditional

```cs
// used to test for null before performing a member access
int? length = customers?.Length; // null if customers is null
Customer first = customers?[0];  // null if customers is null
int? count = customers?[0]?.Orders?.Count();  // null if customers, the first customer, or Orders is null
```

### Ternary operator

```cs
condition ? first_expression : second_expression;  // right-associative
int x = (1 == 1) ? 2 : 3;
```

### Bit operations

```cs
// Bitwise XOR
int x = 1 ^ 0;  // XOR
int x = 1 | 0;  // OR
int x = ~1;     // NOT
```

## Equality

Make sure you understand that you have **value** and **reference** types for equality.

### == Operator

Most commonly used for equality but doesn't always behave as expected e.g. for reference types, it will default to reference equality if an overloaded `==` operator method is not found for the type.

```cs
// overload operator *
public static Fraction operator *(Fraction a, Fraction b)
{
    return new Fraction(a.num * b.num, a.den * b.den);
}
```

### ReferenceEquals

If you only want to compare if the two instances are equal or point to the same instance, use the `static` method `ReferenceEquals`. Remember, because it is a static method, you cannot override it like virtual methods.

```cs
using System;
Test a = new Test() { Num = 1, Str = "Hi" };
Test b = new Test() { Num = 1, Str = "Hi" };

// False
Console.WriteLine("ReferenceEquals(a, b) = {0}",
    System.Object.ReferenceEquals(a, b));
b = a;
// True
Console.WriteLine("ReferenceEquals(a, b) = {0}",
    System.Object.ReferenceEquals(a, b));
```

### Value types equality

However, sometimes you want to have a custom definition of equality for your **value** types e.g. `struct`

1. Implement the interface `System.IEquatable<T>` which provides **type-specific** equality!
2. Override the virtual method of `Object.Equals(Object)` - **no** type safety here
    * This usually just calls your type-specific implementation
3. Implement the `==` and `!=` operator methods (call type-specific equality)
4. Implement `GetHashCode()` method

```cs
// Generic Object equality
public override bool Equals(object obj)
{
    return this.Equals(obj as TwoDPoint);
}

// Type-specific equality
public bool Equals(TwoDPoint p)
{
    // If parameter is null, return false.
    if (Object.ReferenceEquals(p, null))
    {
        return false;
    }

    // Optimization for a common success case.
    if (Object.ReferenceEquals(this, p))
    {
        return true;
    }

    // If run-time types are not exactly the same, return false.
    if (this.GetType() != p.GetType())
    {
        return false;
    }

    // Return true if the fields match.
    // Note that the base class is not invoked because it is
    // System.Object, which defines Equals as reference equality.
    return (X == p.X) && (Y == p.Y);
}
```

### Reference type equality

You have to care about inheritance when dealing with reference types i.e. in your **base** class, you perform the standard checks, and then in your **derived** class, you call the base class check and then call any additional checks as necessary.

Remember that the static `object.Equals(object lhs, object rhs)` method for reference types will call any overriden virtual method of `object.Equals(object obj)`.

#### NOTE

```cs
// The == operator will never call your overriden virtual method
// of object.Equal() so it will always do a reference check
public CheckIfEqual(object o1, object o2)
{
    return o1 == o2;
}
```

#### String equality

* Use `StringComparison.Ordinal` or `StringComparison.OrdinalIgnoreCase` for comparisons as your safe default for culture-agnostic string matching.
* Use comparisons with `StringComparison.Ordinal` or `StringComparison.OrdinalIgnoreCase` for better performance.
* Use the non-linguistic `StringComparison.Ordinal` or `StringComparison.OrdinalIgnoreCase` values instead of string operations based on `CultureInfo.InvariantCulture` when the comparison is linguistically irrelevant (symbolic, for example).
* Do **not** use string operations based on StringComparison.InvariantCulture in most cases. One of the few exceptions is when you are persisting linguistically meaningful but culturally agnostic data.

## Delegates

* These are basically function pointer equivalent

```cs
// declare this is in some namespace
public delegate int DelegateName(int firstArg, int secondArg);

// now you can instantiate the delegate function in some constructor for example
public class bar
{
    DelegateName FunctionPtr;
    public bar()
    {
        FunctionPtr = new DelegateName(foo);
        // alternatively you can do this?
        // FunctionPtr = foo;
        // we can call/(de)attach multiple delegates 
        //   - can no longer reset FunctionPtr
        // FunctionPtr += foo2
        // FunctionPtr -= foo2
    }

    // here's a function
    public int foo(int x, y)
    {
        return x + y;
    }

    // now we can run the delegate in a property for example
    private int _sum = 0;
    public int PropertyNameSum
    {
        get
        {
            return _sum;
        }
        set
        {
            _sum = FunctionPtr(0, value);
        }
    }
}
```

### Func

Another form is the `Func<T, TResult> Delegate`, you can have up to 16 input types e.g. `Func<T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,TResult>` and an example usuage of this with lambda expression:

```cs
// Declare a Func variable and assign a lambda expression to the variable.
Func<string, string> selector = str => str.ToUpper();

// Create an array of strings.
string[] words = { "orange", "apple", "Article", "elephant" };
// Query the array and select strings according to the selector method.
IEnumerable<string> aWords = words.Select(selector);
```

This is useful since you can pass it in as a method parameter without declaring a custom delegate.

```cs
// They can also be assigned to an expression/statement lambdas
Func<string, string, int> callback = (s1, s2) => return 1;

int (Func<string, string, int> callbackasparam)
{
    return callback("Foo", "Bar");
}
```

### Expression lambdas

```cs
// (input-parameters) => expression

(int x, string s) => s.Length > x;
() => Console.WriteLine("Empty parameter list");

// You can also use method decorators
async innerCancellationToken => await ExecuteAsync(innerCancellationToken);
```

### Statement lambdas

You can have statements in the lambdas but do restrict the number.

```cs
delegate bool EqualityComparator(string s1, string s2);

EqualityComparator = (s1, s2) =>
{
    if (s1 == null)
        throw ArgumentNullException(nameof(s1));
    if (s2 == null)
        throw ArgumentNullException(nameof(s2));
    return string.Equals(s1, s2);
}
```

### Action

If the delegate has no return value i.e. `void`, you can use `Action<T>`

```cs
Action<string> print = Console.WriteLine;
Action<string, string> concat = (s1, s2) => Console.WriteLine(${s1}{s2});
```

### Closure

A closure is basically a block of code (lambda/anonymous function) that can be executed at a later time but maintains the environment which it was first created. This allows it to continue reference and hold state of those variables in the containing method.

Basically the C# compiler will recognize the closure being created and will promote the local variables into a compiler generated class which the delegate can be invoked and maintain and use the local variables. This means if you were to create a closure on a **disposable** or **mutatable** object, you can easily hit non-deterministic behaviour with `NullReferenceException`.

```cs
static void Main(string[] args)
{
    var inc = GetAFunc();
    Console.WriteLine(inc(5));
    Console.WriteLine(inc(6));
}

public static Func<int,int> GetAFunc()
{
    var myVar = 1;
    Func<int, int> inc = delegate(int var1)
    {
        myVar = myVar + 1;
        return var1 + myVar;
    };

    return inc;
}

// 7
// 9
```

## Exceptions

```cs
try
{
    int x = 10 / 0;
}
catch (DivideByZero ex)
{
    Console.WriteLine("Trying to divide by zero");
}
catch (InvalidOperation ex)
{
}
```

### Catching multiple exceptions

```cs
try
{
    int x = 10 / 0;
}
catch (Exception ex)
    when (ex is InvalidOperation || ex is NullPointerException)
{
    Console.WriteLine($"Hit exception {nameof(ex)}");
}
```

### Creating your own exceptions

It's important to implement all constructors when creating your exception. The [MS Docs](#https://docs.microsoft.com/en-us/dotnet/standard/exceptions/best-practices-for-exceptions) have a bit more information you can read as well.

```cs
[Serializable]
public class ToolNotSupportedException : Exception
{
    public ToolNotSupportedException()
        : base()
    {
    }

    public ToolNotSupportedException(string message)
        : base(message)
    {
    }

    public ToolNotSupportedException(string message, Exception inner)
        : base(message, inner)
    {
    }

    protected ToolNotSupportedException(
        SerializationInfo info,
        StreamingContext context)
        : base(info, context)
    {
    }
}
```

## Misc examples

```cs
// foreach
static void ForEachStatement(string[] args)
{
    foreach (string s in args)
    {
        Console.WriteLine(s);
    }
}

// goto
static void GoToStatement(string[] args)
{
    int i = 0;
    goto check;
    loop:
    Console.WriteLine(args[i++]);
    check:
    if (i < args.Length)
        goto loop;
}

// yield
static IEnumerable<int> Range(int from, int to)
{
    for (int i = from; i < to; i++)
    {
        yield return i;
    }
    yield break;
}
static void YieldStatement(string[] args)
{
    foreach (int i in Range(-10,10))
    {
        Console.WriteLine(i);
    }
}

// try, catch, throw
static double Divide(double x, double y)
{
    if (y == 0)
        throw new DivideByZeroException();
    return x / y;
}
static void TryCatch(string[] args)
{
    try
    {
        if (args.Length != 2)
        {
            throw new InvalidOperationException("Two numbers required");
        }
        double x = double.Parse(args[0]);
        double y = double.Parse(args[1]);
        Console.WriteLine(Divide(x, y));
    }
    catch (InvalidOperationException e)
    {
        Console.WriteLine(e.Message);
    }
    finally
    {
        Console.WriteLine("Good bye!");
    }
}

// checked
static void CheckedUnchecked(string[] args)
{
    int x = int.MaxValue;
    unchecked
    {
        Console.WriteLine(x + 1);  // Overflow
    }
    checked
    {
        Console.WriteLine(x + 1);  // Exception
    }
}

// lock
class Account
{
    decimal balance;
    private readonly object sync = new object();
    public void Withdraw(decimal amount)
    {
        lock (sync)
        {
            if (amount > balance)
            {
                throw new Exception(
                    "Insufficient funds");
            }
            balance -= amount;
        }
    }
}

// using - auto garbage collection like with in Python
using (TextWriter w = File.CreateText("test.txt"))
{
    w.WriteLine("Line one");
    w.WriteLine("Line two");
}
```

## Classes

**Members** of a class can be `static` or `instance` members. These include:

* Constants
  * Constant values associated with the class
* Fields
  * Variables of the class
* Methods
  * Computations and actions that can be performed by the class
* Properties
  * Actions associated with reading and writing named properties of the class
  * `set {...}`, `get {...}`
* Indexers
  * Actions associated with indexing instances of the class like an array
* Events
  * Notifications that can be generated by the class
  * `EventHandler`
* Operators
  * Conversions and expression operators supported by the class
* Constructors
  * Actions required to initialize instances of the class or the class itself
* Finalizers
  * Actions to perform before instances of the class are permanently discarded
  * Not recommended since C# has an automatic garbage collection
* Types
  * Nested types declared by the class

### Accessibility

* `public`
  * Access not limited
* `protected`
  * Access limited to this class or classes derived from this class
* `internal`
  * Access limited to the current assembly (.exe, .dll, etc.)
* `protected internal`
  * Access limited to the containing class **or** classes derived from the containing class
* `private`
  * Access limited to this class
* `private protected`
  * Access limited to the containing class **or** classes derived from the containing type within the same assembly

#### Defaults

* `private`
  * `class` members
  * `struct` members
  * `delegate` within a nested namespace
* `internal`
  * `class`
  * `struct`
  * `interfaces`
  * `delegate` within a namespace
* `private`
  * `interface` members

#### Sealed

* They cannot be used as a base class - prevents derivation and therefore cannot be an `abstract` class
* You can use this on a `virtual` method to negate the virtual aspect of a member for any further derived class

```cs
public class D : C
{
    public sealed override void DoWork() { }
}
```

### Base classes

```cs

public class Point
{
    public int x, y;
    public Point(int x, int y)
    {
        this.x = x;
        this.y = y;
    }
}
public class Point3D: Point
{
    public int z;
    public Point3D(int x, int y, int z) :
        base(x, y)
    {
        this.z = z;
    }
}

// up-casting works as intended
Point a = new Point(10, 20);
Point b = new Point3D(10, 20, 30);
```

### Parameters

Like D, it supports both **value and reference parameters**. Value parameters means that the arguments are initialised as local variables, reference parameters `ref` are not!

#### Reference parameter

```cs
using System;
class RefExample
{
    static void Swap(ref int x, ref int y)
    {
        int temp = x;
        x = y;
        y = temp;
    }
    public static void SwapExample()
    {
        int i = 1, j = 2;
        Swap(ref i, ref j);
        Console.WriteLine($"{i} {j}");    // Outputs "2 1"
    }
}
```

#### Out parameter

```cs
using System;
    class OutExample
    {
        static void Divide(int x, int y, out int result, out int remainder)
        {
            result = x / y;
            remainder = x % y;
        }
        public static void OutUsage()
        {
            Divide(10, 3, out int res, out int rem);
            Console.WriteLine("{0} {1}", res, rem);	// Outputs "3 1"
        }
    }
}
```

#### Parameter array

This is the equivalent of `args*` in Python. You can use this to pass an optional number of arguments to a funciton.

```cs
public class Console
{
    public static void Write(string fmt, params object[] args) { }
    public static void WriteLine(string fmt, params object[] args) { }
    // ...
}

Console.WriteLine("x={0} y={1} z={2}", x, y, z);
// equivalent
string s = "x={0} y={1} z={2}";
object[] args = new object[3];
args[0] = x;
args[1] = y;
args[2] = z;
Console.WriteLine(s, args);
```

### Arguments

```cs
// Named arguments can be used for convenience and order doesn't matter
// but positional arguments must be first
PrintOrderDetails(orderNum: 31, productName: "Red Mug", sellerName: "Gift Shop");

static void PrintOrderDetails(
    string sellerName,
    int orderNum,
    string productName)

// Optional arguments
public void ExampleMethod(
    int required,
    string optionalstr = "default string",
    int optionalint = 10,
    int optionintagaon = default(int))
```

### Methods

Remember that `static` methods **cannot** access instance methods while instance methods can access both since `static` methods belong to the class.

* Virtual
  * `virtual` modifier
  * *run-time* type of instance is determines the actual method implementation
  * these methods **can** be modified in a derived class
  * you **cannot** use these modifiers with virtual methods: `static`, `abstract`, `override`
* Non-virtual
  * default method types
  * *compile-time* type of instance is determines the actual method implementation
* Abstract
  * they are `virtual` methods with **no** implementation and can only belong in an `abstract` class
  * they **must** be overridden in a non-abstract derived class

A basic use case:

```cs
using System;
using System.Collections.Generic;
public abstract class Expression
{
    public abstract double Evaluate(Dictionary<string,object> vars);
}

public class Constant: Expression
{
    double value;
    public Constant(double value)
    {
        this.value = value;
    }
    // overriding abstract methods in a derived class is mandatory
    public override double Evaluate(Dictionary<string,object> vars)
    {
        return value;
    }
}
```

Example of overriding a virtual method:

```cs
public class Base
{
    public virtual void Foo()
    {
        Console.WriteLine("base");
    }
}

public class Derived : Base
{
    public override void Foo()
    {
        Console.WriteLine("derived");
    }
}
```

### Abstract

* Can contain partial implementations of a class - thus **cannot** be instantiated
* An `abstract` class **must** provide implementation for all interface members
* Often paired with `override` and `virtual` - actually abstract methods implicitly virtual
* Remember; an `abstract` method has **no** implementation but an `abstract` class can have virtual or non-virtual methods
* `abstract` methods can only exist in `abstract` classes
* If a class derives from an `abstract` class, check permissions e.g. `private` -> `protected`
* **You can only inherit from a single `abstract` class**

For `abstract` methods, you can couple this with `override` in a derived class to override a `virtual` method with an `abstract` method.

```cs
public class D
{
    public virtual void DoWork(int i)
    {
        // Original implementation.
    }
}

public abstract class E : D
{
    public abstract override void DoWork(int i);
}

public class F : E
{
    public override void DoWork(int i)
    {
        // Force new implementation.
    }
}
```

### Partial

You can split class implementations using `partial` but they must be in the same `namespace`.
Good thing namespaces can be split across multiple files as well.
It is also applicable to `struct` and `interface` which is a bit more relevant.

```cs
// Foo.cs
namescape ns
{
    public partial PartClass
    {
        public void Foo() {}
    }
}

// Bar.cs
namescape ns
{
    public partial PartClass
    {
        public void Bar() {}
    }
}

partial struct S1
{
    void Struct_Test() { }
}

partial struct S1
{
    void Struct_Test2() { }
}
```

This is also applicable to methods where the method can be implemented in a different file. This is quite confusing and it's better to use interfaces or abstract classes.

### Property

These are members that are special methods called accessors. They can be either or both `get` and `set` accessors

```cs
class TimePeriod
{
    // We can use a default property
    public int Day {get; set; }
    public double Hours
    {
        // We can use lambda expressions
        // We are implicitly setting as read-write
        get => return seconds / 3600;
        set
        {
            if (value < 0 || value > 24)
                throw new ArgumentOutOfRangeException($"Invalid value");
        }
    }
}
```

Other misc.

```cs
// abstract modifier forces the derived class to implement it
public abstract int MyIntProperty
{
    get;  // Read-only since isn't declared
}

// Restrict access to the set accessor
// When inheriting or interface implementation, access level
// must be consistent and respected
public override int TestProperty
{
    protected set
    {
        name = value;
    }
}
```

We can also use explicit interface implementation if a class were to implement multiple interfaces with name collisions e.g.

```cs
public interface IEmployee
{
    string Name {get; set;}
}

// If it were to implement IMedicalRecord as well
// We can also implement IMedicalRecord.Name
public class Employee : IEmployee
{
    private string _name;
    string IEmployee.Name
    {
        get => _name;
        set => _name = value;
    }
}
```

### Inheritance and Polymorphism

You can use the usual `virtual` and `override` for inheritance and Polymorphism like normal however even if you upcast, the method being called will be from the derived class.

You can avoid using `virtual` by using `new` instead but it will **no** longer call the derived method when upcasting.

```cs
public class BaseClass
{
    public void DoWork()
    {
        Console.WriteLine("In BaseClass do work");
    }

    // Can be overridden multiple times with inheritance
    public virtual void DoWorkNormal()
    {
        Console.WriteLine("In Derived do work");
    }
}

public class Derived : BaseClass
{
    // If you upcast for example:
    // D d = D();
    // B b = (B)d;
    // b.DoWork()  // "In BaseClass do work"
    public new void DoWork()
    {
        Console.WriteLine("In Derived do work");
    }

    // You normal upcast with polymorphism
    // b.DoWork()  // "In BaseClass do work"
    public override void DoWorkNormal()
    {
        // You can also access base class methods
        // base.DoWorkNormal();
        Console.WriteLine("In Derived do work");
    }
}
```

Using the `new` keyword tells the compiler that your definition hides the definition that is contained in the base class. This is the **default** behavior.

Method override and selection can get a little more confusing when you have method overloading. For example:

```cs
public class Derived : Base
{
    public override void DoWork(int param) { }
    public void DoWork(double param) { }
}

Derived d = new Derived();

d.DoWork(val);  // Calls DoWork(double)
((Base)d).DoWork(val);  // Calls DoWork(int) on Derived.
```

Reasoning:

* Because the variable `val` can be converted to a `double` implicitly, the C# compiler calls `DoWork(double)` instead of `DoWork(int)`.
* Also because the `DoWork(int)` is an overridden method, it **isn't** considered as declared on a class - they are new implementations of a method declared on a base class. Thus the compiler will first try to make the call on methods compatible with the versions of `DoWork` originally declared in `Derived`.
* There are two ways to avoid this.
  * First, avoid declaring new methods with the same name as virtual methods.
  * Second, you can instruct the C# compiler to call the virtual method by making it search the base class method list by casting the instance of `Derived` to `Base`. Because the method is virtual, the implementation of `DoWork(int)` on `Derived` will be called.
* This behaviour for the `new` modifier is applicable to properties as well

### Constructors

You can control the base class constructor when the derived class constructor is called. This can be useful for constructor reuse. You can also call multiple constructors of `this` and avoid duplication.

```cs
public class BaseClass
{
    // BaseClass requires an integer argument
    public BaseClass(int i) {}
}

public class Derived : BaseClass
{
    // Here you need to pass an integer to the BaseClass constructor
    // otherwise you will have a compile error
    // public Derived() : base(10)
    // { }

    // Instead of the above, you can do constructor reuse
    // And have more flexibility
    public Derived() : this(10)
    { }
    public Derived(int i) : base(i)
    { }
}
```

You can have `private` constructors and this is common to restrict default constructors. This doesn't prevent you from declaring additional public constructors. It can be used to enforce a particular pattern, singleton etc.

We can also have something called "copy" constructors where you copy all the state of an instance to generate a new instance based off it. This simply saves writing a separate function for getting and setting state.

```cs
class Person
{
    // Copy constructor
    public Person(Person previousPerson)
    {
        Name = previousPerson.Name;
        Age = previousPerson.Age;
    }
    ...
}

// Trivial example but the state could be must more complicated
// and tedious, hence is applicability
Person person1 = new Person("George", 40);
Person person2 = new Person(person1);
person2.Name = "New Person's name";
```

### Finalises

You can cleanup objects or resources by using:

* `Dispose`
* `finally`
* `using`

```cs
// They are not inherited and are called automatically
// They are put in the Finalize queue for the garbage collector
// And derived classes they are recursively cleaned up
public class Car
{
    ~Car()
    {
        Console.WriteLine("Destructor, can only have one per class");
    }
}
```

You don't want to use the `Dispose` method unless you know what you're doing. Read more about it:

* [Cleaning Up Unmanaged Resources](https://docs.microsoft.com/en-us/dotnet/standard/garbage-collection/unmanaged)
* [Garbage Collection](https://docs.microsoft.com/en-us/dotnet/standard/garbage-collection/)

## Interfaces

* Can **only** contain `abstract` methods and are **all not implemented**
* Can contain: methods, properties, events, indexers
  * Methods are default `public` but can be `abstract`
* Cannot contain: constants, fields, operators, instance constructors, finalizers, or types
* If you are inheriting a base class and also implementing an interface, inheritance comes first
* Interface members are automatically `public`, and they can't include any access modifiers. Members also can't be `static`

### Explicit interface

You can have an **explicit** method in an interface where the method is only called if we are **programming against the interface**. For example:

```cs
interface FooInterface
{

    string FooInterface.save()
    {
        Console.WriteLine("FooInterface save()");
    }
}

public class BarClass : FooInterface
{
}

// Somewhere else
BarClass bar = new BarClass();
bar.save()  // COMPILE ERROR

FooInterface bar = new BarClass();
bar.save()  // "FooInterface save()"
```

## Static

We can use `static` constructors to initialise static objects e.g. `readonly` members at compile time and is only run at most once. They also run before any instance constructors and the user cannot access it directly nor control when they are run.

```cs
public class Adult : Person
{
   private static int minimumAge;

   public Adult(string lastName, string firstName) : base(lastName, firstName)
   { }

   // You can use a lambda expression here
   static Adult()
   {
      minimumAge = 18;
   }

   // Remaining implementation of Adult class.
}
```

You can have static classes which can be useful to contain just `static` or `const` members like the `Math` class.

```cs
public static class TemperatureConverter
{
    // Have some useful methods that doesn't need to belong to an instance
    public static double CelsiusToFahrenheit(string temperatureCelsius) {}
    public static double FahrenheitToCelsius(string temperatureFahrenheit) {}
}
```

## Enumerating

If you want an object e.g. your class to be enumerable, you can derive a class that implements the `IEnumerable` or implemented the following methods:

* `public IEnumerator GetEnumerator()`
* `public bool MoveNext()`
* `public void Reset()`
* `public object Current` - if you don't implement the interface, you can return a more specific object
* You need to at least implement the `GetEnumerator` method, the others will be automatically generated

You can also define a method that returns an `IEnumerable` and contains the `yield return` keywords.

## Indexers

This allows you to index an object without creating an array of objects. They can be overloaded and have more than one parameter e.g. multi-dimensional arrays. The indexer doesn't even need to contain an internal array, you could use it to compute some value based on the index. There are some differences with properties that the [MS docs describe](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/indexers/comparison-between-properties-and-indexers).

```cs
// We can optionally declare an indexer in an interface
// much like properties
interface IIndexer<TType>
{
    TType this[int i] { get; set; }
}

class IndexedClass<TType> : IIndexer
{
    private TType[] InternalArray;
    public IndexedClass(int arraySize = 10)
    {
        InternalArray = new TType[arraySize];
    }

    // Indexes are similar to properties
    public TType this[int i]
    {
        get { return this.InternalArray[i]; }

        // You can have a read-only indexer as well and control the conditions
        // in the new method
        set => this.InternalArray[i] = value;
    }
}
```

## Events

They are a way of support subscribers and publishers model.

## Generics

Too much to cover about generics, [see the MS docs for information](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/generics/)


Generics at run time are actually optimised so there is instance reuse for reference classes (references have the same value - pointers). This is slightly less optimised for value types as a specialised version of the class is initialised per value type and then reused.

## LINQ

Language-Integrated Query is to have a common query expression that is compatible with common data sources or even structures.

The query itself doesn't load the data (filtered/unfiltered) into memory, it just stores the query for **deferred/lazy execution** - this is similar to generators in Python.

It has many keywords that are very SQL like:

* `from`, `where`, `select` - called in this order
* `group` - `group student by student.Last[0]`
  * You can use this to create groups and iterate over these groups of `IGrouping<>`
* `into` - use as an alias for a `group` for example
* `orderby`, `ascending`, `descending`
* `join`
* `let` - used for sub-expression/queries
* `on`
* `equals`
* `by`
* `in`
* Read more from [the MS docs Query Keywords](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/query-keywords)

It's important to know that you can use either **query expression** and **method-based query** for the same result. However, some queries must be method-based so it is important that you are familiar with both options. You can also use `var` to let the compiler infer types however it is generally better to explicitly define types for clarity.

Queries can also return anonymous types e.g. `... select new { name =  cust.Name, phone = cut.Phone};`, here the use of `var` is imperative.

```cs
int[] numbers = { 5, 10, 8, 3, 6, 12};

// Query syntax:
IEnumerable<int> numQuery1 =
    from num in numbers
    where num % 2 == 0
    orderby num
    select num;

// Method syntax:
IEnumerable<int> numQuery2 = numbers
    .Where(num => num % 2 == 0)
    .OrderBy(n => n);

foreach (int i in numQuery1)
{
    Console.Write(i + " ");
}
Console.WriteLine(System.Environment.NewLine);
foreach (int i in numQuery2)
{
    Console.Write(i + " ");
}

// Something more interesting
var studentQuery8 =
    from student in students
    let x = student.Scores[0] + student.Scores[1] +
        student.Scores[2] + student.Scores[3]
    where x > averageScore
    select new { id = student.ID, score = x };
```

The `List<int> numbers` now has the `Where` method due to method extensions from LINQ.

## Namespaces

* They organize large code projects.
* They are delimited by using the `.` operator.
* The `using directive` obviates the requirement to specify the name of the namespace for every class.
* The `global` namespace is the "root" namespace: `global::System` will always refer to the .NET Framework namespace `
`System`.
* If there is any ambiguity if you import two namespaces with name collisions, you will get a compile error.

```cs
namespace N1     // N1
{
    class C1      // N1.C1
    {
        class C2   // N1.C1.C2
        {}
    }
    namespace N2  // N1.N2
    {
        class C2   // N1.N2.C2
        {}
    }
}

// Can also use aliases
using colAlias = System.Collections;

namespace System
{
    colAlias::Hashtable test = new colAlias::Hashtable();
    global::System.Console.WriteLine(name + " " + test[name]);
}
```

## Null

There's a whole bunch of stuff dealing with `null` - basically C# attempts to provide helper functions and features to avoid magic numbers and redundant code.

C# operators:

* `??` - null coalescing operator
* `?.` - null conditional operator
* `?:` - normal ternary operator

C# methods:

* `HasValue`: same as `!= null` but use either consistently - use this with casting nullable types to non-nullable


```cs
// Using t
Person p = null;

// Normal use of ternary operator although it is limiting
// and can be quite cluttered
int nonNullableInt = (p != null) ? 0
                                 : -1;

// Null conditional operator which only evalutes further if
// the right hand side is not null else returns null
int? nullableInt = p?.Age;

// Null coalescing operator which evalutes to the left hand
// expression if not null else right hand expression
p = new Person();
int? nullableInt = p.Age ?? -1;

// Combining null conditional and null coalescing is
// a common practice since they complement each other
p = null;
int? nullableInt = p.?Age ?? -1;

// Arrays with null con ditional
Person[] people = new Person[3]
{
    new Person(1), // Age = 1
    new Person(),  // Age = null
    null           // Person is null
}
int p1  = people?[0].Age;  // 1
int? p2 = people?[1].Age;  // null
int? p3 = people?[2].Age;  // null

// A horrible way of nullable types
Nullable<int> nullableInt;
```

### Helpers for strings

C# methods:

* `isNullOrEmpty`
* `isNullOrWhiteSpace`: this will **also** check if the string is empty

## Async

C# has asynchronous support built-in to its language and Microsoft encourages the use of it to alleviate the complexity of concurrency, mulit-threading, locking etc.

With async programming, firstly, you must identify the following situations:

* Is my work IO bound?
* Is my work CPU bound?
* Is my work worth having async?

Think of `await` as an "asynchronous wait" i.e. it **blocks the method** (if necessary) but **not the thread**.

### CPU bound

Because it's CPU bound, you ideally want to move this work onto a **new thread** without making the main thread wait.

You want to use:

```cs
await Task.Run(() => Func());
```

Make sure to yield control back to the main thread!

### IO Bound

You **don't** want a new thread or queue an IO bound task to the Threadpool because  a **new thread** dedicated to just wait for return request is costly when the thread could be doing more meaningful work!

What you want is to **delegate** the work to the OS which in turn delegates the work asynchronously - this is important so that when your HTTP request finally responds - it is bubbled back to the caller via interrupts and in a non-blocking fashion.

You want to use:

```cs
await SomeFuncAsync();
```

```cs
public async Task DoMixedWork()
{
    // Queues the specified work to run on the thread pool
    // and returns a Task object that represents that work.
    // Don't block the main/current thread
    Task cpuTask Task.Run(() => Prime95());

    // IO bound work which does not require a new thread
    // The task is immediately fired
    Task ioTask = SomeIoBoundAsync();

    // Do synchronous code that doesn't rely on the above
    // return values/work
    DoSomeUnRelatedCode();

    // Now we need the results
    int age = await cpuTask;
    int name = await ioTask;
}

public async Task<string> SomeIoBoundAsync()
{
    // Fetch some database or HTTP requests
    // ...
}

public async Task<int> Prime95()
{
    // Do lots of very long calculations
    return 1*1;
}
```
