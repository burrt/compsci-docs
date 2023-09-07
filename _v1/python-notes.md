---
layout: compsci-note
title: Python Notes
categories: [language]
description: Some notes on Python
---

## Contents

* [Basics](#basics)
  * [Copy](#copy)
  * [Loops](#for-loops)
  * [Lists, generators etc.](#lists-generators-and-other-interesting-built-ins)
    * [map, filter, reduce](#map-filter-reduce)
  * [Dictionaries](#dictionaries)
  * [Time](#time)
  * [Logging](#logging)
  * [File](#file)
* [Time complexity](#time-complexity)
* [Classes](#classes)
* [Decorators](#decorators)
* [Threading](#threading)
* [Collections](#collections)
* [Regex](#regex)
* [Operator precedence](#operator-precedence)

## Links

* [Google Dev Python](https://developers.google.com/edu/python/)
* [Python 3.6 Docs](https://docs.python.org/3.6/)
* [Stack Overflow - Python yield](https://stackoverflow.com/questions/231767/what-does-the-yield-keyword-do)

## Quick style guide

```python
# 79 column rule
# module_name, package_name, ClassName, method_name,
# ExceptionName, function_name, GLOBAL_CONSTANT_NAME,
# global_var_name, instance_var_name, function_parameter_name,
# local_var_name
```

### Doc string

[Google example](https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html)

## Basics

```python
print(__name__)
if __name__ == '__main__':
    print 'match'
```

One of the use of this functionality to write various kind of unit tests within the same module. For example, you can just import many different modules you have written and call specific functions.

### Scoping

* `global` statement can be used to indicate that particular variables live in the global scope and should be rebound there.
* `nonlocal` statement indicates that particular variables live in an enclosing scope and should be rebound there.

```python
def scope_test():
    def do_local():
        spam = "local spam"

    def do_nonlocal():
        nonlocal spam
        spam = "nonlocal spam"

    def do_global():
        global spam
        spam = "global spam"

    spam = "test spam"
    do_local()
    print("After local assignment:", spam)
    do_nonlocal()
    print("After nonlocal assignment:", spam)
    do_global()
    print("After global assignment:", spam)

scope_test()
print("In global scope:", spam)

# After local assignment: test spam
# After nonlocal assignment: nonlocal spam
# After global assignment: nonlocal spam
# In global scope: global spam
```

### Sequences

There are three sequence types:

* [list](https://docs.python.org/3.3/library/stdtypes.html#list)
* [tuple](https://docs.python.org/3.3/library/stdtypes.html#tuple)
* [range](https://docs.python.org/3.3/library/stdtypes.html#range)

### List

These are mutable sequences that are used to store collections of homogeneous items.

#### Deque

Supports fewer operations but faster for adding/removing from the head/tail of the queue - `O(1)`. See [the docs](https://docs.python.org/3/library/collections.html#collections.deque).

### Tuple

These are immutable sequences and assignment to its members aren't possible however they may contain mutable objects like lists.

#### Named tuple

See [the docs for more info](https://docs.python.org/3.3/library/collections.html#collections.namedtuple).

### Range

The `range` type is similar to Python 2.7 `xrange` where it has constant space cost - small memory usage like generators.

### Misc

```python
# a if condition else b
x = 100 if True else 0

# lists
l = [1, 2] + [2, 3]  # l += list(range(10))
l[-1]                # last element

# slicing
# sublist will include the element at the lower bound
# but exclude the element at the upper bound
sublist = list(range(1, 11))[3: -1]

# *args, **kwargs
def foo(parg, *args, **kwargs):
    print("Positional argument: {0}".format(parg))
    for i, a in enumerate(args):
        print("Arg {0}: {1}".format(i, a))
    for k, v in kwargs.items():
        print("{0}: {1}".format(k, v))

# now call the function and do cool things with unpacking
list_args = ['arg2', 'arg3', 'arg4']
dict_args = {'karg1': 1, 'karg2': 2, 'karg3': 3}
foo('pos1 arg', *list_args, **dict_args)

# print formatting
print("Float with 2 decimal places: {0:.2f}".format(10.111))
print("Decimal padded (left justified): {0:10d}".format(100))
print("Decimal padded (right justified): {0:>10d}".format(100))
print("String padded: {0:20}, end of padding.".format("Short String"))
```

### `is` vs `==`

* `is` checks that 2 arguments refer to the **same object**.
* `==` checks that 2 arguments have the **same value**.

```python
1 == True  # True
1 is True  # False

# dir(1) == dir(True)
# these return the namespace list from both instances
# both lists contain the same values
# BUT they are not the same instance
# hence why the *is* will fail

# another example
list(range(1) == list(range(1))  # True
list(range(1) is list(range(1))  # False
```

### iterables and iterators

See the [Stack Overflow post](https://stackoverflow.com/questions/9884132/what-exactly-are-pythons-iterator-iterable-and-iteration-protocols) for more explanations.

An **iterable** is:

* anything that can be looped over (i.e. you can loop over a string or file) or
* anything that can appear on the right-side of a for-loop: `for x in iterable:`
* anything you can call with `iter()` that will return an **iterator** e.g. `iter(obj)`
* an object that defines `__iter__` that returns a fresh **iterator**, or it may have a `__getitem__` method suitable for indexed lookup.
* **no** state!

An **iterator** is an **object**:

* with _state_ that remembers where it is during iteration
* with a `__next__` method that:
  * returns the next value in the iteration
  * updates the state to point at the next value
  * signals when it is done by raising `StopIteration`
  * is self-iterable (meaning that it has an `__iter__` method that returns `self`).
  * `next(iterator)` calls `__next__` on the iterator.

In a `for` loop:

```python
iterable_obj = 'abcde'  # immutable, no state
iterator_obj = iter(iterable_obj)  # this calls iterable_obj.__iter__()

# now emulate the for loop
while True:
    try:
        next(iterator_obj)  # calls iterator_obj.__next__()
    except StopIteration:
        break
```

### View objects

They provide a **dynamic** view on the dictionary's entries, which means that when the dictionary changes, the view **reflects** these changes.

See [the docs](https://docs.python.org/3/library/stdtypes.html#dictionary-view-objects) for more info.

### LEGB-rule

`Local -> Enclosed -> Global -> Built-in`

Where the arrows should denote the direction of the namespace-hierarchy search order.

1. **Local** can be inside a function or class method, for example.
2. **Enclosed** can be its enclosing function, e.g., if a function is wrapped inside another function.
3. **Global** refers to the uppermost level of the executing script itself

### For loops

* `range(0, 10)` returns an immutable `range` type - iterator, so you need to cast it as `list(range(10))`.
* Use of other built-ins like `reversed()`, `sorted()`, `list.sort()`.

```python
num_list1 = list(range(10, 20)) # Python 3
num_list2 = list(range(20, 30))

# get index and value
for i, v in enumerate(num_list1):
    print('index: {0}, value: {1}'.format(i, v))

# iterate over both lists at the same time
for x, y in zip(num_list1, num_list2):
    print('item1: {0}, item2: {1}'.format(x, y))
```

### Copy

Assignment statements in Python **do not** copy objects, they create **bindings** between a target and an object.
For collections that are **mutable or contain mutable items**, a copy is sometimes needed so one can change one copy without changing the other.

Basically:

* A **shallow copy** constructs a new compound object and then (to the extent possible) inserts references into it to the objects found in the original. This is is okay for flat mutable objects.
* A **deep copy** constructs a new compound object and then, recursively, inserts copies into it of the objects found in the original. Use this for nested lists.

```python
import copy as c

# for flat immutable objects
l1 = list(range(10))
l2 = c.copy(l1)  # create a shallow copy
l3 = l1[:]  # create a shallow copy

# for nested
l1 = [list(range(10)), 10, 11, 12]

l2 = c.copy(l1)  # shallow copy
l2[0][0] = 111111  # this also changes l1
print(l1)  # [[111111, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 11, 12]

# solution
l1 = [list(range(10)), 10, 11, 12]
l3 = c.deepcopy(l1)  # deepcopy recursively copies objects
l3[0][0] = 111111
print(l1)  # [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 11, 12]
```

### Lists, generators and other interesting built-ins

For Python 3.x:

> Removed reduce(). Use functools.reduce() if you really need it; however, 99 percent of the time an explicit for loop is more readable.

```python
# built-in functions
q, r = divmod(9, 4)  # 9//4 == 2, 9-(4*2) == 1

# returns the concatenation of the strings in the sequence seq.
dash_delimted_str = '-'.join(['a', 'b', 'c'])

number_list = list(range(10))

# basic list comprehension
# some_list = [ <output value> for <element> in <list> <optional criteria> ]
#
squared_list = [x**x for x in number_list if x < 5]
filtered_list = [x if x < 10 else -1 for x in number_list]

# using built-in filter
def less_than_five(x):
    return x < 5

filtered_list = list(filter(less_than_five, number_list))
# using lambda
filtered_list = list(filter(lambda x: x < 5, number_list))
```

#### map, filter, reduce

```python
# filter(function, sequence)
# applies the function to each element of the sequence
def three_five(x):
    return x % 3 == 0 or x % 5 == 0

filter(three_five, range(100))
filter(lambda x: x % 3 == 0 or x % 5 == 0, range(100))

# map(function, sequence)
# calls function(element) of the sequence and returns the result as a list
def expd(x):
    return x**x

map(expd, range(10))

# functools.reduce(function, sequence)
# returns a single value constructed by calling the binary function function
# on the first two items of the sequence, then on the result and
# the next item, and so on
def sum(seq):
    def add(x, y):
        return x + y
    return reduce(add, seq)

# sum is a built-in, but this is how it's implemented
sum(range(1, 11))

def total(x, y):
     return x + y

reduce(total, range(1, 11))
```

### Dictionaries

Thank god Python 3 reduced the number of functions for iterating over a dictionary!

```python
dict.items()
dict.keys()
dict.values()

# Return an **view** over the dictionary’s (k, v) pair, keys and values.
# Remember, these are dynamic views of the dictionary itself!

# other
dict.pop(key)
dict.clear()
```

### Time

* There's a lot of things you can do with it - just refer to the docs everytime..
  * [datetime](https://docs.python.org/3/library/datetime.html)
  * [time](https://docs.python.org/3/library/time.html)
  * [pytz](https://pypi.python.org/pypi/pytz) - for timezone conversions

```python
import datetime
import time

# getting current date time with milliseconds
# remember: datetime isn't time locale aware!
curr_local_datetime = datetime.datetime.now()  # local time
curr_utc_datetime = datetime.datetime.utcnow()  # utc time

# getting current epoch time
time.time()  # seconds by default (float)
cur_utc_epoch = datetime.utcnow().timestamp()  # converting from datetime

# converting epoch to datetime
curr_utc_datetime = datetime.utcfromtimestamp(time.time())

# strip the milliseconds from the time and convert to string
curr_local_str = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
curr_utc_str = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(time.time()))

# getting the minutes/seconds etc.
curr_local_datetime.minute

# adding minutes/seconds to a datetime
# far easier to convert to epoch and add seconds
curr_local_datetime += datetime.timedelta(minutes=1, seconds=1)
curr_utc_epoch = time.time() + 61
```

### Bit manipulation

```python
"cd".encode("hex")  # '6364'
hex(10)  # 0xa
```

### Logging

* [More from the docs](https://docs.python.org/3/howto/logging.html)

```python
import logging

logging.basicConfig(filename='logfile.log',
                    filemode='a',
                    format='%(asctime)s,%(msecs)d %(name)s '
                           '%(levelname)s %(message)s',
                    datefmt='%H:%M:%S',
                    level=logging.DEBUG)
```

### File

File open modes

| Char | Meaning                                                         | Further desc                                                                                                                                               |
|------|-----------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 'r'  | open for reading (default)                                      |                                                                                                                                                            |
| 'w'  | open for writing, truncating the file first                     |                                                                                                                                                            |
| 'x'  | open for exclusive creation, failing if the file already exists |                                                                                                                                                            |
| 'a'  | open for writing, appending to the end of the file if it exists |                                                                                                                                                            |
| 'b'  | binary mode                                                     | Return contents as bytes objects without any decoding                                                                                                      |
| 't'  | text mode (default)                                             | Contents of the file are returned as str, the bytes having been first decoded using a platform-dependent encoding or using the specified encoding if given |
| '+'  | open a disk file for updating (reading and writing)             |                                                                                                                                                            |
| 'U'  | universal newlines mode (deprecated)                            |                                                                                                                                                            |

## Time complexity

Some of the optimized data structures Python for better performance summarized from the [Python wiki](https://wiki.python.org/moin/TimeComplexity).

For additional information for time complexity, see my [other page](https://github.com/burrt/debian/wiki/Sorting-&-searching#big-o)

### list

| Operation        | Average Case | Amortized Worst Case |
|------------------|--------------|----------------------|
| Copy             | `O(n)`       | `O(n)`               |
| Append[1]        | `O(1)`       | `O(1)`               |
| Pop last         | `O(1)`       | `O(1)`               |
| Pop intermediate | `O(k)`       | `O(k)`               |
| Insert           | `O(n)`       | `O(n)`               |
| Get Item         | `O(1)`       | `O(1)`               |
| Set Item         | `O(1)`       | `O(1)`               |
| Delete Item      | `O(n)`       | `O(n)`               |
| Iteration        | `O(n)`       | `O(n)`               |
| Get Slice        | `O(k)`       | `O(k)`               |
| Del Slice        | `O(n)`       | `O(n)`               |
| Set Slice        | `O(k+n)`     | `O(k+n)`             |
| Extend[1]        | `O(k)`       | `O(k)`               |
| Sort             | `O(n log n)` | `O(n log n)`         |
| Multiply         | `O(nk)`      | `O(nk)`              |
| x in s           | `O(n)`       |                      |
| `min(s), max(s)` | `O(n)`       |                      |
| Get Length       | `O(1)`       | `O(1)`               |

### collections.deque

| Operation  | Average Case | Amortized Worst Case |
|------------|--------------|----------------------|
| copy       | `O(n)`       | `O(n)`               |
| append     | `O(1)`       | `O(1)`               |
| appendleft | `O(1)`       | `O(1)`               |
| pop        | `O(1)`       | `O(1)`               |
| popleft    | `O(1)`       | `O(1)`               |
| extend     | `O(k)`       | `O(k)`               |
| extendleft | `O(k)`       | `O(k)`               |
| remove     | `O(n)`       | `O(n)`               |

### set

| Operation                           | Average Case            | Amortized Worst Case                            | Notes                                      |
|-------------------------------------|-------------------------|-------------------------------------------------|--------------------------------------------|
| x in s                              | `O(1)`                  | `O(n)`                                          |                                            |
| Union `s\|t`                        | `O(len(s)+len(t))`      |                                                 |                                            |
| Intersection `s&t`                  | `O(min(len(s), len(t))` | `O(len(s) * len(t))`                            | replace "min" with "max" if t is not a set |
| Multiple intersection `s1&s2&..&sn` |                         | `(n-1)*O(l) where l is max(len(s1),..,len(sn))` |                                            |
| Difference s-t                      | `O(len(s))`             |                                                 |                                            |

### dict

| Operation    | Average Case | Amortized Worst Case |
|--------------|--------------|----------------------|
| Copy[2]      | O(n)         | O(n)                 |
| Get Item     | O(1)         | O(n)                 |
| Set Item[1]  | O(1)         | O(n)                 |
| Delete Item  | O(1)         | O(n)                 |
| Iteration[2] | O(n)         | O(n)                 |

[1] = These operations rely on the "Amortized" part of "Amortized Worst Case". Individual actions may take surprisingly long, depending on the history of the container.

[2] = For these operations, the worst case `n` is the *maximum size* the container ever achieved, rather than just the current size. For example, if `N` objects are added to a dictionary, then `N-1` are deleted, the dictionary will still be sized for `N` objects (at least) until another insertion is made.

## Classes

* [Docs](https://docs.python.org/3/tutorial/classes.html)

Terms:

* data attributes: instance variables (don't need to be declared)
* method attributes

When a class definition is entered, a **new namespace** is created, and used as the local scope — thus, all assignments to local variables go into this new namespace. In particular, function definitions bind the name of the new function here.

When a class definition is left normally (via the end), a class object is created. This is basically a **wrapper** around the contents of the namespace created by the class definition. The original local scope (the one in effect just before the class definition was entered) is reinstated, and the class object is **bound** here to the **class name** given in the class definition header.

Also to note, when changing **class members**, these are remembered when creating **new instances** of that class e.g.

```python
class Foo():
    static_var = 0  # i realise this should be called class member...

print(Foo.static_var)  # 0
f = Foo()
print(f.static_var)  # 0

Foo.static_var = 100

print(f.static_var)  # 100
f.static_var = 99  # instance variable change
print(f.static_var)  # 99

ff = Foo()
print(ff.static_var)  # 100
```

### Inheritance

```python
# if an attribute is not found in the derived class namespace
# it is searched in the baseClassName and so on recursively
class DerivedClassName(modname.BaseClassName):
    class_var = 0  # class attribute

    def __init__(self):
        self.instance_var = 0

# multiple levels of inheritance
# attributes will be search DFS, left-right (simplified)
class DerivedClassName(Base1, Base2, Base3):

    # remember this will override the Base1 constructors!
    def __init__(self):
        # super can be used to access parent class members
        suer
```

* `isinstance(child, parent)`: if the child **type** is the same or some class derived from parent.
* `issubclass(child, parent)`: if child instance is a **subclass** (inheritance) of parent. e.g. `bool` is subclass of `int`.

### Private variables

Python doesn't support private variables (class-private members) but has some implementation detail and limited support for such mechanism called **name mangling**.

* `_var`: are by convention used for **semiprivate** variables for e.g. non-public api.
  * something minor, when doing `from foo import *`, `_names` are not included.
* `__var`: are by convention to indicate **private** variables.
  * they cannot be accessed normally e.g. `instance.__var` - exception
  * they are replaced with `_classname__var` to prevent **accidental** access.

### Misc

* you can make an **instance** callable - not class - by implementing the `__call__` method.

## Decorators

### Obvious ones

* `@classmethod`: function belongs to the **class** that it is in.
* `@staticmethod`: function is its **own** function - used for grouping/style e.g. like nested functions. It is useful for not polluting a module's namespace with free functions for example.

```python
class A(object):
    def foo(self,x):
        print("executing foo({0},{1})".format(self,x))

    @classmethod
    def class_foo(cls,x):
        print("executing class_foo({0},{1})".format(cls,x))

    @staticmethod
    def static_foo(x):
        print("executing static_foo({0})".format(x))
a = A()

a.foo(10)  # executing foo(<__main__.A object at 0x0000021ACE738F60>,10)
print(a.foo)  # <bound method A.foo of <__main__.A object at 0x0000021ACE738F60>>

a.class_foo(100)  # executing class_foo(<class '__main__.A'>,100)
print(a.class_foo)  # <bound method A.class_foo of <class '__main__.A'>>

a.static_foo(1000)  # executing static_foo(1000)
print(a.static_foo)  # <function A.static_foo at 0x0000021ACE73B9D8>
```

### Creating your own

Remember that decorators return the wrapped function i.e. a modified version of the function that was passed in as an argument. This can be resolved with `functools.wraps`. There are a few ways to use them:

* as classes
  * you must be aware that the `help()` may **not** work correctly
  * the workaround for decorators as wrappers is `functools.update_wrapper()`. This sets the attribute on the **instance** but `help()` looks at the class as it is always called as `help(instance)`. See more [here on stackoverflow](https://stackoverflow.com/questions/6394511/python-functools-wraps-equivalent-for-classes).
* as nested functions
* with/without arguments

Each method has a slightly different syntax that you should be aware of.
Useful links:

* [Python 3 decorators - better example](https://python-3-patterns-idioms-test.readthedocs.io/en/latest/PythonDecorators.html)
* [Python 3 decorators - quick examples](https://book.pythontips.com/en/latest/decorators.html)

#### Decorators with classes

```python
import functools

class decorator_without_arguments(object):

    def __init__(self, f):
        """If there are *no* decorator arguments, the function
        to be decorated is passed to the constructor.
        """
        print("Inside __init__()")
        self.f = f
        functools.update_wrapper(self, f)  # update __name__ etc. attributes

    def __call__(self, *args, **kwargs):
        """The __call__ method is not called until the
        decorated function is called.
        """
        print("Inside __call__()")
        self.f(*args, **kwargs)
        print("After self.f(*args, **kwargs)")

@decorator_without_arguments
def sayHello(a1, a2, a3, a4):
    print('sayHello arguments:', a1, a2, a3, a4)
```

```python
from functools import wraps
# notice the __init__ doesn't contain func
# notice there are 2 decorator args vs 3 function args
class decorator_with_arguments(object):

    def __init__(self, arg1, arg2):
        """If there are decorator arguments, the function
        to be decorated is *not* passed to the constructor!
        """
        print("Inside __init__()")
        self.arg1 = arg1
        self.arg2 = arg2

    def __call__(self, f):
        """If there are decorator arguments, __call__() is only called
        once, as part of the decoration process! You can only give
        it a single argument, which is the function object.
        """
        print("Inside __call__()")
        @wraps(f)  # updates __name__, __doc__ attributes etc.
        def wrapped_f(*args, **kwargs):
            print("Inside wrapped_f()")
            print("Decorator arguments:", self.arg1, self.arg2)
            f(*args, **kwargs)
            print("After f(*args, **kwargs)")
        return wrapped_f

@decorator_with_arguments("hello", "world")
def sayHello(a1, a2, a3):
    print('sayHello arguments:', a1, a2, a3)

sayHello("say", "hello", "argument")
sayHello("a", "different", "set of args")

# Inside __init__()
# Inside __call__()  # after decoration

# Inside wrapped_f()  # sayHello is called here
# Decorator arguments: hello world
# sayHello arguments: say hello argument list
# After f(*args)  # after first sayHello() call

# Inside wrapped_f()  # sayHello is called here
# Decorator arguments: hello world 42
# sayHello arguments: a different set of args
# After f(*args)  # after second sayHello() call
```

### Decorators with Functions

```python
def decorator_without_arguments(func):
    @wraps(func)
    def wrapped_func(*args, **kwargs):
        print('Inside wrapped_func - wrapping:', func.__name__)
        func(*args, **kwargs)
        print('Finished func(*args, **kwargs)')
    return wrapped_func
```

```python
def decorator_with_arguments(arg1, arg2):
    def wrapper(func):
        @wraps(func)
        def wrapped_func(*args, **kwargs):
            print('Inside wrapped_func - wrapping:', func.__name__)
            func(*args, **kwargs)
            print('Finished func(*args, **kwargs)')
        return wrapped_func
    return wrapper
```

## Threading

Python 3.6 now provides some awesome simplification for threading. See [concurrent.futures](https://docs.python.org/3/library/concurrent.futures.html).

```python
import concurrent.futures

# We can use a with statement to ensure threads are cleaned up promptly
# optional chunksize=1 can split a large iterable in map for speedup
with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
    execute.map(func, iterable)

    pending = []
    pending.append(executor.submit(func, *args))  # or use r.result()

    # useful if delegating multiple tasks to threads
    for future in concurrent.futures.as_completed(pending):
        try:
            r = future.result(timeout=10)
        except concurrent.futures.TimeoutError:
            print('Thread timeout of task')
```

## Regex

| Symbol       | Meaning                                                                                                                                                                                                                                                                            |
|--------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `a, X, 9`    | Ordinary characters just match themselves exactly. The meta-characters which do not match themselves because they have special meanings are: `.` `^` `$` `*` `+` `?` `{` `[` `]` `\` `\|` `(` `)`                                                                                  |
| `.`          | A period matches **any single character except** newline `\n`                                                                                                                                                                                                                      |
| `\w`         | Matches a "word" character: a letter or digit or underbar `[a-zA-Z0-9_]`. Note that although "word" is the mnemonic for this, it only matches a single word char, not a whole word.                                                                                                |
| `\W`         | Matches any non-word character.                                                                                                                                                                                                                                                    |
| `\b`         | Boundary between word and non-word                                                                                                                                                                                                                                                 |
| `\s`         | Matches a **single** whitespace character - space, newline, return, tab, form `[ \n\r\t\f]`.                                                                                                                                                                                       |
| `\S`         | Matches any **non-whitespace** character.                                                                                                                                                                                                                                          |
| `\t, \n, \r` | Tab, newline, return.                                                                                                                                                                                                                                                              |
| `\d`         | Decimal digit `[0-9]` (some older regex utilities do not support but `\d`, but they all support `\w` and `\s`).                                                                                                                                                                    |
| `^, $`       | Match the start or end of the string respectively.                                                                                                                                                                                                                                 |
| `\`          | Inhibit the **specialness** of a character. <br>So, for example, use `\.` to match a period or `\\` to match a slash. If you are unsure if a character has special meaning, such as `@`, you can put a slash in front of it, `\@`, to make sure it is treated just as a character. |

### match, search, findall

* `match`: only finds the string on the **beginning** i.e. ignore space delimited strings apart from the first one!
* `search`: similar to `match` but it will return the **first match** of the string.
* `findall`: will return **all** matches as a list and we can also use group extraction quite nicely!

### Tips

* `{1-4}` will match 104 times!

### Email

```python
str = 'purple alice-b@google.com monkey dishwasher'
match = re.search(r'\w+@\w+', str)
if match:
    print(match.group())  ## 'b@google'
```

### Square brackets

```python
match = re.search(r'[\w.-]+@[\w.-]+', str)
if match:
    print(match.group())  ## 'alice-b@google.com'
```

### Group extraction

```python
str = 'purple alice-b@google.com monkey dishwasher'
match = re.search('([\w.-]+)@([\w.-]+)', str)
if match:
    print(match.group())   ## 'alice-b@google.com' (the whole match)
    print(match.group(1))  ## 'alice-b' (the username, group 1)
    print(match.group(2))  ## 'google.com' (the host, group 2)
```

### Find all

```python
## Suppose we have a text with many email addresses
str = 'purple alice@google.com, blah monkey bob@abc.com blah dishwasher'

## Here re.findall() returns a list of all the found email strings
## ['alice@google.com', 'bob@abc.com']
emails = re.findall(r'[\w\.-]+@[\w\.-]+', str)
for email in emails:
    # do something with each found email string
    print(email)
```

```python
# Open file
f = open('test.txt', 'r')

# Feed the file text into findall(); it returns a list of all the found strings
strings = re.findall(r'some pattern', f.read())
```

```python
str = 'purple alice@google.com, blah monkey bob@abc.com blah dishwasher'
tuples = re.findall(r'([\w\.-]+)@([\w\.-]+)', str)
print(tuples)  ## [('alice', 'google.com'), ('bob', 'abc.com')]
for tuple in tuples:
    print(tuple[0])  ## username
    print(tuple[1])  ## host
```

### Options

* `IGNORECASE`: Ignore upper/lowercase differences for matching, so 'a' matches both 'a' and 'A'.

* `DOTALL`: Allow dot (.) to match newline -- normally it matches anything **but** newline.
This can trip you up - you think `.*` matches everything, but by default it does **not** go past the end of a line.
Note that `\s` (whitespace) includes newlines, so if you want to **match a run of whitespace that may include a newline**, you can just use `\s*`

* `MULTILINE`:Within a string made of many lines, allow `^` and `$` to match the start and end of each line.
Normally `^/$` would just match the start and end of the whole string.

```python
# for search()` or `findall()` etc.
re.search(pattern, str, re.IGNORECASE)
```

## Operator precedence

| Operator                                      | Description                                                                    |
|-----------------------------------------------|--------------------------------------------------------------------------------|
| `**`                                          | Exponentiation (raise to the power)                                            |
| `~` `+` `-`                                   | Complement, unary plus and minus (method names for the last two are +@ and -@) |
| `*` `/` `%` `//`                              | Multiply, divide, modulo and floor division                                    |
| `+` `-`                                       | Addition and subtraction                                                       |
| `>>` `<<`                                     | Right and left bitwise shift                                                   |
| `&`                                           | Bitwise AND                                                                    |
| `^` `\|`                                      | Bitwise exclusive 'OR' and regular 'OR'                                        |
| `<=` `<` `>` `>=`                             | Comparison operators                                                           |
| `<>` `==` `!=`                                | Equality operators                                                             |
| `=` `%=` `/=` <br> `//=` `-=` `+=` `*=` `**=` | Assignment operators                                                           |
| `is` `is not`                                 | Identity operators                                                             |
| `in` `not in`                                 | Membership operators                                                           |
| `not` `or` `and`                              | Logical operators                                                              |
