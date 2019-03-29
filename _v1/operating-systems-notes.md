---
layout: default
title: Operating System Notes
categories: [linux]
description: Some notes on Operating Systems
order: 20
sitemap: false
---

# Contents

* [Basics](#basics)
  * [Processors vs threads](#processors-vs-threads)
  * [Concurrency and synchronisation](#concurrency-and-synchronisation)
    * [Semaphores](#semaphores)
    * [Producer and consumer problem](#producer-consumer-problem)
* [File Systems](#file-systems)
* [Terms](#terms)
* [Routines](#initialisation-routines)
* [Position Independent Code](#pic-position-independent-code)
* [Global Offset Table](#got-global-offset-table)
* [Static and shared libraries](#static-shared-dynamic-libraries)
* [ABI](#abi---application-binary-interface)
* [ELF](#elf)

## Basics

### Processors vs threads

* less resources associated to them, therefore cheaper, can share resources
* threads are often used for I/O overlapping
* threads can still utilise multiprocessors
* user level threads are handled by user applications (processor) - OS does less book-keeping, security

|Per process items | Per thread items|
|------------------|-----------------|
|Address space     |PC               |
|Global variables  |Registers        |
|Open files        |Stack            |
|Child processors  |State            |
|Pending alarms    ||
|Signals & signal handlers||
|Accounting information||

## Concurrency and synchronisation

Remember, the scheduler's job is to switch between processors/threads - this is usually done with timer interrupts, hence why synchronisation often turns interrupts on/off.

### Test-and-Set

Basically:

* load lock value
* if `lock == 0`:
  * set `lock = 1`
  * `return 0` - we acquire the lock
* if `lock == 1`:
  * `return 1` - another processor has the lock
* hardware guarantees atomic execution

```asm
enter_region:
    TSL REGISTER, LOCK # copy lock to register, set lock to 1
                       # if lock == 0, else leave alone
    CMP REGISTER, $0   # compare if register is == 0
    JNE enter_region   # if register == 1, loop
    RET 0              # return to caller; critical region entered

leave_region:
    MOVE LOCK, $0      # set lock to 0
    RET
```

**Issues:**

* prone to starvation - one threads always checking, other always continues
* consumes CPU cycles - spin lock
* poor for priority threads/processors - low priority thread may always have the lock

### Semaphores

* Dijkstra 1965 legend
* `P()`: wait/acquire
* `V()`: signal/release
* primitives are atmoic
* simple and awesome but if you program them incorrectly (e.g. without matching `wait()`, `signal()`), good luck debugging

```c
typedef struct {
    int count;
    struct process *L; // list of sleeping processors
} semaphore;
```

```c
// P(S)
wait(S):
    S.count--;
    if (S.count < 0) {
        // add this process to S.L
        sleep();
    }

// V(S)
signal(S):
    S.count++;
    if (S.count <= 0) {
        // remove a process P from S.L
        wakeup(P);
    }
```

### Producer-consumer problem

```c
producer() {
    while (true) {
        item = produce()
        if (count == N)
            sleep();
        insert_item();    // into some shared data structure
        count++;          // shared var
        if (count == 1)
            wakeup(consumer);
    }
}

consumer() {
    while (true) {
        if (count == 0)
            sleep();
        remove_item();    // remove item from shared data structure
        count--;          // shared var
        if (count == N-1)
            wakeup(producer);
    }
}
```

**Issues:**

* `count` has race conditions
* item buffer isn't synchronised at all
* dead locks

```c
// the deadlock scenario
// assume count == 0
if (count == 0)  // consumer

// scheduler context switches

item = produce()  // producer
if (count == N) sleep();
...
// repeat until above condition is true
// producer sleeps

// scheduler context switches

sleep();  // consumer
// both threads are now sleeping
// no progress is made since count == 0 was checked
// before the context switch!
```

#### Solution

* we use a semaphore to control the sleep/wake behaviour for the *size of the item buffer*
* we use a mutex semaphore (basically a lock) for synchronisation of the item buffer

```c
empty = N;  // number of empty slots
full = 0;   // number of filled slots
mutex = 1;  // allow one thread access only

producer() {
    while (true) {
        item = produce();
        wait(empty);      // check if buffer is full - sleep
                          // critical region is entered
        wait(mutex);      // obtain lock
        insert_item();    // into some shared data structure
        signal(mutex);    // release lock

        signal(full);     // full++ && wake consumer if full <= 0
    }
}

consumer() {
    while (true) {
        wait(full);       // full-- && sleep if full < 0

        wait(mutex);
        remove_item();    // remove item from shared data structure
        signal(mutex);

        signal(empty);    // empty++ && wake producer if empty <= 0
    }
}
```

## File systems

I'm going to over-simplify this because there's just too much to write about.

The OS manages from FD table - device driver on a typical storage stack.

|Stack          |Description        |Hides                                |Exposes|
|---------------|-------------------|-------------------------------------|-------|
|Application    |Syscall interface: create, open, read, write etc.        |||
|FD table<br>OF table|File (open) descriptor table - keeps track of files opened by user-level processes. Implements semantics of FS syscalls.|||
|VFS            |Virtual FS - unified interface to *multiple* file systems.|||
|FS             ||Physical location of data on the disk|Directory heirarchy, symbolic file names, random-access files, protection.|
|Buffer cache<br>Disk scheduler|Keeps recently access disk blocks in memory. Schedule disk accesses from multiple processes for performance and fairness. This all occurs in memory.|
|Device driver  ||Hides device specific protocol e.g. USB3|Exposes block-device interface (linear sequence of blocks)|
|Disk controller||Hides disk geometry, bad sectors|Exposes linear sequence of blocks|
|Physical disk  |Hard disk platters: tracks, sectors|||

### File structure

Three types:

* byte sequence (most popular for OS)
* record sequence
* key-based, tree structure

#### Byte stream

* OS considers it to be unstructured
* simplifies file management for OS
* applications can impose their own structure

#### Records

* collection of bytes treated as a unit
* operations at the level of records e.g. `read_rec`
* *file is a collection of similar records*
* OS can optimise operations on records

#### Tree of records

* records of variable length
* key association and retrieval
* databases or some data processing systems

### Implementation

A file system must do the following:

* map symbolic names to block addresses
* track which blocks belong to which files
* block order in file
* blocks that are free for allocation
* store this in some metadata

### Allocation strategies

#### Contiguous allocation

* (+) easy bookkeeping (track start block + size)
* (+) increases performance for sequential operations
* (-) need maximum file size at time of creation
* (-) external fragmentation - as files are deleted, disk blocks become fragmented/sparse

#### Dynamic allocation

* (+) allocates space on demand
* (+) allocation in fixed-sized blocks
* (+) no external fragmentation
* (+) doesn't require pre-allocation of file size
* (-) internal fragmentation - blocks internally can be sparsely filled
* (-) file blocks are scattered across disk - can become semi-random
* (-) metadata management becomes complicated - many strategies

#### Linked list allocation

* link blocks together starting with the head
* (+) good for sequential access
* (-) poor random access
* (-) blocks end up scattered across the disk due to freeing lists - block corruption/loss

#### File allocation table

* map the *entire* FS in a separate table - like a page table
* table is copied into memory
* random access is fast (table is loaded into memory first)
* (-) this starts to use huge amounts of space
* (-) freeing a block is slow
* e.g. FAT32

#### i-node based allocation

* separate table for each file (i-node)
* only keep table for open files in memory
* fast random access
* i-nodes are stored usually at the start of the disk
    * fixed size
    * last i-node entry points to an extension i-node
* e.g. ext2, ext3

## Terms

### Asymmetric Multiprocessor Programming (AMP)

* Where tasks are delegated to processors at design time.
* All CPUs have the whole program instruction memory (rescheduling possible).
* They don't have to be balanced - one CPU might only run OS code, other might run I/O code etc.

### Symmetric Multiprocessor Programming (SMP)

* A **single OS** manages all CPUs and a separate processor runs per CPU.
* This allows parallel execution of programs.
* All CPUs access a shared memory - this may be using shared memory buses and crossbar switches - limited scalability.
* Other memory bus alternatives are on-chip mesh networks - this has significant complexities of communication as well.
* Shared memory access is serialised, you have cache coherency challenges as well.

## Initialisation routines

* Constructors - initialisation routines - functions to initialise data in the program when the program is started ie. before main()
  * called in reverse order
* Destructors - termination routines - that are called when the program terminates
  * called in forward order
* The linker must generate a list of these constructors/descructors `__CTOR_LIST__` and the exec file format traverses these lists at startup/exit.
* Sections `.ctors` and `.dtors` and usually set aside for these lists
* On systems that support .init, parts of crtstuff.c are compiled into that section. The program is linked by the gcc driver by:
   `ld -o output_file crti.o crtegin.o ... -lgcc crtend.o crtn.o`
* The *prologue* of a function `__init` appears in the `.init` section of `crti.o`
* The *epilogue* `__fini` appears in crtn.o
* The objects `crtbegin.o` and `crtend.o` are (for most targets) compiled from `crtstuff.c.`
  They contain, among other things, code fragments within the `.init` and `.fini` sections that branch to routines in the `.text` section.
  The linker will pull all parts of a section together, which results in a complete `__init` function that invokes the routines we need at startup.
* If **no** `.init` section is available, gcc compiles any function called main, it inserts a procedure call to __main as the first executable code after the function prologue. The __main function is designed in libhcc2.c and runs the global constructors.
* The last method *doesn't* use arbitrary sections nor the GNU linker. This is useful for dynamic linking and when using file formats the linker doesn't support eg. ECOFF.
  * The initialisation and termination functions are recognised by their names.
  * An extra program called `collect2` which pretends to be the linker (as the GNU linked is not called) ie. it does the same as the original linker but also arranges to include the vectors of initialisation and terminations functions.
  * These functions are called via `__main`.
  * `use_collect2` needs to be defined in the target in `config.gcc`

### ctors dtors

   Both `crt0/crt1` do the same thing, basically do what is needed before calling main() (like initialising stack, setting IRQs, etc.). You should link with one or the other but not both. They are not really libraries but really inline assembly code.

* `crt1.o` is used on system that support constructors and destructors (functions called before and after main and exit). In this case main is treated like a normal function call.
* `crt0.o` is used on systems that does not support constructors/destructors.

### .init_array

* Why did `.init_array` turn up?

    We added `.init_array/.fini_array` in order to blend the SVR4 version of .init, which contained actual code, with the HP-UX version, which contained function pointers and used a `DT_INIT_SZ` entry in the dynamic array rather than prologue and epilogue pieces contributed from `crt*.o` files. The HP-UX version was seen as an improvement, but it wasn't compatible, so we renamed the sections and the dynamic table entries so that the two versions could live side-by-side and implementations could transition slowly from one to the other.

    On HP-UX, we used `.init/.init_array` for static constructors, and they registered the corresponding static destructors on a special atexit list, rather than adding destructors to `.fini_array`, so that we could handle destructors on dlclose() events properly (subject to your interpretation of "properly" in that context)
The order of execution differs between `.ctors` and `.init_array`

* Backwarding order of `.ctors` section

    Some programs may implicitly rely on the fact that global constructors in archives linked later are run before constructors in the object linked against those archives. That is, given
`g++ foo.o -lbar`
where bar is a static archive, not a shared library, then currently the global constructors in objects pulled in from `libbar.c` will be executed before the global constructors in `foo.o`. That was an intentional choice because it is more likely to be correct than the reverse. However, the C++ standard does not guarantee it, so any programs which relies on this ordering is technically invalid.
Problem of backwarding order of `.ctors`

A lot of work was done in both GNU ld and gold to move constructors from `.ctors` to `.init_array`, all to improve startup latency for Firefox

Using `.init_array/.fini_array` instead of `.ctors/.dtors` removes the need for:

* the associated (relative) relocations
* avoids the backwards disk seeks on startup (since while .ctors are processed backwards, `.init_array` is processed forward).

#### Transition from .ctors to .init_array

The mainline versions of both GNU `ld` and `gold` now put `.ctors` sections into `.init_array` sections, and put `.dtors` sections into `.fini_array` sections.

#### ARM

ARM EABI has been using `.init_array` from day one.
Comment: Nevertheless the default linker script contains a .ctors output section.

#### GCC configuration

One option you have is to configure gcc with `--disable-initfini-array`.

## PIC: Position Independent Code

* Is a body of machine code that, being placed somewhere in the primary memory, executes properly regardless of its absolute address.
* PIC is commonly used for shared libraries, so that the same library code can be loaded in a location in each program address space where it will not overlap any other uses of memory (for example, other shared libraries).
* PIC was also used on older computer systems lacking an MMU, so that the operating system could keep applications away from each other even within the single address space of an MMU-less system.

* Position-independent code can be executed at any memory address without modification.
* This **differs** from relocatable code, in which a link editor or program loader modifies a program before execution so it can be run **only** from a particular memory location.
* Generating position-independent code is often the *default* behavior for compilers, but they may place restrictions on the use of some language features, such as disallowing use of absolute addresses (PIC **has** to use relative addressing).
* Instructions that refer directly to specific memory addresses sometimes execute faster, and **replacing** them with equivalent relative-addressing instructions may result in slightly slower execution, although modern processors make the difference practically negligible.

### More in-depth

Procedure calls inside a shared library are typically made through small procedure linkage table **stubs**, which then call the **definitive function**. This notably allows a shared library to inherit certain function calls from previously loaded libraries rather than using its own versions.

Data references from position-independent code are usually made indirectly, through **global offset tables (GOTs)**, which store the addresses of all accessed global variables. There is **one** GOT per compilation unit or object module, and it is located at a fixed offset from the code (although this offset is not known until the library is linked). When a linker links modules to create a shared library, it merges the GOTs and sets the final offsets in code. It is **not** necessary to adjust the offsets when loading the shared library later.

Position independent functions accessing global data start by determining the **absolute** address of the GOT given their own **current program counter value**. This often takes the form of a **fake function call** in order to obtain the return value on stack (x86) or in a **special register** (PowerPC, SPARC, MIPS etc.), which can then be stored in a predefined standard register. Some processor architectures, such as the Motorola 68000, ARM and x86-64 allow referencing data by **offset** from the program counter. This is specifically targeted at making position-independent *code smaller, less register demanding and hence more efficient*.

## GOT: Global Offset Table

*To be populated.*

## Static, shared, dynamic libraries

`.so` files are dynamic libraries. The suffix stands for "shared object", because all the applications that are linked with the library use the same file, rather than making a copy in the resulting executable.

`.a` files are static libraries. The suffix stands for "archive", because they're actually just an archive (made with the ar command -- a predecessor of tar that's now just used for making libraries) of the original .o object files.

`.la` files are static libraries used by the GNU "libtools" package. You can find more information about them in this question: What is libtool's .la file for?

## ABI - Application Binary Interface

* Is the interface between two program modules, one of which is often a library or operating system, at the level of machine code.
* An ABI determines such details as how functions are called and in which binary format information should be passed from one program component to the next, or to the OS eg. system call.
* Adhering to ABIs (which may or may not be officially standardized) is usually the job of the compiler, OS or library writer, but application programmers may have to deal with ABIs directly when writing programs in a mix of programming languages, using foreign function call interfaces between them.
* ABIs differ from application programming interfaces (APIs), which similarly define interfaces between program components, but at the source code level.

**Responsible for:**

* the sizes, layout, and alignment of data types
* the calling convention, which controls how functions' arguments are passed and return values retrieved;
  * e.g. whether all parameters are passed on the stack or some are passed in registers, which registers are used for which function parameters
  * whether the first function parameter passed on the stack is pushed first or last onto the stack
* how an application should make system calls to the operating system and, if the ABI specifies direct system calls rather than procedure calls to system call stubs, the system call numbers
* in the case of a complete operating system ABI, the binary format of object files, program libraries and so on.

## ELF

**Consists of these main sections:**

1. ELF Header
    * Specifics the arch, machine, endianness, 32/64 bit
    * Specifies where the SHT, PHT are located
2. Program Header Table
    * The program header table tells the system how to create a process image.
    * It is found at file offset *e_phoff*, and consists of *e_phnum* entries, each with size *e_phentsize*
3. All the sections - `.text`, `.data`, `.bss`, `.ctors` etc.
    * The ELF binary contains all the necessary data to execute
    * Libraries can be compiled within the ELF with the `-static` flag
    * `.bss` is not actually included in the ELF
        * It only specifies the size and assumes the space at the address is initialised to zero
        * If you check the flags, there is no `ALLOC`
4. Section Header Table
    * This lists all the different sections and where they are found
    * Also lists the virtual addresses they are mapped to, type of section eg. ALLOC
