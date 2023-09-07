---
layout: compsci-note
title: Test Driven Development
categories: [fundamentals, methodologies]
description: Some notes on Test Driven Development (TDD)
---

## The Three Laws of TDD

1. You are not allowed to write any production code unless it is to make a failing unit test pass
2. You are not allowed to write any more of a unit test than is sufficient to fail; and compiling failures are failures
3. You are not allowed to write any more production code than is sufficient to pass the one failing unit test

## Rationale

**Analogy**: washing hands - it may seem tedious, impractical, boring etc. but it has come be a well accepted practice.

### Reducing Debugging Time

You want to spend as little time debugging and more time coding and solving the problem. One indicator of spending too much debugging is when you know all the hotkeys, watch-points etc.

### Code Documentation

Unit tests are code snippets - they are commonly used as code examples for a library. They explain how your code works and are always kept up to date.

### Encourages Good Design

In order to test code, often this encourages decoupled code and good design. Poor code is often difficult to test and this leads to *rot* - unit tests that run **fast**, then code improvements can be quickly made.

### Unit Tests Get Written

Unit tests will get written if they are written first! Writing unit tests before the fact is always more fun.

### Code Can Be Shipped

This is the most important - if all tests pass, then there is **nothing more to do**. The system works and we can deploy.

## Conclusion

* TDD isn't **mandatory**, it is just a methodology that you should seriously consider
* Trend in modern languages encroaching into static type-checking; more and more coupling to the compiler
  * "Some unit tests don't need to be written": unit tests test operations and indirectly tests the types

## BDD - Behavioral Driven Development

It is a process that encourages collaboration amongst developers, QA and non-technical or business participants in a software project. It is an evolution from TDD and involves the use of natural-language constructs e.g. English sentences, that can express the behavior and expected outcomes.

In short, it focuses on:

* Where to start in the process
* What to test and what not to test
* How much to test in one go
* What to call the tests
* How to understand why a test fails

## Extreme Programming

There's a lot to write about so read the [Wikipedia](https://en.wikipedia.org/wiki/Extreme_programming) article on this. It is a software development methodology which is intended to improve software quality and responsiveness to changing customer requirements. It is a software development discipline that organizes people to produce higher-quality software more productively.

### Activities

* Coding
* Testing
  * unit tests, acceptance tests, system-wide integration tests
* Listening
  * listen to customers needs and understanding, as well as incorporating the feedback
* Designing
  * good design will resolve and avoid bottlenecks with just the above three

### Values

* Communication
  * documentation, pair programming, feedback, design
* Simplicity
  * "You aren't gonna need it" (YAGNI), simply code and design allows fast moving deployments, feedback etc.
* Feedback
  * from tests, customers and team
* Courage
  * design and code for *today*, not tomorrow. Courage to refactor, incorporate feedback, remove dead code, relinquish ownership
* Respect
  * includes others and self-respect

### Rules

#### Coding

* The customer is always available
* Code the unit test first
* Only one pair integrates code at a time (pair programming)
* Leave optimization until last
* No overtime

#### Testing

* All code must have unit tests
* All code must pass all unit tests before it can be released
* When a bug is found, tests are created before the bug is addressed
* Acceptance tests are run often and results are published

### Principles

They are the foundations of Extreme Programming and are based on the values describe above that foster decisions in a software development project.

* Feedback
  * iterate frequently with the customer
  * unit tests contribute to rapid feedback
* Assuming simplicity
  * small steps, incremental changes, customer has more control
* Embracing change
  * it's not about working against change - embrace them

### Practices

#### Fine-scale feedback

* Pair programming
* Planning game
  * basically business problems -> stories -> tasks
* TDD
* Whole team

#### Continuous process

* Continuous integration
* Refactoring or design improvements
* Small releases

#### Shared understanding

* Coding standards
* Collective code ownership
* Simply design
* System metaphor

And **sustainable pace** - now this is hard.
