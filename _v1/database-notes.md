---
layout: compsci-note
title: Database Notes
categories: [database]
description: Some basic notes on databases
order: 20
sitemap: false
---

## Links

* [Indexes - clustered and unclustered](https://technet.microsoft.com/en-us/library/jj835095(v=sql.110).aspx)

## Terms

* **DBMS**: Database Management System is a collection of programs that enables users to create and maintain a database.
* **Domain** `D` is an atomic value. Each domain is specified a data *type* or *format*.
* **Relation Schema** `R(A1, A2, Ai...)`:
  * `Ai`: **attribute** is the name of a role played by some domain `D`.
  * `R`: the name of the **schema**.
  * It is used to describe a relation called `R`.
* **Relation** or Relation state `r` or `r(R)` of the relation schema `R(A1, A2, Ai...)` is a set of tuples:
  * `r = {t1, t2, t3..}`, a set of **n-tuples**.
  * Each n-tuple `t` is an **ordered list** of **n** values `t = <v1, v2, ..., vn>`, where each value v<sub>i</sub>, 1 ≤ i ≤ n, is an element of `dom(Ai)` or is a special `NULL` value.
  * The **i<sup>th</sup>** value in tuple `t`, which corresponds to the attribute `Ai`, is referred to as `t[Ai]`.

Example:

```text
Relation name = Student
Attributes = Name, Ssn, Address
Tuples = row

+---------+---------+---------+
| Name    | Ssn     | Address | // attributes with dom(Ai)
+---------+---------+---------+
| Bob     | 123     | Sydney  | // tuple
+---------+---------+---------+
| Alice   | 321     | Coona   |
+---------+---------+---------+
...

t[Name] = <'Bob'>           // first tuple only
t[Name, Ssn] = <'Bob, 123'>
```

## Keys

### Superkey

* A superkey `SK` specifies a **uniqueness** constraint that **no two** distinct tuples in any state `r` of `R` can have the **same** value for SK.
* Every relation has at least **one default** superkey — the set of **all** its attributes.
* A superkey can have redundant attributes, however, so a more useful concept is that of a **key**, which has **no** redundancy.

### Key

* A key `K` of a relation schema `R` is a superkey of `R` with the additional property that **removing** any attribute `A` from `K` leaves a set of attributes `K'` that is **not** a superkey of `R` any more.

Hence, a key satisfies **two** properties:

1. **Two distinct** tuples in any state of the relation **cannot** have identical values for (all) the attributes in the key.
   This first property also applies to a superkey.
2. It is a **minimal** superkey i.e. a superkey from which we **cannot remove** any attributes and **still** have the uniqueness constraint in **condition 1 hold**.
   This property is **not** required by a superkey.

### Candidate key

* A relation can have more than one key, these are called candidate keys e.g. If a relation contains 2 unique serials.
