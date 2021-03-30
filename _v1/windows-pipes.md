---
layout: compsci-note
title: Windows Pipes
categories: [windows]
description: Some notes on Windows Pipes
sitemap: false
---

Below is a summarized version of the [Microsoft Windows Documentation - Pipes](https://docs.microsoft.com/en-us/windows/win32/ipc/pipes).

* [Anonymous Pipes](#anonymous-pipes)
* [Named Pipes](#named-pipes)
* [Code examples](#examples)

## Overview

A pipe is a section of shared memory that processes use for communication.

* The process that creates a pipe is the pipe server.
* A process that connects to a pipe is a pipe client.

One process writes information to the pipe, then the other process reads the information from the pipe.

There are two types of pipes: anonymous pipes and named pipes. Anonymous pipes require less overhead than named pipes, but offer limited services.

The term pipe, as used here, implies that a pipe is used as an information conduit. Conceptually, a pipe has two ends. A **one-way** pipe allows the process at one end to write to the pipe, and allows the process at the other end to read from the pipe. A **two-way** (or duplex) pipe allows a process to read and write from its end of the pipe.

## Anonymous Pipes

An anonymous pipe is an **unnamed**, one-way pipe that typically transfers data between a parent process and a child process. Anonymous pipes are always local; they *cannot* be used for communication over a network.

An anonymous pipe exists until all pipe handles, both read and write, have been closed. A process can close its pipe handles by using the `CloseHandle` function. All pipe handles are also closed when the process terminates.

Anonymous pipes are implemented using a named pipe with a **unique name**. Therefore, you can often pass a handle to an anonymous pipe to a function that requires a handle to a named pipe.

### Operations

Asynchronous (overlapped) read and write operations are not supported by anonymous pipes.

#### CreatePipe

The [CreatePipe](https://docs.microsoft.com/en-au/windows/win32/api/namedpipeapi/nf-namedpipeapi-createpipe?redirectedfrom=MSDN) function creates an anonymous pipe and returns two handles:

* read handle to the pipe - read-only access to the pip
* write handle to the pipe - write-only access to the pipe

To communicate using the pipe, the pipe server must pass a pipe handle to another process. This can be achieved by:

1. Process inheritance; that is, the process allows the handle to be inherited by a child process.
2. The process can also duplicate a pipe handle using the [DuplicateHandle](https://docs.microsoft.com/en-au/windows/win32/api/handleapi/nf-handleapi-duplicatehandle) function and send it to an unrelated process using some form of inter-process communication, such as DDE or shared memory.

A pipe server can send either the read handle or the write handle to the pipe client, depending on whether the client should use the anonymous pipe to send information or receive information.

#### ReadFile

To read from the pipe, use the pipe's read handle in a call to the [ReadFile](https://docs.microsoft.com/en-au/windows/win32/api/fileapi/nf-fileapi-readfile) function. The `ReadFile` call returns when another process has written to the pipe. The `ReadFile` call can also return if all write handles to the pipe have been closed or if an error occurs before the read operation has been completed.

#### WriteFile

To write to the pipe, use the pipe's write handle in a call to the [WriteFile](https://docs.microsoft.com/en-au/windows/win32/api/fileapi/nf-fileapi-writefile) function. The `WriteFile` call does not return until it has written the specified number of bytes to the pipe or an error occurs.

If the pipe buffer is full and there are more bytes to be written, `WriteFile` does not return until another process reads from the pipe, making more buffer space available. The pipe server specifies the buffer size for the pipe when it calls `CreatePipe`.

## Named Pipes

A named pipe is a named, one-way or duplex pipe for communication between the pipe server and one or more pipe clients. All instances of a named pipe share the same pipe name, but each instance has its own buffers and handles, and provides a **separate** conduit for client/server communication. The use of instances enables multiple pipe clients to use the same named pipe simultaneously.

Any process can access named pipes, subject to security checks, making named pipes an easy form of communication between related or unrelated processes.

Any process can act as both a server and a client, making peer-to-peer communication possible. As used here, the term pipe server refers to a process that creates a named pipe, and the term pipe client refers to a process that connects to an instance of a named pipe. The server-side function for instantiating a named pipe is `CreateNamedPipe`. The server-side function for accepting a connection is `ConnectNamedPipe`. A client process connects to a named pipe by using the `CreateFile` or `CallNamedPipe` function.

Named pipes can be used to provide communication between processes on the same computer or between processes on different computers across a network. If the server service is running, all named pipes are accessible remotely. If you intend to use a named pipe locally only, deny access to `NT AUTHORITY\NETWORK` or switch to local RPC. It is more common to use service isolation and restrict the access levels to it only.

### Pipe names

Usually in the format: `\\ServerName\pipe\PipeName`.

`ServerName` is either the name of a remote computer or a period, to specify the local computer. The pipe name string specified by `PipeName` can include any character other than a backslash, including numbers and special characters. The entire pipe name string can be up to 256 characters long. Pipe names are *not* case-sensitive.

The pipe server cannot create a pipe on another computer, so `CreateNamedPipe` must use a period for the server name, e.g. `\\.\pipe\PipeName`.

A pipe server can provide the pipe name to its pipe clients, so they can connect to the pipe. The pipe client discovers the pipe name from some persistent source, such as a registry entry, a file, or another application. Otherwise, the clients must know the pipe name at compile time.

### Named Pipe Open Modes

See [MS Named Pipe Open Modes](https://docs.microsoft.com/en-us/windows/win32/ipc/named-pipe-open-modes).

### Named Pipe Type, Read, and Wait Modes

See [MS Named Pipe Type, Read, and Wait Modes](https://docs.microsoft.com/en-us/windows/win32/ipc/named-pipe-type-read-and-wait-modes).

### Named Pipe Instances

The simplest pipe server:

1. Creates a single instance of a pipe
2. Connects to a single client
3. Communicates with the client
4. Disconnects from the client
5. Closes the pipe handle
6. Terminates

However, it is more common for a pipe server to communicate with multiple pipe clients. Typically a pipe server creates multiple pipe instances to communicate with multiple clients simultaneously; there a three basic strategies of achieving this:

1. Create a separate thread for each instance of the pipe
2. Use overlapped operations with an `OVERLAPPED` structure - see [Named Pipe Server Using Overlapped I/O](https://docs.microsoft.com/en-us/windows/win32/ipc/named-pipe-server-using-overlapped-i-o)
3. Use overlapped operations with a completion routine to be executed when the operation is complete - see [Named Pipe Server Using Completion Routines](https://docs.microsoft.com/en-us/windows/win32/ipc/named-pipe-server-using-completion-routines)

While a multi-threaded pipe server is the easiest to write, since each thread handles its own pipe instance, its cost is proportional to the number of threads. This can be very costly if a pipe server needs to communicate with a large number of clients.

A single-threaded server is easier to coordinate operations that affect multiple clients, and shared memory etc. The challenge of a single-threaded server is that it requires coordination of overlapped operations to allocate processor time for handling the simultaneous needs of clients.

#### Impersonating a Named Pipe Client

Impersonation enables the server thread to perform actions on a behalf of the client, but **within the limits of the client's security context**.

A named pipe server thread can call the `ImpersonateNamedPipeClient` function to assume the access token of the user connected to the client end of the pipe. For example, a name pipe server can provide access to a database of file system to which the pipe server has privileged access to. When a pipe client sends a request to the server, the server impersonates the client and attempts to access the protected database. The system then grants/denies the server's access, *based on the security level of the client*. Once this operation has been completed, the server can use the `ReverToSelf` function to restore its original security token.

### Examples

Compete list can be found at [MS Using Pipes](https://docs.microsoft.com/en-us/windows/win32/ipc/using-pipes).

### Using Named Pipes

Basic C# example from [Stack Overflow](https://stackoverflow.com/questions/13806153/example-of-named-pipes):

```cs
using System;
using System.IO;
using System.IO.Pipes;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            StartServer();
            Task.Delay(1000).Wait();


            //Client
            var client = new NamedPipeClientStream("PipesOfPiece");
            client.Connect();
            StreamReader reader = new StreamReader(client);
            StreamWriter writer = new StreamWriter(client);

            while (true)
            {
                string input = Console.ReadLine();
                if (String.IsNullOrEmpty(input)) break;
                writer.WriteLine(input);
                writer.Flush();
                Console.WriteLine(reader.ReadLine());
            }
        }

        static void StartServer()
        {
            Task.Factory.StartNew(() =>
            {
                var server = new NamedPipeServerStream("PipesOfPiece");
                server.WaitForConnection();
                StreamReader reader = new StreamReader(server);
                StreamWriter writer = new StreamWriter(server);
                while (true)
                {
                    var line = reader.ReadLine();
                    writer.WriteLine(String.Join("", line.Reverse()));
                    writer.Flush();
                }
            });
        }
    }
}
```
