---
layout: default
title: Linux Syscall Notes
categories: [linux]
description: Some notes on Linux Syscalls - a little unnecessary
order: 20
sitemap: false
---

# Contents

* [Malloc](#malloc)
* [Calloc](#calloc)
* [Fork](#fork)
* [Execve](#execve)
* [System](#system)

## Malloc

* Alloc memory to heap (grows towards high addresses). If the heap is not big enough, `malloc` will internally call `set_brk()` syscall to alloc more.
* Since the stack is limited and the variable needs to survive after invocation.
* Also for obfuscation eg. a function implements the allocation of a ptr that isn't exposed to the caller.
* Internally it might call:
  * `sbrk()` for glibc - this usually does it in the following sequence
  ```c
            heap_ptr = sbrk(0)
            heap_ptr = sbrk(100)
  ```
  * `sbrk()` is used for incrementing the heap ptr
  * Both `sbrk()` and `brk()` call `_syscall_brk()` which should return a valid address in the heap

```c
// brk.c

#include <errno.h>
#include <unistd.h>
#include <sys/syscall.h>
#define __NR___syscall_brk __NR_brk
static __always_inline _syscall1(void *, __syscall_brk, void *, end)

/* This must be initialized data because commons can't have aliases.  */
void * __curbrk attribute_hidden = 0;

int brk(void *addr)
{
    void *newbrk = __syscall_brk(addr);
    __curbrk = newbrk;
    if (newbrk < addr) {
        __set_errno (ENOMEM);
        return -1;
    }
    return 0;
}
libc_hidden_def(brk)
```

## Calloc

* It initialises the buffer/memory. Now if you **zero** intialise, this large chunk of data won't necessarily be mapped to physical memory but rather only **1** block will be mapped.
* The PT will allocate the pages required but mark it as **READ-ONLY** so it will essentially map to physical memory when required (on-demand).
* And therefore this prevents large blocks of data being mapped to physical memory at one time.

## Get number of bytes allocated

```c
#include <malloc.h>
size_t malloc_usable_size (void *ptr);
```

## Difference between fork() and exec()

* quick explaination:
  * `fork()` creates new child process. If **ret = 0**, in child process else in **parent** process.
    * common to call `exec()` in child process to run a new program
  * `exec()` overwrites the current process with the new program ie. address space etc.

### Fork

```c
  #include <unistd.h>
  pid_t fork(void);
```

`fork()` creates a new process by duplicating the calling process. The new process, referred to as the child, is an exact duplicate of the calling process, referred to as the parent, except for the following points:

* The child has its own unique process ID, and this PID does not match the ID of any existing process group (setpgid(2)).
* The child's parent process ID is the same as the parent's process ID.
* The child does not inherit its parent's memory locks (`mlock(2)`, `mlockall(2)`).
* Process resource utilizations (getrusage(2)) and CPU time counters (times(2)) are reset to zero in the child.
* The child's set of pending signals is initially empty (sigpending(2)).
* The child does not inherit **semaphore** adjustments from its parent (semop(2)).
* The child does not inherit **record locks** from its parent (fcntl(2)).
* The child does not inherit **timers** from its parent (setitimer(2), alarm(2), timer_create(2)).
* The child does not inherit outstanding asynchronous I/O operations from its parent (aio_read(3), aio_write(3)), nor does it inherit any asynchronous I/O contexts from its parent (see io_setup(2)).

The parent and child also differ with respect to the following Linux-specific process attributes:

* The prctl(2) PR_SET_PDEATHSIG setting is reset so that the child does **not** receive a signal when its parent terminates.
* The **termination** signal of the child is always `SIGCHLD` (see clone(2)).

Note the following further points:

* The child process is created with a single thread--the one that called fork(). The entire virtual address space of the parent is **replicated** in the child, including the states of **mutexes**, **condition variables**, and other **pthreads objects**; the use of `pthread_atfork` may be helpful for dealing with problems that this can cause.
* The child inherits copies of the parent's set of **open file descriptors**. Each file descriptor in the child refers to the same open file description as the corresponding file descriptor in the parent. This means that the two descriptors **share** open file **status flags**, current **file offset**, and signal-driven I/O attributes (see the description of `F_SETOWN` and `F_SETSIG` in `fcntl`(2)).
* The child inherits copies of the parent's set of open message queue descriptors (see mq_overview(7)). Each descriptor in the child refers to the same open message queue description as the corresponding descriptor in the parent. This means that the two descriptors share the same flags (mq_flags).
* The child inherits copies of the parent's set of open directory streams (see opendir(3)). POSIX.1-2001 says that the corresponding directory streams in the parent and child may share the directory stream positioning; on Linux/glibc they do not.

### Execve

`execve()` executes the program pointed to by filename. filename must be either a binary executable, or a script starting with a line of the form:

* `#! interpreter [optional-arg]`
* `argv` is an array of argument strings passed to the new program. By convention, the first of these strings should contain the filename associated with the file being executed.
* `envp` is an array of strings, conventionally of the form key=value, which are passed as environment to the new program. Both `argv` and `envp` **must** be terminated by a NULL pointer.
* The argument vector and environment can be accessed by the called program's main function, when it is defined as:
  * `int main(int argc, char *argv[], char *envp[])`
* `execve()` does **not** return on success, and the text, data, bss, and stack of the calling process are **overwritten** by that of the program loaded.
* If the current program is being ptraced, a SIGTRAP is sent to it after a successful execve().

All process attributes are preserved during an execve(), except the following:

* The dispositions of any signals that are being caught are reset to the default (signal(7)).
* Any alternate signal stack is not preserved (`sigaltstack(2)`).
* Memory mappings are **not** preserved (`mmap(2)`).
* Attached System V shared memory segments are detached (`shmat(2)`).
* POSIX shared memory regions are unmapped (`shm_open(3)`).
* Open POSIX message queue descriptors are closed (`mq_overview(7)`).
* Any open POSIX named semaphores are closed (`sem_overview(7)`).
* POSIX timers are not preserved (`timer_create(2)`).
* Any open directory streams are closed (`opendir(3)`).
* Memory locks are not preserved (`mlock(2)`, `mlockall(2)`).
* Exit handlers are not preserved (`atexit(3)`, `on_exit(3)`).
* All threads other than the calling thread are destroyed during an `execve()`. Mutexes, condition variables, and other pthreads objects are **not** preserved.

### Example of fork, exec

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>    /* for fork */
#include <sys/types.h> /* for pid_t */
#include <sys/wait.h>  /* for wait */

int main()
{
    /*Spawn a child to run the program.*/
    pid_t pid=fork();
    if (pid==0) {                                            /* child process */
        static char *argv[]={"echo","Foo is my name.",NULL};
        execv("/bin/echo",argv);
        exit(127);                                           /* only if execv fails */
    }
    else {                                                   /* pid!=0; parent process */
        waitpid(pid,0,0);                                    /* wait for child to exit */
    }
    return 0;
}
```

## System

The `system()` library function uses `fork(2)` to create a **child** process that executes the shell command specified in command using `execl(3)` as follows:

* `execl("/bin/sh", "sh", "-c", command, (char *) 0);`
* `system()` returns after the command has been completed.

The **return** value of system() is one of the following:

* If command is `NULL`, then a nonzero value if a shell is available, or `0` if no shell is available.
* If a child process could not be created, or its status could not be retrieved,  the  return value is `-1`.
* If a shell could not be executed in the child process, then the return value is as though the child shell terminated by calling `_exit(2)` with the status `127`.
* If all system calls succeed, then the return value is the termination status of  the  child shell  used to execute command. (The termination status of a shell is the termination status of the last command it executes.)
