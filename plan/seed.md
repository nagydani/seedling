# Plan for the Seed language


## Deliverable

A non-optimizing compiler for concatenative stack-based programming language without any type 
system capable of targeting a different architecture than the one on which it runs.

 * It must be exhaustively documented, mostly by the source code.
 * It will be primarily used for bootstrapping purposes.
 * It must be usable as a macro assembler of arbitrary sequences of bytes. 
 * Its entire source code must be written in itself.
 * It must be capable of rudimentary meta-programming.
 * It must be modular.
 * Architecture-dependent parts should be separate modules.

The syntax of Seed will be the basis of further stages of Seedling.


## Acceptance

Successful cross compilation of Seed on a simpler architecture to a more complex architecture, 
with a higher integer word length. The simpler the host and the more advanced the target, the 
better.


## Supported Architectures

### C-based POSIX host system

The goal here is *not* to create an efficient Seed-to-C compiler, but a simple stop-gap 
measure to allow us not to bother with I/O and other low-level issues when working on 
modern computers. All this code will be kept and maintained as a reference, but eventually 
will go out of use completely.

The structure of the resulting C code will be a byte code interpreter where the necessary 
primitives will correspond to individual opcodes, together with the byte code to be interpreted 
by it. No further development in C will ever happen in this project until we set out to write 
an efficient C-to-Seedling compiler.

### At least one 20th Century 8-bit home computer

The goal here is twofold: to make sure that Seed scales down sufficiently and demonstrate it 
in practice. The reason for this particular choice of a low-end system is that these machines 
had simple and well-defined peripherals (screen, keyboard, storage) and there are convenient, 
powerful debugging-friendly emulators for them, including their peripherals.

### A modern, well-specified Single-Board Computer, such as RPi

The goal here is to use it for something commercially viable.


## Tactics

Two teams (or individuals) start working independently on the first two versions. 
Whichever gets finished first, will be used to produce the other two versions.

The first team will use the most powerful modern tools with which they are comfortable.

The second team will use assembler and debugging emulators.

The reason for this somewhat redundant approach is that it is not clear which version 
provides the best combination of tools and incentives to make the leanest and meanest 
possible Seed. The first team lacks the pain of low-level development egging them on 
to wrap it up fast, while the second team is lacking in tool productivity.
