---
layout: compsci-note
title: Design Patterns Notes
categories: [fundamentals, architecture]
description: Some notes on Design Patterns in Software Engineering
---

## Design Patterns

* [Singleton Pattern](#singleton-pattern)
* [Abstract Factory Pattern](#abstract-factory-pattern)
* [Proxy Pattern](#proxy-pattern)
* [Repository Pattern](#repository-pattern)
* [Command Query Responsibility Segregation Pattern](#command-query-responsibility-segregation-pattern)

## Resources

* [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.amazon.com.au/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612)
* [Martin Fowler Blog](https://martinfowler.com/tags/application%20architecture.html)

## Singleton Pattern

### Intent

> Ensures a class only has a single instance.

### Motivation

For some classes it is important that there is only one instance of a class e.g. one window manager, one filesystem, one accounting system for a company.

By constructing a dedicated class for encapsulating the global instance for access is a better approach better than global variables. It should also be extensible by sub-classing and clients should be able to use the derived class without modifying their code - Liskov Substitution Rule.

### Consequences

1. Control access to sole instance - the class encapsulates the sole instance and therefore can control access to it
2. Avoid polluting the global name space
3. Extensible
    * For static classes, they cannot be inherited, cannot implement interfaces and lazy loaded.
4. Permit additional instances if required

#### Sample code

```cs
public class SingletonLogger : ISingletonLogger
{
    private static ILogger _logger;

    private SingletonLogger() { }

    public static GetInstance() {
        // not thread-safe, can lock around this check
        if (_logger == null) {
          _logger = new Logger();
        }

        return _logger;
    }
}
```

Other additions could be to use `Lazy` or a different form of lazy instantiation if necessary. It is more important to know **when** to apply this pattern.

## Abstract Factory Pattern

### Intent

> Provide an interface for creating families of related or dependent objects without specifying their concrete classes.

### Motivation

If you consider an UI application with various widgets of different themes, each widget theme have a consistent "look and feel" but the themes remain different and independent from each other. An application should **not** hard-code the widgets; instantiating the look-and-feel of different widget themes throughout the code becomes a maintenance nightmare.

One solution is to define an abstract `AbstractWidgetFactory` that defines an interface for created each widget theme. There is also an abstract class for each widget (e.g. `AbstractWindow`) where concrete classes implement them to provide their specific look-and-feel. The client calls only the `AbstractWidgetFactory` methods and interacts with only the `AbstractWindow` for example - this encourages Dependency Inversion and decoupled code.

The `AbstractWidgetFactory` implicitly groups the family of products/classes and enforces this constraint through the concrete abstract factories.

![Abstract Factory Pattern](https://i.imgur.com/uWVdcpR.jpg)

The Abstract Factory pattern should be considered when:

* a system should be independent of how its products are created, composed and represented
* a system should be configured with one of multiple families of products
* a family of related product objects is designed to be used together, and you need to enforce this constraint
* you want to provide a class library of products, and you want to reveal just their interfaces, not their implementations

Diagrams are much easier to understand - the above was a snippet from [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.amazon.com.au/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612) and it contains a very comprehensive list of design patters - must read.

### Consequences

1. Isolates concrete classes
    * Clients operate on abstractions and are isolated from implementation classes
2. Changing product families are easy
    * Single point of where to swap out product families
3. Consistency
    * Products/objects within the product families are consistent and usages are grouped together
4. Supporting new product families or a different type of factory can be challenging
    * Depending on the implementation, be mindful of the Open/Closed principle

## Proxy Pattern

### Intent

>To provide a surrogate/substitute/proxy for another object to *control access* to it.

### Motivation

It can allow the deferral of the object's full cost of creation and initialization until it needs to be used. On-demand creation such as a graphical document editor avoids creation of all elements/objects once a document is created. Another example of where the proxy pattern is useful is when the proxy can act as a local representation of an object that could be in a different address space - distributed computing. Thus communication to this entity is transparent and the complexity is constrained to a small area.

The proxy has control of what interface it chooses to expose thus a way of hiding certain functionality of the real object.

## Repository Pattern

### Intent

> To mediate between the domain and data mapping layers by abstracting the data access behind a collection like interface.

### Motivation

For complex systems it can be useful to isolate domain objects from details of the database access. Additionally it can be useful to build another layer of abstraction over the data mapping layer for query construction - this can reduce code duplication.

The repository pattern provides clients an object oriented view of the data persistence layer as they interact with it as a collection of objects.

Sample code from [Remondo (archived)](http://web.archive.org/web/20150404154203/https://www.remondo.net/repository-pattern-example-csharp/):

```cs
// Concrete classes could then set the data context
public interface IRepository<T>
{
    void Insert(T entity);
    void Delete(T entity);
    IQueryable<T> SearchFor(Expression<Func<T, bool>> predicate);
    IQueryable<T> GetAll();
    T GetById(int id);
}
```

#### Consequences

* Data access layer is abstracted and contained in one area
* Changing the underlying database implementation e.g. SQL Server to Oracle, is much easier with the decoupling
* No dependency on details but rather abstractions e.g. alternative would be to use store procedures written in a specific database query language.

## Command Query Responsibility Segregation Pattern

### Intent

> The CQRS pattern is, at a general level, a pattern that allows different models for reading and updating information. [Martin Flowler](https://martinfowler.com/bliki/CQRS.html)

### Motivation

The traditional method of accessing data is to treat it as a CRUD datastore. However, as the system grows in complexity, this model may not be sufficient as we may look at the information in a different way to the *record store*, perhaps combining multiple records to create a virtual records and so on. For updating, we may find validation rules that only allow certain combinations of data to be stored.

This leads to multiple representations of information. Developers build their own *conceptual model* which they use to manipulate core elements of the model and the persistent storage is often as close to this model as possible.

CQRS splits the conceptual model into separate models for update and display - **Command** and **Query** Separation. *The rationale is that for many problems, particularly in more complicated domains, have the same conceptual model for commands and queries leads to to a more complex model that does neither well.*

Note that the statement is in theory however in practice, CQRS is a **significant** mental leap as well as in complexity, often resulting in a drag on productivity and increased risk.

### Consequences

* High performance
  * The separation of loads and writes allows you to scale them independently
  * Real-time reporting with eventual consistency can be more achievable
* CQRS often fits well with task-based UI and event-based programming models
  * Event Collaboration and Event Sourcing?
