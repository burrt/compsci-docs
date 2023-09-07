---
layout: compsci-note
title: The Pragmatic Programmer
categories: [books]
description: Some notes from The Pragmatic Programmer
favorite: true
---

## Overview

A fantastic book from Andrew Hunt and David Thomas, there is now a [20th Anniversary Edition](https://www.amazon.com.au/Pragmatic-Programmer-special-David-Thomas/dp/0135957052).

> Simply put, this book tells you how to program in a way that you can follow.

Additionally:

> ... they (pragmatic programmers) paid attention to what they were doing
> while they were doing it - and then they tried even better

## Contents

* [What Makes a Pragmatic Programmer](#what-makes-a-pragmatic-programmer)
* [A Pragmatic Philosophy](#a-pragmatic-philosophy)
* [A Pragmatic Approach](#a-pragmatic-approach)
  * [Estimating](#estimating)
* [Pragmatic Paranoia](#pragmatic-paranoia)
  * [Design By Contract](#Design-by-contract)
    * [Semantic Invariants](#semantic-invariants)
  * [Shy Code](#shy-code)
  * [Lazy Code](#lazy-code)
* [Bend, or Break](#bend-or-break)
  * [Decoupling and the Law of Demeter](#decoupling-and-the-law-of-demeter)
  * [Temporal Coupling](#temporal-coupling)
* [While You are Coding](#while-you-are-coding)
  * [Gardening analogy](#gardening-analogy)
* [Before the Project](#before-the-project)
  * [Digging for Requirements](#digging-for-requirements)
* [Pragmatic Projects](#pragmatic-projects)
  * [Pragmatic Teams](#pragmatic-teams)

## What Makes a Pragmatic Programmer

* Early adopter/fast adapter
* Inquisitive
* Critical thinker
  * Don't accept "because this is the way it's always been done"
  * Don't just stop at improving the problem itself, improve your own thinking too
  * Analyze what you read, hear and think!
* Realistic
  * Try to understand the nature of each problem
  * Realism provides you a good feel of how difficult things are and can influence your estimations etc.
* Jack of all trades
  * You can specialize but don't let that hold you back from adaptability

## A Pragmatic Philosophy

* Take responsibility, don't make **excuses** - provide options/alternatives
* **Software entropy** - "rot" or neglect. Entropy is "disorder".
* **Catalyst for change**
  * Don't ask permission (since you'll be rejected), instead, work on incremental changes, show, suggest etc.
  * Soup of Boiled Stones
    * Analogy: bunch of soldiers in war-zone with no food start boiling stones in a pot that slowly attracts the villagers
* **Good enough software**

### Your Portfolio

#### Build one

* Invest regularly
* Diversity in tools, knowledge
* Manage risk
* By low, sell high - early adopter
* Review and re-balance - languages, technology changes

#### Goals

Some interesting ideas to keep in mind:

* Learn at least **one new** language a year
* Read **one technical** book a quarter
* Read non-technical books too (I prefer this one)
* Take classes
* Participate in local user groups, create a network to glean information about other companies etc.
* Experiment in different environments e.g. Windows/Linux
* Stay current - magazines etc.

### Communication

* Know what you **want** to say
  * Take notes before meetings
* Know your audience, are they end-users, technical...
* Choose your time - Friday 5 PM?
* Make it look good - Latex etc.
* **Listen** to people
* **Always get back to people** - even if you can't immediately, "I'll get back to you.." goes a long way

Reflect on:

* What do you want them to learn?
* What is their interest in what you've got to say?
* How sophisticated are they?
* How much detail do they want?
* Whom do you want to own the information?
* How can you motivate them to listen to you?

## A Pragmatic Approach

### Don't Repeat Yourself

This applies also to documentation and other non-code related matters. Changing things in more than one place is duplicate effort - a recipe for stale information.

#### How it occurs

* Imposed duplication
  * Developers feel they have no choice - the environment seems to require duplication
  * Multiple representations of information - use code generators as much as possible e.g. DB schema
  * Documentation and code - linking user specifications to tests can automate what tests fail/need to be fixed
* Inadvertent duplication
  * Unaware
  * Design issues
* Impatient duplication
  * Lazy
* Interdeveloper duplication
  * Multiple people or different teams duplicate
  * Solution: make it easy to reuse and **communicate**

##### Inadvertent duplication example

```java
// length is defined by start and end
// duplication
class Line {
public:
    Point start;
    Point end;
    double length;
};

// better
class Line {
public:
    Point start;
    Point end;
    double length() { return start.distanceTo(end); }
};
```

### Orthogonality

A kind of independence/decoupling. Two or more things are orthogonal if changes in one **don't affect** any others. For example, a change in the DB layer will not impact the UI. Visually, imagine a straight line on a X-Y axis.

AOP: Aspect Oriented Programming.

#### Productivity

* Changes are localized
  * Testing and debugging is much easier
* Small changes > Big changes
* Loosely coupled systems are easier to reconfigure and re-engineer

#### Reduce Risk

* "Sick" components are small and contained
* Less fragile, bugs are contained to that component
* Will not be tightly coupled to a technology, vendor etc. since it will only be so for that single/few components

### Reversibility

* Never commit, always be soft and pliable - leave your self exits
* Design decoupled, well defined interfaces to be able to "change horses mid-stream"
  * This is does **not** mean to change interfaces but allow the implementations to be easily changed
* Always automate/generate metadata/code for "variables" e.g. requirements, marketing

### Tracer Bullets

* Write code that "glows in the dark"
  * Ready, fire, aim repeat
  * Starting in the dark (greenfield) or an opaque system
    * Write some code, run test
    * Write, modify, run test
    * Repeat until you are closer to your target but the idea is to keep modifying your path
* Useful when you need to produce results quickly
  * Use this to get feedback early and make adjustments accordingly
* Progress is visible and is *results driven*
* You don't always have to hit the target! **Small code has low inertia**

#### Prototyping vs Tracer Bullets

* Prototyping is strictly for POC and the code is *throwaway"
  * Do not make the mistake of using as the future code base
* Tracer code is the **skeleton** for the body
  * Lean and but complete

### Estimating

* It saves you time
* How accurate is enough?

| Duration   | Quote estimate in                    |
|------------|--------------------------------------|
| 1-15 days  | days                                 |
| 2-8 weeks  | weeks                                |
| 8-30 weeks | months                               |
| 30+ weeks  | think hard before giving an estimate |

* Scope out before answering estimates e.g. define any assumptions, ask others
* Building a **model** can elucidate any shortcomings or overlooked question/variables
  * It may also show what can be compromised (design/features) due to time

#### Building the Model

* Break the model into components
* Give each parameter a value
* Estimates are based on sub-estimates and so on
  * Your largest errors will come from this
  * **Always** revisit this and identify **why**
* Every sprint, estimates can be revisited
  1. Check requirements
  2. Analyze risk
  3. Design, implement, integrate
  4. Validate with users

> "I'll get back to you"

If you are not sure or confident about your estimates, that phrase will **always** be better than giving a very inaccurate estimate. It also may imply that you take estimates seriously.

## Pragmatic Paranoia

Analogy:

* You're the best driver on Earth, everyone else sucks
* We drive **defensively**, look out for trouble before it occurs (proactive), anticipate danger and never put ourselves into situations where we cannot extricate ourselves from - [reversibility](#reversibility)
* **We don't trust ourselves either**, you never write perfect code

### Design by Contract

Design by Contract (DBC) is a technique that focuses on documenting (and agreeing upon) the rights and responsibilities of software modules to ensure program correctness. A **correct program** is one that does no more or less than it claims to do.

DBC forces you to define requirements and guarantees upfront. By enumerating the input domain range, boundary conditions, what the routine **promises** to deliver at design time is a *huge improvement*.

Every function and method has:

* **Preconditions**
  * What must be true in order for the routine to be called - the routine's requirements
  * A routine should never get called when its preconditions would be violated - it is the caller's responsibility to pass good data
* **Postconditions**
  * What the routine is guaranteed to do - the state of the world when the routine is done
  * The fact that the routine has a precondition, it implies that it will conclude - infinite loops aren't allowed
* **Class invariants**
  * A class ensures that this condition is always true from the perspective of a caller
  * During internal processing of a routine, the invariant may not hold, but by the time the routine exits and control returns to the caller, the invariant must be true

#### Example

```java
/**
 * @invariant for all Node n in elements()
 *      n.prev() != null
 *          implies
 *              n.value().compareTo(n.prev().value()) > 0
 */
public class dbc_list {
    /**
     * @pre contains(aNode) == false
     * @post contains(aNode) == true
     */
    public void insertNode(final Node aNode) {
        ...
    }
}
```

> If all the routine's preconditions are met by the caller, the routine
> shall guarantee that all postconditions and invariants will be true when it completes

#### Shy code

For orthogonality, **do not reveal** information about itself unless really necessary. This avoids the caller and other components knowing unnecessary details and making assumptions etc.

#### Lazy code

For DBC, "lazy code" is instead promoted where you are **strict** in what to expect but **promise** as little as possible in return.

#### Semantic Invariants

* An inviolate requirement - a "philosophical" contract
* Example: debit card transaction switch
  * User of a debit card should **never** have the same transaction applied to their account twice
  * No matter what error (e.g. catastrophic), it should **always** side on **not** processing the transaction
  * > Err in the favor of the consumer
* These should be **simple law** that is directly driven from the requirements - they aren't requirements themselves but are central to the very meaning of a thing
* It can be applied to complex problems, drive and re-align design and implementation etc.

### Dead Programs Tell No Lies

> Crash early! Don't trash!

### Bend, or Break

> Life doesn't stand still

So doesn't code.

#### Decoupling and the Law of Demeter

* Strong cells, limit interactions make "good principle"
* Like a prison, with [shy code](#shy-code), the less that is known about other cells/inmates the better
  * Cells can be replaced easily
  * Problems are contained

##### Minimize coupling

Don't couple modules if possible. Declare them *explicitly* e.g. in the constructor.

##### Law of Demeter for functions

```cpp
class Demeter {
private:
    A *a;                       // The Law of Demeter for functions states
    int func();                 // that any method of an object should call
public:                         // only methods belonging to:
    void example(B& b);
}

void Demeter::example(B& b) {
    C c;
    int f = func();             // itself

    b.invert();                 // any parameters that were passed in to the
                                // method
    a = new A();
    a->setActive();             // any objects it created

    c.print();                  // any directly held component objects
}
```

* Consider trade-offs, delegation/wrappers at the cost of performance
  * If it is important to compromise, then make sure it is **known and controlled**
* Large Scale C++ Software Design

### Metaprogramming

Metaprogramming is to remove the details from the code - metadata. Design applications that are highly configurable - "soft".

Leave details in the metadata/configuration so if new requirements of rules change, your application will not break.

* [Reversibility](#reversibility)
* Decouples your design
* You could implement several different projects using the same application engine using different metadata
* Can be used as a workaround for bugs
* Complex logic (business) can be captured in metadata easier
  * Higher level languages are closer to requirements
  * PM/users can read/provide feedback
  * Bugs are more to do with **code**, not requirements
  * Code generators can be an option

### Temporal Coupling

* Always design for concurrency
  * Going the other way is **much** harder
* Coupling in **time** when design revolves around *sequential order*
* Gain flexibility and reduce any time-based dependencies in areas such as **workflow analysis** , architecture, design and deployment

#### Workflow Analysis

* Used to model and analyze the user's workflow as part of requirements analysis
* "What can happen at the same time, and what must happen in **strict order**" - dependencies

**Example**: making a pina colada

By observing the workflow, optimizations were made to parallelize the different tasks instead of performing this sequentially. Not only does this benefit performance but the temporal coupling become apparent.

```text
 +--------------------+  +-------------------------+  +--------------------+
 |  8. Open Mix       |  |  1. Open blender        |  |  4. Measure rum    |
 +---------+----------+  +------+-----+-----+------+  +-----------+--------+
           |                    |     |     |                     |
           |                    |     |     |                     |
           v          v---------+     |     +---------v           v
+--------------------------+          |          +--------------------------+
           |                          |                           |
           v                          v                           v
 +---------+----------+  +------------+------------+  +-----------+--------+
 |  3. Put mix in     |  |  8. Add two cups of ice |  |  5. Pour in rum    |
 +--------------------+  +-------------------------+  +-----------+--------+
                                                                  |
                                                                  |
                                                                  v
                                                      +-----------+--------+
                                                      |  7. Close blender  |
                         +-------------------------+  +-----------+--------+
                         |  11. Get pink umbrellas |              |
 +--------------------+  +------------+------------+  +-----------+--------+
 |  10. Get glasses   |               |               |  8. Liquefy        |
 +--------------------+               |               +-----------+--------+
                                      |                           |
                                      |                           v
                                      |               +-----------+--------+
                                      |               |  9. Open blender   |
                                      |               |                    |
                                      |               +--------------------+
                                      v
+---------------------------------------------------------------------------+
                                      |
                                      v
                         +------------+------------+
                         |  12. Serve              |
                         +-------------------------+
```

## While You are Coding

### Refactoring

Software development often uses the building construction analogy:

1. Architect draws up blueprints
2. Contractors dig the foundations, build the superstructure, wire and plumb, and apply finishing touches
3. The tenants move in and live happily ever after, calling building maintenance to fix any problems

Unfortunately software **doesn't** work that way. Instead of construction, it's more like *gardening*.

#### Gardening analogy

* Software is more organic than concrete
* You may plan many things in a garden according to an initial plan and conditions
* Some thrive, others end up as compost
* You may move plantings relative to each other to take advantage of light, shadow, wind and rain
* Overgrown plants get split/pruned, colors may clash and be moved for more aesthetically pleasing locations
* You pull **weeds**, and fertilize plantings that are in need of extra help
* You constantly monitor the health of your garden, making adjustments (weed, soil, layout etc.) as needed

Business people are more *comfortable* with the building construction metaphor since it is more scientific than gardening, it's repeatable, there's a rigid reporting hierarchy for management etc. But we're **not** building skyscrapers - we aren't as constrained by the boundaries of physics and the real world.

Gardening is much closer to the realities of software development.

> Don't live with broken windows
>
> Refactor Early, Refactor Often

#### Code that's easy to test

* Log formats must be consistent
  * Log parses
* Have your app include a webserver for debugging
  * Shows logs, internal statuses etc.
  * Useful that is easy to integrate

## Before the Project

### The Requirements Pit

> Don't Gather Requirements - Dig for them

#### Digging for Requirements

* They are *not* objects to be simply "gathered", work must be done to analyze them
* Need to differentiate between **policies** (what is true today but viable to change) and **requirements**
* Requirements are **not** often clear, it is difficult to define good ones
* Discover the reason **why** users do a particular thing - rather than just the **way** they currently do it
  * Understand the user, don't just observe
  * You're here to solve a business problem, not to just meet requirements
  * **Become a user**, literally, perform their role/shadow and you'll get feedback, insights, trust, empathy etc.
  * Work with a user to think like a user
  * Managerial view will not do justice to end users - key information is often filtered out

#### Documenting Requirements

* Long story short: use a website for documentation
  * It has the largest audience scope for people to read, contribute, feedback etc.
  * **But** at the end of the day, use what resonates best with your audience
* Use templates for requirements e.g. Cockburn's use case templates (p207, Fig 7.2)
* Don't over-specify or detail, they are *not* design

#### Seeing further

* The Y2K problem was flawed from a business practice/automation to engineering
* If people saw the need to abstract dates since systems will consume such data (requirement)
  * This would have exposed/hinted the need for maths/design

#### Book-keeping

* Track changes in requirements, scope etc.
* Glossary for terms used with Engineering/Management

### Solving Impossible Puzzles

> Don't Think Outside the Box - **no**, Find the Box

#### Degrees of freedom

* Identify constraints, recognize the degrees of freedom you have
* Don't dismiss something unless you can prove it should be

#### There Must Be an Easier Way

Ask the following questions before yelling and screaming:

* Is there an easier way?
* Are you trying to solve the right problem, or have you been distracted by a peripheral technicality?
* Why is this thing a problem?
* What is it that's making it so hard to solve?
* Does it have to be done this way?
* Does it have to be done at all?

### Not Until You're Ready

> Listen to Nagging Doubts - Start When You're Ready

* If you have doubts, then there's probably a reason for that - understand what it is
* The idea of starting at the right time
* Starting on a blank canvas
  * Procrastination
  * Prototype/POC
    * This could determine if you were procrastinating and/or lead to real development and design revelations

### The Specification Trap

* When you specify **all** the details to remove all the ambiguity
  * Thats a **TRAP!**
* It is impossible to cover every nuances of a requirement/system
  * Include human interpretations, restrictions in the domain language, teams, human factors etc.
* Example: describe how to tie a shoe lace
  * **Some things are easier done than said**
* A pragmatic programmer will look at requirements digging, design and implementation as a **single process**
* Over-specification have *diminishing* returns
  * Harder to move on and hack code - if this is your team, consider prototyping/tracer bullets

### Circles and Arrows

> Don't Be a Slave to Formal Methods

* Formal methods: CASE, waterfall development, ER diagrams etc.
* These are fads; they enjoy a period of popularity adrift in a sea of others and developers hang on these pieces like driftwood
  * Learn to move on, adapt
* Prototyping and showing progress to end-users is often much better than formal methods e.g. ER diagrams
* Formal methods encourage **specialization**, silos between teams and a "us vs them" mentality, barriers, communication inefficiencies
  * Better to merge systems together and encourage a seamless process
  * Can lead to toxic culture
* Use formal methods but think carefully before **embracing**, we should pick the best, constantly improve and always tailor for what works for **your team**

## Pragmatic Projects

* We must relinquish individual philosophy to talk about larger, project-sized challenges
* Pragmatic **teams** amplify pragmatic programmers

### Pragmatic teams

#### No Broken Windows

* Quality is a team issue
* If the team discourages the fixing of small problems - **red flags**
* Do **not** ignore

#### Boiled Frogs

* Analogy: frogs didn't notice themselves slowly being boiled
* Don't be **in** the code, be part of and view it above to **notice changes** and gain control
* Appoint someone who observes scope changes, requirements, time scales etc.
* Be aware of changes in the team

#### Communicate

As some have said before: "there is no such thing as over-communication".

* Meetings should have structure, well-prepared and should be looked forward to
* Documentation should be crisp, accurate and consistent
* *Team name* - identity to build upon and for the team to attach to across projects

#### DRY

* Don't duplicate effort, appoint someone for coordination like a librarian
* Appoint people in the team e.g. API/DB person

#### Orthogonality (team)

* Avoid silos, isolation - it doesn't work
* Split teams based on features/functionality **not** by component
* Large cohesive teams are like code - they are organized like so
* Use [DBC](#design-by-contract) - teams promise behavior and if that changes, it **must** be communicated
  * For example, changes in telemetry in Engineering will impact Legal/Marketing - coordination is key
* Projects should have 2 heads/leaders
  1. Technical
      * Developer philosophy, code style, assigns responsibilities to teams, arbiter in discussions
  2. Administrative
     * Business requirements, management, progress, resources, priorities, coordination

#### Automation

* Appoint tool builders, makefiles, scripters
* Auto-generated documentation is powerful and encourages the DRY principle
  * For example, you can use Jekyll to place code and documentation side by side e.g. `/docs`, `/src`, a change in code requires changes in the documentation
  * Proprietary software for documentation e.g. Confluence, comes at a cost and this is really bad

#### Know When to Stop Adding the Paint

* Let each individual show their individuality, give them structure and space to shine
* Know when to stop adding the paint - it can be stifling

### Ruthless Testing

#### Unit tests

* Consider TDD approaches
* They will not capture all bugs

#### Integration tests

* Tests integration of your system with other (sub)systems
* Fertile breeding ground for bugs (like a garden!)

#### Validation and Verification

* Does it address what the user **needs** - it may be what they *wanted*, but is it needed?
* Does it meet the functional requirements of the system? Test it

#### Performance testing

* Ensure you run stress and scale tests

#### Usability testing

* Real users and environment conditions
* Look at usability in terms of human factors
* Are there any misunderstandings of the requirements
  * Tools that fit engineers should also fit users!
* Failures in usability are as bad as P0 bugs

#### How to Test

* Regression testing
  * Important you check for regressions in new features
* Test data
  * How to generate useful test data?
  * Some need to be manual since data must be from the real-world
* Testing the tests
  * Introduce bugs on purpose - like AWS canaries!
  * Check that tests fail (you can appoint someone)
* Test **state coverage**, *not* code coverage
  * Even small programs can have many states

### Great Expectations

* Success of a project is measured how well it meets the **expectations** of its users
  * It if falls below the expectations, it doesn't matter how good the design is, it is a **FAILURE**
  * **Gently** exceed your user's expectations
* Communicate expectations
  * User's have a "vision" which can be emotional/misinterpreted
  * Liaise with them frequently so small changes in expectations can be managed - there's a fine line here
    * It provides feedback early and opportunity to show progress

#### Extra Mile

* Don't surprise them, **delight** them
* Small QOL additions like tooltips, hotkeys, quick references, log file analyzers, splash screen (branding)
  * Engineering efforts are small but has large returns

### Pride and Prejudice

> Sign Your Work

* Like a craftsmen, you should be proud of your work
  * Don't let this deter you from potential prejudices towards you (defensive)
* People should see your name and expect it to be solid, well-written, tested and documented
  * A professional job written by a real professional
  * A Pragmatic Programmer
