---
layout: compsci-note
title: Database Notes
categories: [database]
description: Some basic notes on databases
order: 20
---

## Links

* [Indexes - clustered and un-clustered](https://technet.microsoft.com/en-us/library/jj835095(v=sql.110).aspx)

## ACID

* Atomic
  * "All or nothing" - no partial failure and state unchanged if fails
* Consistency
  * Changes to one valid state to another - must satisfy any defined consistency rules
* Isolation
  * Concurrent execution of transactions are isolated
* Durability
  * Once committed, remain so even if power loss, crashes etc.

## BASE

Basically Available, Soft state, Eventual consistency.
 From [Stack Overflow](https://stackoverflow.com/questions/3342497/explanation-of-base-terminology):

>The CAP theorem states that a distributed computer system cannot guarantee all of the following three properties at the same time:
>
> * Consistency
> * Availability
> * Partition tolerance
>
> A BASE system gives up on consistency.
>
>Basically available indicates that the system does guarantee availability, in terms of the CAP theorem.
>Soft state indicates that the state of the system may change over time, even without input. This is because of the eventual consistency model.
>Eventual consistency indicates that the system will become consistent over time, given that the system doesn't receive input during that time.

## NoSQL vs SQL

From the [Azure article](https://azure.microsoft.com/en-au/overview/nosql-database/):

### NoSQL

* Handling large, unrelated, indeterminate or rapidly changing data
* Performance and availability is more important than strict consistency
* Schema agnostic data
* IoT, real-time analytics, content management
* Scales horizontally by sharding

### SQL

* Relational data that has logical requirements that can be identified in advance
* Schema of both app and database must be in-sync
* Complex querying of data
* Transactional/financial systems, inventory management
* Scales vertically

## Theory

### Relationships

These O'Reilly chapters cover the basics, including the symbols that are often used:

* [Learning MySQL - The Entity Relationship Model](https://learning.oreilly.com/library/view/learning-mysql/0596008643/ch04s03.html)
* [Learning MySQL - Examples](https://learning.oreilly.com/library/view/learning-mysql/0596008643/ch04s04.html)

![ERD symbols](https://i.imgur.com/eFPqJxlm.png)

#### 1:1

* One country, one capital city
* One person, one passport

A 1:1 relationship can be enforced at the database level using foreign keys with a unique constraint.

#### 1:M

* One building, many apartments
* One apartment only relates to one building

The latter defines it as a 1:M as a result. Other examples:

* One company has many employees, and one employee is related to one company

#### M:M

* One tenant can own many apartments, **and** one apartment can be owned by many tenants
* Therefore Many tenants can own many apartments

A M:M relationship would be to have an table with columns of the two entities with the relation. Other examples:

* Customer and products - one customer is related/buys to many products, and one product is bought/related to many customers

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

### Terms

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
