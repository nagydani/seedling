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
 * single stack (typically, the machine stack)
 * no type system
 * no run-time error checking beyond that explicitly programmed
 * useful as a macro assembler of arbitrary sequences of bytes
 * modular (i.e. dynamic, mutable vocabularies)
 * self-hosting
 * cross-compile capability
 * minimal host requirements
 * rudimentary meta-programming in itself
 * interactive REPL

### Data types (not checked)

#### Fixed-size unsigned integer (cell)

 * Number type for arithmetics
   * Code with numbers not fitting into 16 bits considered not portable
 * Execution token
 * Address for strings of bytes (a.k.a. *c-addr*)
 * On-stack representation of a character

#### String of bytes

 * Textual interpretation only defined for 7-bit ASCII
 * On-stack representation: two cells, address of first byte followed by length (on top)
 * Counted string: architecture-dependent character count followed by the bytes

### Memory Model

 * One *stack* (usually the machine stack) for both return addresses and data
 * Loaded *wordlists* with immutable word addresses
 * Linear, appendable *workspace*

All three are extensible and shrinkable only in a LIFO fashion, no GC, no memory fragmentation.

Memory area *wordlists* always contains valid data, only fully compiled words can be 
transfered from *workspace* to *wordlists* and only complete words can be reclaimed from 
*wordlists*.

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
