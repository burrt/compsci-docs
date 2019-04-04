---
layout: compsci-note
title: SOLID Principles Notes
categories: [solid]
description: Some notes on SOLID Principles in Software Engineering
order: 20
sitemap: false
---

# Software Engineering Principles

## Contents

* [Single Responsibility](#single-responsibility-principle)
* [Open Closed Principle](#open-closed-principle)
* [Liskov Substitution Principle](#liskov-substitution-principle)
* [Interface Segregation Principle](#interface-segregation-principle)
* [Dependency Inversion Principle](#dependency-inversion-principle)
* [Dependency Injection](#dependency-injection])
* [Don't Repeat Yourself Principle](#dont-repeat-yourself-principle)
* [Patterns](#patterns)
  * [Repository Pattern](#repository-pattern)
  * [Command Query Pattern](#command-query-pattern)
  * [Factory Pattern](#factory-pattern)
* [Miscellaneous Encyclopedia](#miscellaneous-encyclopedia)

## Single Responsibility Principle

> Every software should have **only** one reason to change.

A class should only have one job. A popular analogy is the Swiss knife which has can perform many different functions and with more and more functions added, it becomes a nightmare to use.

```cs
// Violates the SRP and has hidden dependencies
class MessageService
{
    private Email _email;
    private Sms _sms;

    public void SendEmail()
    {
        Send(_email);
    }

    public SendSms()
    {
        Send(_sms);
    }
}

// Refactored
//
interface IEmailSender
{
    public void SendEmail(Email email);
}
interface IEmailSender
{
    public void SendSms(Sms sms);
}
// Now you can create separate services of Email and SMS
// And you can inject them into the MessageService class
```

## Open Closed Principle

> Open for extension and closed or modification.

A class should be designed in a way such that new functionality should only be added when there are new requirements - this can be achieved with inheritance. An existing class should be closed for modification and it shouldn't be necessary to modify it to add new functionality.

## Liskov Substitution Principle

> Derived classes **must** be substitutable for their base classes.

A class should be able to use any derived class instead of a parent class and have it behave in the same manner without modifiation.

## Interface Segregation Principle

> Make fine grained interfaces that are client specific.

Basically clients shouldn't be forced to implement interfaces that they don't use. Many small, **focused** interfaces is preferable over a fat interface.

### Smells

* A class only implements a subset of an interface which then usually indicates a LSP violation as well.
* Many `NotImplementedException`

## Dependency Inversion Principle

> Depend on abstractions, not on concretions.

High level modules/classes shouldn't depend on low-level modules/classes.

* **Both** should depend on abstractions
* Abstractions should not depend upon details
* Details should depend on abstractions

### Traditional programming

* Business logic depends on the infrastructure e.g. database
* Static methods are used for convenience
* Class instantiations are scaterred throughout the application
  * Violates the SRP & LSR

### Class dependencies

The idea is that classes should be **honest** with their dependencies so that they are *explicit*. Having hidden or implicit dependencies makes it very hard to unit test and change/extended functionality.

## Dependency Injection

> Is a set of software desgin principles and patterns that enable us to develop loosely coupled code.

In its general form, it would be described as above. Designing loosely coupled code tends to adhere to other SOLID principles naturally; for example, it often does not violate the DRY and O/C principles.

For .NET Core for example, it injects or resolves the dependences a class explicitly needs through its IoC (Inversion of Control) Container - adding your service implementations is as simple as adding it to the service collection with a method extension.

### Explicit Dependencies Principle

> Methods and classes should **explicitly** require any collaborating objects they need in order to function correctly.

### Constructor Injection

#### Pros

* Classes self-document what they need to perform
* Works well with/without a container
* Classes are always in a valid state once constructed

#### Cons

* Can have many dependencies (design smell)
* Some features need default constructors e.g. serialization
* Some methods in the class may not require some of the injected dependencies other methods require (design smell)

### Property Injection

Also known as "Setter Injection" by setting properties.

#### Pros

* Dependencies can be changed at any time during its lifetime
* Very flexible

#### Cons

* Dependencies may be in an invalid state between constructions and setting of dependencies
* Less intuitive - hard to document, what if order of setting matters?

### Parameter Injection

Dependencies are passed in via a method parameter. Consider if one method has the dependency, otherwise prefer constructor injection.

#### Pros

* Most granular
* Very flexible
* Requires no change for the rest of the class

#### Cons

* Breaks method signature
* Can result in many parameters (design smell)

## Don't Repeat Yourself Principle

> Repetition in logic calls for abstraction. Repetition in process calls for automation.

## Patterns

### Repository Pattern

Abstracts data access behind a collection like interface.

### Command Query Pattern

### Factory Pattern

## Miscellaneous Encyclopedia

### Domain Objects

Objects from the business specific area that represent something meaningful to the domain expert. Domain objects are mostly represented by entities and value objects. Generaly speaking, most objects that live in domain layer contribute to the model and are domain objects.

For example, in most cases, domain objects do not include things like logging, formatting, serialisation, encryption etc - unless you are specifically building a product to log, serialise, format or encrypt respectively.

### POCO

Plain Old Class Object - it just stores data in memory generally using auto-properties and is used with ORM or as a Data Transfer Object.

### Entity

An object fundamentally defined not by its attributes, but by a thread of continuity and identity. (Meaning it must have Id)
