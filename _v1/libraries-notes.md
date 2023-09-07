---
layout: compsci-note
title: Compiler Notes
categories: [compilers]
description: Some notes on compiling stuff - misleading title
---

## Contents

* [Static libraries](#static)
  * [Example](#example-of-compiling-a-static-library)
* [Dynamic libraries](#dynamic)
* [GCC flags](#gcc)

## Libraries

### Static

A **static library** `.a` is a library that can be linked **directly into** the final executable produced by the linker, it is contained inside it. There is **no** need to have the library into the system where the executable will be deployed.

A **special** `.la` file are static libraries used by the GNU "libtools" package.

#### Pros/cons

* The user always uses the version of the library that you've tested with your application, so there shouldn't be any surprising compatibility problems.
* If a problem is fixed in a library, you need to redistribute your application to take advantage of it. However, unless it's a library that users are likely to update on their own, you'd might need to do this anyway.

### Dynamic

[See an example of creating a shared library](https://www.cprogramming.com/tutorial/shared-libraries-linux-gcc.html)

A **shared library**`.so` is a library that is **linked but not embedded** in the final executable, so will be loaded when the executable is launched and **need** to be present in the system where the executable is deployed.

A **dynamic link library** on Windows `.dll` is like a **shared** library`(.so)` on Linux but there are some differences between the two implementations that are related to the OS (Windows vs Linux):

* A DLL can define two kinds of functions: *exported* and *internal*.
* The exported functions are intended to be called by other modules, as well as from within the DLL where they are defined.
* Internal functions are typically intended to be called only from within the DLL where they are defined.

#### Pros

* An SO library on Linux doesn't need special export statement to indicate exportable symbols, since all symbols are available to an interrogating process.
* Your process's memory footprint is smaller, because the memory used for the library is amortized among all the processes using the library.
* Libraries can be loaded on demand at run time; this is good for plugins, so you don't have to choose the plugins to be used when compiling and installing the software. New plugins can be added on the fly.
* Dynamic libraries are especially useful for system libraries, like `libc`. These libraries often need to include code that's dependent on the specific OS and version, because kernel interfaces have changed. If you link a program with a static system library, it will only run on the version of the OS that this library version was written for. But if you use a dynamic library, it will automatically pick up the library that's installed on the system you run on.

## Examples

### Compiling a static library

```bash
TARGET = prog

$(TARGET): main.o lib.a
    gcc $^ -o $@

main.o: main.c
    gcc -c $< -o $@

lib.a: lib1.o lib2.o
    ar rcs $@ $^      # $^: all dependencies

lib1.o: lib1.c lib1.h
    gcc -c -o $@ $<   # $<: first dependency

lib2.o: lib2.c lib2.h
    gcc -c -o $@ $<

clean:
    rm -f *.o *.a $(TARGET)

# Or this works:
# ar -cvq libctest.a ctest1.o ctest2.o
# ar -t libctest.a                          # list files
```

## GCC

### Misc. flags

| Flag            | Description                                                                             |
|-----------------|-----------------------------------------------------------------------------------------|
|`-g`             | Produce debugging information in the operating system's native format (stabs, COFF, XCOFF, or DWARF). |
|`-gstabs+, -gstabs, -gxcoff+, -gxcoff, -gvms`| Control other extra debug info `-g` sometimes generates automatically. |
|`-v`             | Verbose.|
|`-ffunction-sections, -fdata-sections`| This will increase the size of the static library, as each function and global data variable will be put in a separate section. |
|`-Wl,--gc-sections`| Using this on the program linking with this static library, which will remove unused sections and therefore smaller. Be careful though, this can break things. See [Stackoverflow answer](https://stackoverflow.com/questions/4274804/query-on-ffunction-section-fdata-sections-options-of-gcc)
|`-no-crt0`       | Don't include the default `crt0`, you can use a custom generated from a cross compiler. |

### MIPS specific flags

[GCC MIPS flags](https://gcc.gnu.org/onlinedocs/gcc/MIPS-Options.html)

| Flag            | Description                                                                             |
|-----------------|-----------------------------------------------------------------------------------------|
|`-msoft-float`   | Do not use floating-point coprocessor instructions. Implement floating-point calculations using library calls instead - i.e emulate fpu instructions. |
|`-mno-abicalls`  | Generate (do not generate) code that is suitable for SVR4-style dynamic objects.        |
|`-EL, -EB`       | Endianness.
