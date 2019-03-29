---
layout: default
title: Java Notes
categories: [language]
description: Some notes on Java
order: 20
sitemap: false
---

# Contents

* [Basics](#basics)
* [Streams](#streams)
* [ArrayList vs LinkedList](#arraylist-vs-linkedlist)
* [Regex](#regex)
* [String manipulation](#string-manipulation)
* [Annotations](#annotations)
* [Multi-threading](#multi-threading)
* [Encapsulation](#encapsulation)
* [Static methods](#methods)
* [UML](#uml)
* [Overloading](#overloading)
* [Misc](#misc)
* [Classes](#classes)
* [OO Designs](#oo-designs)
  * [Composition](#composition)
  * [Inheritance](#inheritance)
  * [Polymorphism](#polymorphism)
  * [Abstract classes and interfaces](#abstract-classes--interfaces)

## Links

* [A summary of the Java tutorial by NTU](https://www.ntu.edu.sg/home/ehchua/programming/#Java)
* [Java 8 tutorial](https://docs.oracle.com/javase/tutorial/java)

## Basics

Definitions:

* Object: is a software bundle of related state and behaviour.
* Class: is a blueprint or prototype from which objects are created.
* Interface: is a contract between a class and the outside world.
* Package: is a namespace for organizing classes and interfaces in a logical manner.

The four main OOP Java concepts:

* Encapsulation
* Inheritance
* Polymorphism
* Abstraction

```java
class Hello {
    public static void main(String[] args) {
        // constant
        static final double PI = 3.142;

        // arrays
        int[] myIntArray1 = new int[3];
        int[] myIntArray2 = {1,2,3};
        int[] myIntArray3 = new int[]{1,2,3};
        int num[][] = new int[5][2];  // 2-D arrays

        // iterate
        for (int x: myIntArray1) {
            System.out.println(x);
        }

        // copy arrays
        // public static void arraycopy(Object src, int srcPos,
        //                     Object dest, int destPos, int length)
        System.arraycopy(myIntArray2, 0,
                         myIntArray1, 0, 3);
        myIntArray3 = java.util.Arrays.copyOfRange(copyFrom, 0, 3);

        // ternary operator
        return_value = (true-false condition)
                     ? (if true expression)
                     : (if false expression);

        // do-while (statement always executes once!)
        do {
            statement(s)
        } while (expression);

        // branch labels
        outer:
            for (int i = 0; i < 10; i++) {
                for (int j = 0; j < 3; j++) {
                    System.out.println(i + " - " + j);
                    if (j == 1)
                        // this usually defaults to inner
                        // continue outer;
                        break outer;
                }
            }



    }
}
```

### Streams

A few streams that you should be aware of:

* `Input/OutputStream`
  * `ByteArrayInput/OutputStream`
  * `PipedInput/OutputStream`
  * `FileInput/OutputStream`
* `Reader/Writer`
  * `CharArrayReader/Writer`
  * `StringReader/Writer`
  * `PiperReader/Writer`
  * `InputStreamReader/Writer`

```java
// This is similar to with() in Python
// We don't have do to a finally {f.close()}
try (Reader reader = Helper.openReader("foo.txt")
     Writer writer = Helper.openWriter("bar.txt")) {
         // Do something
// Will caputre the exception in the try {}
// To access additional exceptions thrown by the f.close()
// They exist in the ex.getSuppressed()
} catch (IOException ex) {
    // This captures the exceptions from f.close() but
    // e.g. if reader in the try{}
}
```

You can also use `BufferedReader/Writer` for optimisations with line-endings and buffering data from file IO.

Actually, what you should use is the `java.nio.file` packages that provide additional features and optimisations. Basically prefix everything with `new`.

### ArrayList vs LinkedList

```java
// LinkedList<E>

get(int index)              // O(n)
add(E element)              // O(1)
add(int index, E element)   // O(n)
remove(int index)           // O(n)
Iterator.remove()           // O(1)
ListIterator.add(E element) // O(n)

// ArrayList<E>

get(int index)              // O(1)
add(E element)              // O(1) amortized
                            // O(n) worst-case since the array
                            //      must be resized and copied
add(int index, E element)   // O(n)
remove(int index)           // O(n)
Iterator.remove()           // O(n)
ListIterator.add(E element) // O(n)
```

## String manipulation

```java
// Joining strings
// {foo, bar}
// for [foo, bar] use  StringJoiner("], [", "[", "]")
StringJoiner str = new StringJoiner(", ", "{", "}");
str.setEmptyValue("deadbeef"); // delimters and start/end make a difference
str.add("foo");
str.add("bar");
String joinedStr = str.toString();

// Formatting strings
// % [arguement index][flags][width][precision] conversion
String formattedStr = String.format("Hi, I'm %s and I'm %d years old",
                                   "Geoff", 23);
formattedStr = String.format("Pi = %.2f", Math.PI);
formattedStr = String.format("Hex: %.#x", 16); // "Hex: 0x10
formattedStr = String.format("%$1d, %$2f, %$1d", 1, 2.0); // "Hex: 0x10

```

## Collections


## Annotations

```java
public @interface myAnnotation {
    boolean useThreadPool;
}
```

## Multi-threading

### Thread

You can manually control the threading with the `Thread` class:

```java
// Adder.java
public class Adder implements Runnable {
    public void doAdd() throws IOException {}

    // Implement the run method
    public void run() {
        try {
            doAdd();
        } catch(IOException ex) {
            // Used if your adding is reading files etc.
        }
    }
}

// ThreadedAdder.java
for (int i = 0; i < 10; i++) {
    Adder a = new Adder();
    Thread t = new Thread(a);
    t.start();
}
```

### ThreadPool

Like Python, you can use a `ThreadPool` so you can have a dynamic sized pool of threads do automatically do manage your threads of work. Much better than do this yourself with `Thread` - high error-prone.

The example below is using the `Runnable` interface which is very simple.

```java
// ThreadedPoolAdder.java
private static final int NUM_WORKER_THREADS = 3;
ExecutorService executorService = Executors.newFixedThreadPool(NUM_WORKER_THREADS);

// Submit the tasks to the worker threads
for (int i = 0; i < 10; i++) {
    Adder a = new Adder();
    executorService.submit(a);
}

// Clean-up and wait for the work threads to complete
try {
    bool shutdownTimedOut = !executorService.shutdown();
    executorService.awaitTermination(60, TimeUnit.SECONDS);
} catch (InterruptedException ex) {
    // If interrupted while waiting
} finally {
    if (shutdownTimedOut)
        System.out.println("Timeout elapsed before termination");
}
```

#### Callable

An even more robust solution provided by Java is using the `Callable` interface which allows the threads to return a result type **and** any exceptions!

```java
// Adder.java
public class Adder implements Callable<Integer> {
    // Do a dumb total but you see where this is going
    public int doAdd() {
        int total = 0;
        return total;
    }

    // Implement the call method and we can throw exceptions
    // and let the parent/process handle the execeptions
    public Integer call() throws IOException {
        return doAdd();
    }
}

// ThreadedPoolAdder.java
private static final int NUM_WORKER_THREADS = 3;
private static final int NUM_TASKS = 10;
ExecutorService executorService = Executors.newFixedThreadPool(NUM_WORKER_THREADS);

// Keep an array of the results
Future<Integer>[] results = new Future[NUM_TASKS];

// Submit the tasks to the worker threads
for (int i = 0; i < NUM_TASKS; i++) {
    Adder a = new Adder();
    results[i] = executorService.submit(a);
}

// Results and exception handling
for(Future<Integer> result: results) {
    try {
        result.get(60, TimeUnit.SECONDS); // Blocking until return result is available
    } catch (ExecutionException ex) {
        Throwable adderEx = ex.getCause();
        // This can be the IOException that we throw in Adder()
    } catch (TimeoutException ex) {
        System.out.println("Timeout waiting for thread");
    }
}
```

#### Concurrency

You can synchronize at the method level if you want which enables mutually exclusive access on the class instance - no other thread can access the object.

```java
public synchronized foo() {
    balance++;
}
```

**You need to be aware of the limitations of synchronized methods because you can introduce race conditions if you are not careful**

An example of this is if, in a non-synchronized method you call 2 synchronized methods, if the thread is yielded on another thread in between the invocations - you now have a race condition!

```java
// Method level sychronization
public void run() {
    int b = getBalance();

    // Even if both methods were synchronized, if the thread
    // has yielded here - race condition
    setBalance(++b);
}

// Manual sychronization
public void run() {

    // Synchronize the object reference and now getBalance and SetBalance
    // doesn't have to be synchronized
    synchronized (account) {
        int b = getBalance();
        // More complex stuff here can be added too
        setBalance(++b);
    }
}

```

## Logging

It's important to understand how you can take advantage of the hierachial logging you can configure in Java i.e. you can have a parent logging configuration and have the childs inherit this.

```java
// com.parent.package

// com.parent.package.child.Main

```

## Regex

|Symbol   |Description|
|---------|----------------------------------------------------------------|
|`\w`     |match word - letter, digit, underscore |
|`\b`     |word break/space |

## Encapsulation

> Encapsulation in Java is a mechanism of wrapping the data (variables) and code acting on the data (methods) together as a *single unit.*

> In encapsulation, the variables of a class will be hidden from other classes, and can be accessed *only* through the methods of their current class. Therefore, it is also known as **data hiding**.

### Members

Also known as access control modifiers.

* `public`: the class/variable/method is accessible and available to all the other objects in the system.
* `private`: the class/variable/method is accessible and available within **this class only**.
* `static`: they belong to the **class** instead of a specific instance. All instances will shared this field.
* `final`: can only be initialised to **once** - compiler will check this.
  * `final static`: useful for making a static constant for all classes.
  * compiler doesn't care about the value, only the reference - see [More confusing stuff](#more-confusing-stuff)

|Modifier      |Class|Package|Subclass|World|
|--------------|-----|-------|--------|-----|
|`public`      |Y    |Y      |Y       |Y    |
|`protected`   |Y    |Y      |Y       |N    |
|`no modifier` |Y    |Y      |N       |N    |
|`private`     |Y    |N      |N       |N    |

### More on static methods

* A `static` method *belongs to the class* rather than object of a class.
* A `static` method can be invoked without the need for creating an instance of a class.
* A `static` method can access static data member and **can change** the value of it.

### More on final

* If you have initialised a `final` variable, then you cannot change it to refer to a different object.
* `final` classes cannot be sub-classed
* `final` methods cannot be overridden.
* `final` methods can override.

### More confusing stuff

```java
// scenario 1
class Hello {
    private final List li;  // instance variable

    // constructors are only called once so this is safe
    public Hello() {
        li = new ArrayList();
        li.add(1000);  // fine
    }
}

// scenario 2
class Hello {
    private static final List li = new ArrayList();

    public Hello() {
        // li is not longer an instance variable
        // so any changes are reflected at the Class level
        li.add(1000);
    }
}

// scenario 3
class Hello {
    // only reference once and belongs to the Class
    private static final List li;

    // remember, constructors are called once per instance
    // however, li belongs to Hello and therefore we cannot
    // change where it references - hence compiler error
    public Hello() {
        li = new ArrayList();  // compiler error
        li.add(1000);
    }
}

```

Explanation:

* *Scenario 1*: this is fine since the compiler knows that constructors are called only **once** for instances and since `List li` is an instance variable - this is safe.
* *Scenario 2*: now `List li` is a class variable that is initialised once at the top. We can mutate the list and will be seen in all instances of `Hello`.
* *Scenario 3*: we attempted to initialise a class variable in the constructor - but `List li` no longer belongs to an instance so therefore attempting to **change the value** of `List li` every time a new instance is created!


### Methods

* Instance methods: can access **instance** variables and **instance** methods directly.
* Instance methods: can access **class** variables and **class** methods directly.
* Class methods: can access **class** variables and **class** methods directly.
* Class methods: **cannot** access **instance variables or instance methods** directly - they must use an object reference.
  * Also, class methods **cannot** use the `this` keyword as there is **no** instance for `this` to refer to.

You can also have a **static block**:

* Is used to initialise the `static` data member - but not instance variables!.
* It is executed before main method at the time of classloading.

```java
class Example {
    public static String staticString;

    static {
        staticString = "Static block example - initialised before main!";
    }
}
```

## UML

```text
+: public
-: private

Object:
+------------------+
| ClassName        |
+------------------+
| +rad:double=1.0  |
| -area:float=0.0  |
+------------------+
| +getArea():float |
+------------------+

Instance:
+------------------+
| c1               |
+------------------+
| +rad:double=3.3  |
| -area:float=0.0  |
+------------------+
| +getArea():float |
+------------------+



                          +------------------+
                          | Shape            |
                          |------------------|
                          |-color:String     |
                          |------------------|
                          |+getArea():double | // abstract methods should be italics
                          |+toString():String| // normal default implemented method
                          +---------.--------+
                                   /_\
                                    |
             +----------------------+--------------------+
             |                                           |
    +------------------+                         +------------------+
    | Rectangle        |                         | Triangle         |
    +------------------+                         +------------------+
    |+length:int       |                         |+base:int         |
    |+width:int        |                         |+height:int       |
    +------------------+                         +------------------+
    |+getArea():double |                         |+getArea():double | // subclass implements
    |+toString():String|                         |+toString():String| // overrides parent
    +------------------+                         +------------------+

```

## Overloading

* If two methods have the same name but different arguments, they can be **overridden**.
* You can also do this with `constructors`.
* It is used so for different number of args and types, you don't have to add a new method - use sparingly as it decreases readability.

```java
public class TestMethodOverloading {

   public static int average(int n1, int n2) {          // version A
      System.out.println("Run version A");
      return (n1+n2)/2;
   }
   public static double average(double n1, double n2) { // version B
      System.out.println("Run version B");
      return (n1+n2)/2;
   }

   public static void main(String[] args) {
      System.out.println(average(1, 2));     // vA
      System.out.println(average(1.0, 2.0)); // vB

      // vB - int(2) implicitly casted to double(2.0)
      System.out.println(average(1.0, 2));

      // Compilation Error - No matching method
      // average(1, 2, 3, 4);
   }
}
```

## Misc

**`this`**

* `this.varName` refers to `varName` of this instance; `this.methodName()` invokes `methodName()` of this instance.
* In a **constructor**, we can use `this()` to call **another** constructor of this class.
* Inside a **method**, we can use the statement "return this" to return **this** instance to the caller.

**`final`**

* A `final` **primitive** variable cannot be re-assigned a new value.
* A `final` **instance** cannot be re-assigned a new object.
* A `final` **class** cannot be sub-classed (or extended).
* A `final` **method** cannot be overridden.

**`isinstanceof`**

* Returns `true` if an object is an instance of a particular class.
* See also [Down-casting](#down-casting).

### Reference passing

[Java docs about passing by value](https://docs.oracle.com/javase/tutorial/java/javaOO/arguments.html)

* For **primitive** types, Java passes by **value** - so once the method returns, the argument that was passed doesn't retain the modified value.
* For **reference** types, Java also passes by **value** - this means the value the object references **can change** but **not where it's pointing to!**
  * i.e. you can't change where the reference (or pointer) points to e.g. `ref = new Object();`

## Classes

There's a lot to cover but some funky things:

* Nested and local classes
* Anonymous classes

### Anonymous class

* An anonymous class has access to the members of its **enclosing** class.
* An anonymous class cannot access local variables in its enclosing scope that are **not** declared as `final` or effectively final.
* Like a nested class, a declaration of a type (such as a variable) in an anonymous class **shadows** any other declarations in the enclosing scope that have the same name.
* Anonymous classes also have the same restrictions as local classes with respect to their members:
* You **cannot** declare `static` initializers or member interfaces in an anonymous class.
* An anonymous **class** can have `static` members provided that they are **constant** variables.

Note that you can declare the following in anonymous classes:

* Fields
* Extra methods (even if they do not implement any methods of the supertype)
* Instance initializers
* Local classes

```java
public class Hello {

    public static void main(String[] args) {

        World helloWorld = new World() {
            // You can define local members here but no constructors!
            public void printStuff() {
                System.out.println("Hello world!");
            }
        }
    }
}
```

## OO Designs

* [Composition](#composition)
* [Inheritance](#inheritance)
* [Polymorphism](#polymorphism)
* [Abstract](#abstract)

### Composition

Pretty standard, you're using existing objects inside the `Class`.
With composition (aka aggregation), you define a new class, which is composed of existing classes.

```java
public class Book {

   private String name;
   private Author author; // Contains only one Author
   ...
```

**UML:**

```text
+-------+       +-------+
| Book  |<>----1| Author|
+-------+       +-------+
```

### Inheritance

* In OOP, we often organize classes in hierarchy to avoid duplication and reduce redundancy.
* The classes in the **lower hierarchy inherit** all the variables (`static` attributes) and methods (dynamic behaviors) from the higher hierarchies.
* A class in the lower hierarchy is called a subclass (or **derived**, child, extended class). A class in the upper hierarchy is called a superclass (or base, parent class).
* By pulling out all the **common** variables and methods into the superclasses, and leave the **specialized** variables and methods in the subclasses, redundancy can be greatly reduced or eliminated as these common variables and methods do not need to be repeated in all the subclasses.

For example:

```text
                          +--------------+
                          | SoccerPlayer |
                          +-------.------+
                                 /_\
                                  |
           +----------------------+--------------------+
           |                                           |
  +----------------+                         +------------------+
  | Forward        |                         | Reserve          |
  +----------------+                         +------------------+
```

```java
class Goalkeeper extends SoccerPlayer {......}
...

public class Cylinder extends Circle {

   private double height;    // private instance

   // Constructors - overloading!
   public Cylinder() {
      super();               // invoke superclass' constructor Circle()
      this.height = 1.0;
   }

   public Cylinder(double height) {
      super();               // invoke superclass' constructor Circle()
      this.height = height;
   }

   public Cylinder(double height, double radius) {
      super(radius);         // invoke superclass' constructor Circle(radius)
      this.height = height;
   }

   // invoke superclass' constructor Circle(radius, color)
   public Cylinder(double height, double radius, String color) {
      super(radius, color);  // invoke superclass' constructor Circle(radius, color)
      this.height = height;
   }
   ...
```

#### Method overriding and hiding

* Using the `@Override` annotation, this is actually optional. But it is explicit and prevents mistypes.

```java
public class Cylinder extends Circle {
...

   // Override the getArea() method inherited from superclass Circle
   @Override
   public double getArea() {
      return 2*Math.PI*getRadius()*height + 2*super.getArea();
   }

   // And so on, for a cylinder, you should override volume, etc.
   // Remember about private members - hence the use of public methods
}
```

#### super

* `super` refers to the superclass, which could be the immediate **parent** or its **ancestor**.
* It allows the subclass to access superclass' methods and variables within the subclass' definition.

For example:

* `super()` and `super(argumentList)` can be used invoke the superclass’ constructor.
* If the subclass overrides a method inherited from its superclass, says `getArea()`, you can use `super.getArea()` to invoke the **superclass' version** within the subclass definition.
* Similarly, if your subclass **hides** one of the superclass' variable, you can use `super.varName` to refer to the hidden variable within the subclass definition.

#### Constructors

  Recall that the subclass inherits **all** the variables and methods from its superclasses. Nonetheless, the subclass **does not inherit the constructors** of its superclasses. Each class in Java defines its own constructors.

  In the body of a constructor, you can use `super(args)` to invoke a constructor of its immediate superclass. Note that super(args), if it is used, must be the **first statement in the subclass' constructor**.

  If it is **not** used in the constructor, Java compiler automatically insert a `super()` statement to invoke the no-arg constructor of its immediate superclass. This follows the fact that the *parent must be born before the child* can be born. You need to properly construct the superclasses before you can construct the subclass.

#### Default no-arg constructors

If **no** constructor is defined in a class, Java compiler automatically create a no-argument (no-arg) constructor, that simply issues a `super()` call, as follows:

```java
// if no constructor is defined in a class,
// compiler inserts this no-arg constructor
public ClassName()
{
   super();   // call the superclass' no-arg constructor
}
```

  The default no-arg constructor will **not** be automatically generated, if **one (or more) constructor was defined**. In other words, you need to define no-arg constructor explicitly if other constructors were defined.

  If the immediate superclass does not have the default constructor (it defines some constructors but does not define a no-arg constructor), you will get a compilation error in doing a super() call. Note that Java compiler inserts a super() as the first statement in a constructor if there is no super(args).

### Polymorphism

So stemming from the definition of something having many forms, Java uses this to describe how an object can be many things.

For example:

```java
interface Vehicle {}
class MotorBike {}
class RacingBike extends MotorBike implements Vehicle {}

// a RacingBike is a MotorBike
// a RacingBiki is a Vehicle
// a RacingBiki is an object
//
// but that is not the case in the reverse
// i.e. an object is/may not be a RacingBike
```

#### Substitution

  A subclass possesses all the attributes and operations of its superclass (because a subclass inherited all attributes and operations from its superclass).

  This means that a subclass object can do whatever its superclass can do. As a result, we can substitute a subclass instance when a superclass instance is expected, and everything shall work fine. This is called substitutability.

An example:

```java
// Substitute a subclass instance to a superclass reference
// Compiler checks to ensure that R-value is a subclass of L-value.
// Known as up-casting (Circle == superclass)
Circle c1 = new Cylinder(1.1, 2.2);

// You can invoke all the methods defined in the Circle class for the reference c1
// Invoke superclass Circle's methods
c1.getRadius();

// CANNOT invoke method in Cylinder as it is a Circle reference!
c1.getVolume();  // compilation error
```

Explaination:

* The error is because `c1` is a **reference** to the Circle class, which does **not** know about methods defined in the subclass Cylinder.
* `c1` is a reference to the Circle class, but holds an **object of its subclass Cylinder**.
* `c1` retains its internal identity. In our example, the subclass Cylinder overrides methods `getArea()` and `toString()`.
* `c1.getArea()` or `c1.toString()` invokes the **overridden** version defined in the subclass Cylinder, instead of the version defined in Circle. **This is because c1 is in fact holding a Cylinder object internally.**

```java
// But c1 runs the Cylinder overriden methods
c1.toString();  // Run the overridden version!
c1.getArea();   // Run the overridden version!
```

#### Summary

* A subclass instance can be assigned (substituted) to a superclass' reference.
* Once substituted, we can invoke methods defined in the superclass; we **cannot** invoke methods defined in the subclass when up-casting.
* However, if the **subclass overrides** inherited methods from the superclass, the subclass' (overridden) versions will be invoked.This is the default case.

#### Up-casting

* Substituting a *subclass instance* for its superclass is called **upcasting**.
* Upcasting is always safe because a subclass instance possesses **all** the properties of its superclass and can do whatever its superclass can do - compiler checks for your stupid errors.
* If in your derived class, you also implement an interface - when upcasting, the extended interface methods are **not seen** and you need to cast it explicitly.

```java
List l = new ArrayList();  // ArrayList is a subclass of List (safe upcast)

// example when we implement an interface in a derived class
class Animal {}

interface Meow {
    public sayMeow() {
        System.out.println("Meooowww!");
    }
}

class Cat extends Animal implements {}

Animal cat = new Cat();
cat.sayMeow();        // compile error: cannot find symbol
((Cat)cat).sayMeow()  // "Meooowww!"
```

Reasons for using up-casting:

* If you want to replace one implementation with another, you can do it with minimal coding e.g. if you are currently using `ArrayList` and looking to change it to `LinkedList`, just change the place where the object is created.
* API support - consider you got a 3rd party library which restricts you to use `ArrayList`. You can't use that library for code which uses `LinkedList`.
* Code re-usability - the parent class methods can be re-written and all derived classes will be using the new implementations providing no overriding occurred.

#### Down-casting

* You can revert a substituted instance back to a subclass reference. This is called "downcasting".
* A better example of down-casting would be: *a Cat is always an Animal but an Animal isn't always a Cat!*

For example:

```java
Circle c1 = new Cylinder(1.1, 2.2);  // upcast is safe
Cylinder cy1 = (Cylinder) c1;        // downcast needs the casting operator

// The above is usually checked at compile time - if at runtime:
Circle c1 = new Circle(5);
Point p1 = new Point();

// compilation error: incompatible types (Point is not a subclass of Circle)
c1 = p1;

// runtime error: java.lang.ClassCastException: Point cannot be casted to Circle
// since Circle is not a subclass of Point!
c1 = (Circle)p1;
```

* Down-casting requires explicit type casting operator in the form of prefix operator (new-type).
* Down-casting is not always safe, and throws a runtime `ClassCastException` if the instance to be downcasted **does not** belong to the correct subclass.
* A subclass object can be substituted for its superclass (substitution), but the **reverse is not true**.

```java
// An instance of subclass is also an instance of its superclass
// No upcasting here
Circle c1 = new Circle(1.1);  // a Circle objext
Cylinder cy1 = new Cylinder(2.2, 3.3);  // a Cylinder object

System.out.println(c1 instanceof Circle);    // true
System.out.println(c1 instanceof Cylinder);  // false
System.out.println(cy1 instanceof Cylinder); // true
System.out.println(cy1 instanceof Circle);   // true

// upcast Cylinder
Circle c2 = new Cylinder(4.4, 5.5);
System.out.println(c2 instanceof Circle);    // true
System.out.println(c2 instanceof Cylinder);  // true
```

#### Polymorphism summary

* A subclass instance processes *all the attributes operations* of its superclass.
* When a superclass instance is expected, it can be substituted by a subclass instance - it is called **substitutability**.
* If a subclass instance is assign to a superclass reference, you can invoke the methods defined in the **superclass only**. You **cannot** invoke methods defined in the subclass.
* However, the substituted instance retains its own identity in terms of overridden methods and hiding variables. If the subclass overrides methods in the superclass, the subclass's version will be executed, **instead** of the superclass's version.

### Abstract classes & interfaces

Basically interfaces acts as **rules** - they must be implemented. Abstract classes however, allow the flexibility of partial implementations as well as allowing private members, etc. (though Java 9 does allow more flexibility with interfaces)

An `abstract` method is a method with only signature (i.e. the method name, the list of arguments and the return type) without implementation (i.e. the method's body).

An example `abstract` class:

```java
abstract public class Shape {
    private String name;

    // we don't know the area since we don't know what type of shape it is!
    abstract public double getArea();
}
```

* `abstract` classes can't be instantiated; just like interfaces
* An `abstract` method cannot be declared `final`, as `final` method cannot be overridden
* An `abstract` method, on the other hand, must be overridden in a **descendant** before it can be used.
* An `abstract` method cannot be `private` (which generates a compilation error). This is because `private` method are *not* visible to the subclass and thus cannot be overridden!

#### Interfaces

* Enforces an interface/protocol is implemented - allows you to program at the interface level not the implementation level
* Can contain constants `public static final` - not recommended in the case of multiple inheritance
* Is a `public abstract class` by default **without any** implementations -  all methods must be implemented
* Polymorphism can be used with interfaces like normally

Changes in later versions of Java:

* Java 8: `default`, `static` methods supported
* Java 9: `private` methods supported

```java
// formal syntax
[public|protected|package] interface interfaceName
[extends superInterfaceName] {
   // constants
   static final ...;

   // public abstract methods' signature
   // or default, static, private ...
   ...
}
```
