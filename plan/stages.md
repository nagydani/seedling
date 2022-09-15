# Stages of Development and Project Scope

 * [Seed](#seed)
 * [Sprout](#sprout)
 * [Seedling](#seedling)

## Seed

The objective of the [Seed language](seed.md) and compiler is to provide portability for 
Seedling. Not much beyond the cross-compiler infrastructure and the [Sprout](#sprout) 
compiler will ever be developed in stand-alone Seed.

Porting/bootstrapping Seedling to a new architecture consists of

 1. writing Seed primitives for the target in Seed,
 1. cross-compiling Seed to the target architecture,
 1. writing Sprout primitives on the target architecture,
 1. re-compiling Sprout on the target architecture's Seed, 
 1. re-compiling Seedling on the target architecture's Sprout

### Properties

 * concatenative, stack-based
 * no type system
 * no run-time error checking beyond that explicitly programmed
 * useful as a macro assembler of arbitrary sequences of bytes
 * modular (i.e. dynamic, mutable vocabularies)
 * self-hosting
 * cross-compile capability
 * minimal host requirements
 * rudimentary meta-programming in itself
 * interactive shell

### Data types (not checked)

#### Fixed-size unsigned integer (cell)

 * Unsigned integer type for arithmetics
   * Code with numbers not fitting into 16 bits considered not portable
 * Execution token
 * Address for strings of bytes (a.k.a. *c-addr*)
 * On-stack representation of a 7-bit ASCII character

#### String of bytes

 * Textual interpretation only defined for 7-bit ASCII
 * Zero-terminated, like in C

### Memory Model

 * Two *stacks*, one for return addresses and one for function arguments and values
 * One *dictionary* with immutable word addresses and other data

All three are extensible and shrinkable only in a LIFO fashion, no GC, no memory fragmentation.

## Sprout

The objective of the Sprout language is to overcome the inherent limitations of Seed for the 
purpose of developing the [Seedling](#seedling) language and some other software for which 
this level of abstraction is appropriate.

Its source still contains assembly code for the implementation of primitive types (such as 
floating point numbers of various precision), dynamic memory management and similar. 
Functionality that is not needed for its own compilation, but is needed for the higher level.

Sprout has a rudimentary static type system for compiling quotations, keeping track of the 
types on the stack in compile time. Compiled Sprout quotations do not differ from compiled 
Seed quotations.

Compiled Sprout functions are valid Seed functions, albeit with a different name, containing 
their type specifier in addition to their identifier, allowing for type-based polymorphism. 
Sprout re-compiles some of Seed sources, taking into account stack effect declarations treated 
as mere comments by Seed.

For convenience and readability, Sprout may also have an infix/prefix quotation parser.

In addition to the Seedling compiler, Sprout is also the appropriate language for a wide variety 
of tasks roughly at the same level as C, such as system programming: kernel code, device drivers, 
OS-less microcontroller code, and so on.

## Seedling
