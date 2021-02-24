---
layout: compsci-note
title: C# Tips
categories: [tips, language]
description: Some tips and tricks with C#
sitemap: false
---

## C# Tips

### Empty async delegate

Useful for unit testing for mocks or even for method signatures that require a delegate.

```cs
(x, y) => {}
```

## Some Interview Questions

> What is the difference between an `abstract` class and an `interface`?

* Concrete classes can implement multiple interfaces but only a single abstract class
* Abstract classes can have virtual methods that implement some functionality, interfaces cannot contain any implementation
* Semantically different; an interface is a contract an implementing class will satisfy whilst an abstract class is usually for providing and/or defining a base set of functionality

> What is the difference between `abstract` and `virtual`?

* Virtual methods may or may not have an implementation
* Abstract methods must be empty statements

> Is class overloading and overriding at compile time and/or run-time?

Class **overloading** is at (static) compile time as the compiler is aware of what method is invoked and what parameter types are set up.

Class **overriding** is at run-time and is an example of dynamic polymorphism. An example is when a method has an interface object as a parameter and the IoC container will resolve the implementing class at run-time. Thus the implementing method's behavior could change.

> What is `IQueryable` used for?

It provides functionalities to evaluate queries against a specific data source where the type of the data is known. It is intended for implementation by query providers and it also implements `IEnumerable` - thus enumeration of the expression tree is lazily executed.
