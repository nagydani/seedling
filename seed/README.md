# The Seed

## Abstract

The Seed is a basic abstraction above the computer 
hardware and the operating system (if there is one; some 
Seeds may run on the "bare metal"). It is a program 
implementing the Seed language. The Seed language is a 
low-level programming language whose sole objective is 
to compile other Seeds and the Sprout (a hihger-level 
language with similar syntax, but richer semantics).

All Seeds are written in *Seed language*, and thus can 
compile each other. Every computer architecture requires 
its own Seed. Porting the entire Seed/Sprout/Seedling 
stack onto a new architecture only requires writing a 
new Seed for the target architecture and compiling it 
with any existing Seed. The rest is done using the new 
Seed. In practice, it is probably easiest to modify a 
similar Seed rather than writing it from scratch using 
this specification.

## Contents

 * [Requirements](#requirements)
 * [The Seed Language](#the-seed-language)
   * [Parsing](#parsing)
   * [Seed Execution](#seed-execution)
   * [Computational Model](#computational-model)

## Requirements

The system on which Seed can run must have at least a 
sequential input steam through which source code is read 
and a sequential output stream through which the object 
code is written. For example, Seeds for Unix-like 
operating systems read from stdin and write to stdout. A 
Seed for some embedded device might use its serial 
console port.

The Seed object code (typically a few kilobytes) and the 
Seed stacks (typically less than a kilobyte) must fit 
into the RAM accessible to the Seed, as well as the 
assembler and the cross-compiler (typically a few 
kilobytes each). Thus, a computer running Seed and 
compiling the smallest of Seeds must have at least a 
dozen or so kilobytes of free RAM after booting Seed. 
Compiling a smaller Seed without a computer using only 
pen and paper is also feasible, albeit extremely 
tedious.

Importantly, the *Seed source* needs not fit into the 
memory, so it can (and should!) be richly commented to 
aid understanding and modification. The source for each 
Seed is a single 7-bit ASCII file with lines not 
exceeding 64 characters.

## The Seed Language

The Seed langauge is heavily inspired by Forth, so many 
of its features and conventions will be familiar to 
those who already know Forth. However, this 
specification makes no further references to Forth; 
knowing Forth is not required to understand it.

### Parsing

Seed sources consist of *lines* (not exceeding 64 
characters) terminated by either `LF` or `CR LF` sequences. 
Lines consist of *words* delimited by one or more 
*whitespace*: any character with ASCII codes below that of 
the exclamation mark !, excluding 0, which is not allowed 
in Seed source. Words cosist of *printable ASCII* 
characters in the range between ! and ~ (inclusive) and 
must be at most 30 characters long.

### Seed Execution

Seed starts in *interpreter mode*, reading a line from 
the input, iterating through its words and executing the 
corresponding computation for each one. In the beginning 
only the words specified in this document are allowed in 
Seed source; all other words must be ultimately defined in 
terms of these.

Computations in Seed may *succeed* or *fail* (see below 
for more details), however, all computations in Seed source 
must succeed.

The behavior of Seed in case of encountering undefined 
words or failing computations is undefined. Sensible 
behavior for interactive use may be outputing error 
messages and/or restarting, but it is not required.

### Computational model

Seed has two stacks, called *data stack* (or just *the 
stack* for short) and *return stack*. Both stacks have 
entries consisting of *cells* of equal size. The minimum 
cell size for Seed is 16 bits. *Pure* computations only 
affect the data stack and *succeed*. *Impure* 
computations may have side effects. Calls (except *tail 
calls*, see below) to other computations place an entry 
to the return stack which is popped off the return stack 
in case of success and the calling computation is 
continued.

Computations may reference other computations or 
themselves in *tail calls* which is how they continue 
after success without affecting the return stack. Tail 
calls in Seed are explicitly indicated, as described 
later.

A possible effect of some computations is *failure* in 
which case both stacks are reset to their positions at 
the time of the registration of the *failure handler* 
and the failure handler is deregistered (making the 
previous error handler active) and executed. Conditional 
failure is the only means of conditional branching in 
Seed. Unconditional failure is always a tail call, as 
the computation cannot succeed, once it failed.

