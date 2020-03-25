---
layout: compsci-note
title: Test Driven Development
categories: [fundamentals, methodologies]
description: Some notes on Test Driven Development (TDD)
order: 20
sitemap: false
---

## The Three Laws of TDD

1. You are not allowed to write any production code unless it is to make a failing unit test pass
2. You are not allowed to write any more of a unit test than is sufficient to fail; and compiling failures are failures
3. You are not allowed to write any more production code than is sufficient to pass the one failing unit test

## Rationale

Analogy: washing hands - it may seem tedious, impractical, boring etc. but it has come be a well accepted practice.

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
