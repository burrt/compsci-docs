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
