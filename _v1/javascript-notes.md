---
layout: compsci-note
title: Javascript Notes
categories: [web-dev, language]
description: Some notes on Javascript
sitemap: false
---

## Basics

```javascript
// Variables
let x = 1; // let is replaced by var, they are block scoped
let y = (true) ?
  1 :
  2;

// Functions
function foo(x) {
  console.log("In function foo");
  console.log("This is globally defined");
};

let bar = function x(y) {
  console.log("This function expression is not globally defined");
};

// Interesting ternary function expression
let welcome = (age < 18) ?
  function() { alert("Hello!"); } :
  function() { alert("Greetings!"); };
welcome();
```
