# The Seed

## Abstract

The Seed is a limited minimalist abstraction above 
the computer hardware and possibly an operating system 
(some Seeds may run on the "bare metal"). It is a program 
implementing a subset of the [Sprout](../sprout/README.md) 
language. The *Sprout language* is a low-level programming 
language whose objective is to compile Seeds and Sprouts 
as well as the Seedling, a higher-level programming language 
with a similar syntax but substantially richer semantics. 
The *Seed language*, a subset of Sprout language implemented 
by the Seed, only suffices to compile other Seeds and Sprouts. 
Unlike Sprout, it is not a general-purpose programming 
language as it lacks features that are not necessary for 
compiling the Sprout, such as signed and floating-point 
arithmetics, namespaces, and facilities for memory management.

All Seeds are written in the Seed language, and thus can
compile each other. Every computer architecture requires 
its own Seed. In practice, it is probably easiest to modify a 
similar Seed rather than writing it from scratch using 
this specification, though it is certainly possible. A Seed 
compiled by any Seed or Sprout from the same source must 
result in the exact same binary. The Seed binary is the only 
binary that should be trusted in the bootstrapping process. 
Its brevity is intended to aid the verification of the 
correctness of Seed compilation.


## Contents

 * [Requirements](#requirements)
 * [The Seed Language](#the-seed-language)
 * [Seed Execution](#seed-execution)
 * [Word Reference](#word-reference)

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
pen and paper is also feasible, albeit rather tedious.

Importantly, the *Seed source* needs not fit into the 
memory, so it can (and should!) be richly commented to 
aid understanding and modification. The source for each 
Seed is a single 7-bit ASCII file with lines not 
exceeding 64 characters.

## The Seed Language

It is a proper subset of 
[Sprout](../sprout/README.md#the-sprout-language), 
following the same parsing rules and computational model.

An important restriction is that it only deals with 
unsigned integer numbers that must fit into one cell, 
which is the natural word size of the host architecture, 
but at least 16 bits. [Numeric literals](#numeric-literals) 
are restricted to digits, no signs or delimiting 
underscores are allowed.

Every seed *must* implement the words listed in this 
document, but may implement more for convenience.

## Seed Execution

Seed starts in *interpret mode*, reading a line from
the input, iterating through its words and executing the
corresponding computation (called *interpret mode
behavior*) for each one. In the beginning only the words
specified in this document are allowed in Sprout source;
all other words must be ultimately defined in terms of
these.

Computations in Seed may *succeed* or *fail* (see the 
Sprout documentation for details), however, all toplevel 
computations in Seed source must succeed.

The behavior of Seed in case of encountering undefined
words or failing computations is undefined. Sensible
behavior for interactive use may be outputting error
messages and/or restarting, but it is not required.

## Word Reference

 * [!](#heap-effects)
 * ["](#string-literals)
 * [&](#failure-handling)
 * ['](#computation-literals)
 * ['id](#computation-literals)
 * ['id|](#failure-handling)
 * ['id}~|](#failure-handling)
 * ['self](#computation-literals)
 * [(](#comments)
 * [*](#binary-arithmetic-primitives)
 * [+](#binary-arithmetic-primitives)
 * [,](#heap-effects)
 * [-](#binary-arithmetic-primitives)
 * [0<>](#filters)
 * [0=](#filters)
 * [1+](#mappers)
 * [1-](#mappers)
 * [<>](#relations)
 * [=](#relations)
 * [>r](#stack-manipulation)
 * [@](#heap-effects)
 * [\[](#unnamed-macros)
 * [\\](#comments)
 * [\]](#unnamed-macros)
 * [allot](#heap-effects)
 * [alphanum](#filters)
 * [and](#bitwise-primitives)
 * [ascii](#character-literals)
 * [base](#predefined-constants)
 * [bite](#input-functions)
 * [bl](#predefined-constants)
 * [bye](#miscellaneous)
 * [c!](#heap-effects)
 * [c,](#heap-effects)
 * [c@](#heap-effects)
 * [carry?](#miscellaneous)
 * [cell+](#mappers)
 * [cell-](#mappers)
 * [cells](#mappers)
 * [constant](#other-ways-to-create-words)
 * [create](#other-ways-to-create-words)
 * [cut](#failure-handling)
 * [ddigit](#filters)
 * [decimal](#numeric-literals)
 * [dictionary](#predefined-constants)
 * [digit>int](#mappers)
 * [drop](#stack-manipulation)
 * [dup](#stack-manipulation)
 * [emit](#output-effects)
 * [execute](#miscellaneous)
 * [here](#heap-effects)
 * [hex](#numeric-literals)
 * [invert](#mappers)
 * [input](#input-effects)
 * [key](#input-effects)
 * [length](#mappers)
 * [letter](#filters)
 * [link](#heap-effects)
 * [literal](#miscellaneous)
 * [lower](#filters)
 * [lshift](#bitwise-primitives)
 * [nip](#stack-manipulation)
 * [nonempty](#filters)
 * [or](#bitwise-primitives)
 * [output](#miscellaneous)
 * [over](#stack-manipulation)
 * [pad](#predefined-constants)
 * [printable](#filters)
 * [r>](#stack-manipulation)
 * [r>drop](#stack-manipulation)
 * [rshift](#bitwise-primitives)
 * [s,](#heap-effects)
 * [s<>](#relations)
 * [s=](#relations)
 * [s>number](#miscellaneous)
 * [seedl](#miscellaneous)
 * [swap](#stack-manipulation)
 * [third](#stack-manipulation)
 * [tib](#predefined-constants)
 * [traverse&](#miscellaneous)
 * [u<](#relations)
 * [u<=](#relations)
 * [u>](#relations)
 * [u>=](#relations)
 * [upper](#filters)
 * [variable](#other-ways-to-create-words)
 * [word](#input-functions)
 * [write](#output-effects)
 * [ws](#filters)
 * [xor](#bitwise-primitives)
 * [{](#quotations)
 * [{:](#colon-definitions)
 * [|](#failure-handling)
 * [}](#quotations)
 * [}~](#quotations)
 * [}~fail](#quotations)
 * [}~self](#quotations)
 * [}~|](#failure-handling)

### Comments

The word `\` denotes a comment till the end of the line. 
Note that since it is a word, there must be at least one 
whitespace between it and the rest of the comment.

The word `(` denotes a comment till the matching `)`. 
These comments are reserved for type signatures which 
will have a well-defined syntax, so that automatic type 
checkers can actually use them.

### Numeric Literals

Numeric literals are sequences of digits in the current 
base. Seed starts in base ten, but this can be changed. 
Digits from zero to nine are denoted by 0 to 9, whereas 
digits from ten to thirty-five are denoted by A to Z. 
Bases greater than thirty-six or smaller than two are 
not supported. Using digits greater or equal to the 
current base is not allowed.

Numeric literals place their *value* onto the data stack 
as a single cell. If the numeral value described by the 
literal is greater than what would fit into a cell then 
the reminder after division by 2 to the power of the 
cell size is placed onto the stack. So, for example the 
numeric literal 10000 in the current base of sixteen 
would place zero on the data stack, if the cell size is 
sixteen bits.

The words `hex` and `decimal` change the current base to 
sixteen and ten, respectively.

If a word is not found in the context vocabulary, an 
attempt to interpret it as a numeric literal is made. 
Thus, certain numeric values can be redefined as words, 
but unless their meaning is identical to the numeric 
literal they override, this can be very confusing and is 
best avoided.

### Character Literals

Character literals start with the word `ascii` and put 
the ASCII code of the first character of the following 
word onto the data stack. Thus, `ascii A` would put 
decimal 65 on the stack, and so would `ascii Alpha`. 
However, to avoid confusion, the latter use is 
discouraged.

### String Literals

String literals start with the word `"` (pronounced 
*"quote"*). Unlike most programming languages, there is 
a mandatory whitespace after `"`, which is not part of 
the string literal. String literals consist of printable 
characters and whitespace and are terminated by a double 
quote (`"`, pronounced *"unquote"*) character. Double 
quotes inside string literals are denoted by `\"` and 
backlashes by `\\`.

String literals must not contain line breaks. Thus, 
their maximal length is constrained by the line length.

A string literal compiles into the dictionary as a 
zero-terminated sequence of characters and its start 
address is placed on the data stack.

Example:
```
" Hello, world!"
```

Places the reference to `Hello, world!` on the data 
stack.

### Computation Literals

 * `'` (pronounced *"tick"*) followed by a word places a 
   reference to its interpret mode behavior onto the 
   data stack.
 * `'id` (pronounced *"tick-id"*) places a reference to the 
   empty (identity) computation onto the data stack.
 * `'self` (pronounced *"tick-self"*) places a reference to 
   the current *quotation* or *colon definition* (see below)
   onto the data stack.

### Quotations

Quotations start with the word `{` (pronounced 
*"brace"*). They are compiled into the dictionary as a 
computation to which a reference is placed onto the data 
stack.

There are several ways to end a quotation:

 * `}` (pronounced *"unbrace"*) ends the computation 
    with success.
 * `}~fail` (pronounced *"fail"*) ends the computation 
   with failure.
 * `}~self` (pronounced *"tail-self"*) ends the computation
   with a tail call to itself.
 * `}~` (pronounced *"tail"*) ends the computation with a 
   tail call to the interpret mode behavior of the
   following word.

There can be (and are) defined further words that end a 
quotation, if their compilation behavior fails. They will 
be discussed in other sections.

### Colon Definitions

Colon definitions start with the word `{:` (pronounced 
*"colon"*) and end the same way as quotations. Instead 
of placing the reference on the data stack, an 
association between the following word and the further 
described computation is written into the dictionary and 
added to the current vocabulary. The computation becomes 
the interpret mode behavior of the word, while the 
compile mode behavior is to compile a call to it.

### Other Ways to Create Words

 * `constant` creates a word that would put a single cell
   on the stack. Example: `6 constant six` creates a new word
   `six` that puts 6 on the stack.
 * `variable` creates a word that returns a reference to 
   a cell allocated on the heap and initializes it with 
   the topmost cell on the stack. Example `6 variable 
   years` creates a word that puts a reference on the 
   stack to a cell that initially contains 6. It can be 
   read by `years @` and written by `years !` (see below).
 * `create` creates a word that returns the reference
   to the top of the heap after its creation. It can be used 
   to refer to blocks of memory on the heap.

All the above words create words whose compile mode behavior 
is to compile a call to their (above described) interpret 
mode behavior, which always succeeds.

### Unnamed Macros

Unnamed macros start with the word `[` (pronounced 
*"meta"*) and end with the word `]` (pronounced 
*"end-meta"*). They must only be used in compile mode. 
What is between `[` and `]` is executed in interpreter 
mode allowing for compile-time computations.

Example:
```
{ [ 5 3 + literal ] . }
```

Places onto the data stack a reference to a computation 
that outputs 8. However, the addition of 5 and 3 happens 
in compile-time rather than in run-time.

### Output Effects

 * `emit` outputs a single byte popping it from the data 
    stack.
 * `write` outputs a given number of bytes from the 
    heap. Expects a reference to the first byte and the 
    number of bytes on the data stack. Places the number
    of bytes actually written onto the data stack.

All of the above always succeeds.

### Input Effects

 * `input` inputs a line from the input source and 
   points `tib` to its beginning. Facilities for interactive 
   editing might or might not be provided.

### Input Functions

 * `bite` if the line pointed by `tib` is empty, `bite` 
   fails. Otherwise, it reads the first byte from `tib` 
   placing it on the data stack and increments `tib`.
 * `word` reads the next word from the line buffer pointed 
   by `tib` and places it as a zero-terminated string in 
   the `pad` buffer. At the end of the line, it reads an 
   empty string. `word` never fails.

### Heap Effects

 * `,` (pronounced *"comma"*) allocates one cell on the 
   heap and writes the cell from the data stack to the 
   newly allocated place.
 * `c,` (pronounced *"see-comma"*) allocates one byte on 
   the heap and writes the least significant 8 bits of the 
   cell from the data stack to the newly allocated place.
 * `s,` (pronounces *"ess-comma"*) adds a zero-terminated 
   string referenced on the top of the stack to the heap, 
   allocating the corresponding space. Note that the 
   trailing zero itself is not added to the heap.
 * `allot` allocates the number of bytes on heap given by 
   the cell popped off the stack.
 * `here` puts the reference to the next byte to be allocated
    on the stack.
 * `@` (pronounced *"fetch"*) replaces the reference to a 
   heap location by the cell at that location on the stack.
 * `c@` (pronounced *"see-fetch"*) replaces the reference 
   to a heap location by the byte at that location on the 
   stack.
 * `!` (pronounced *"store"*) expects a value and a 
   reference on the top of the stack and writes the value to 
   the given location as a cell.
 * `c!` (pronounced *"see-store"*) expects a value and a 
   reference on the top of the stack and writes the 
   least significant 8 bits of the value to the given 
   location as a byte.
 * `link` takes a reference to a linked list and allocates 
   a new element linking to that list. The reference to the 
   new element is returned on the top of the stack.


All of the above always succeeds.

### Stack Manipulation

 * `drop` ( a -- )
 * `nip` ( a b -- b )
 * `swap` ( a b -- b a )
 * `dup` ( a -- a a )
 * `over` ( a b -- a b a )
 * `third` ( a b c -- a b c a )
 * `>r` (pronounced *"to-r"*) moves the top element of 
   the data stack to the return stack.
 * `r>` (pronounced *"r-from"*) moves the top element of 
   the return stack to the data stack.
 * `r>drop` (pronounced *"r-drop"*) drops the top element
   of the return stack. Equivalent to `r> drop`, but more
   efficient.

All of the above always succeeds.

### Binary Arithmetic primitives

These functions replace the top two cells of the data stack 
with the result of some arithmetic operation on them.

 * `+` (pronounced *"plus"*) takes two cells from 
   the top of the data stack and replaces them by their 
   sum. Sets *carry* on overflow.
 * `-` (pronounced *"minus"*) takes two cells from 
   the top of the data stack and replaces them by their 
   difference. Sets *carry* on underflow.
 * `*` (pronounced *"star"*) multiplication, implements `u* drop`.

All of the above always succeeds.

### Bitwise Primitives

 * `or` replaces the top two cells of the data stack by 
   their bitwise or.
 * `and` replaces the top two cells of the data stack by 
   their bitwise and.
 * `xor` replaces the top two cells of the data stack by 
   their bitwise xor.
 * `lshift` pops the counter off the top of the stack and 
   shifts the next cell (now on the top) a counter number 
   of times to the left.
 * `rshift` pops the counter off the top of the stack and 
   shifts the next cell (now on the top) a counter number 
   of times to the right, zeroing the leftmost bit.

All of the above always succeeds.

### Filters

Filters are functions that, depending on its value, 
either leave the topmost cell of the stack unchanged 
succeeding or fail.

 * `0=` (pronounced *"zero-equal"*) succeeds for zero
   values.
 * `0<>` (pronounced *"zero-unequal"*) succeeds for 
   non-zero values.
 * `nonempty` succeeds for non-empty strings.
 * `ddigit` succeeds for ASCII codes of decimal digits.
 * `upper` succeeds for ASCII codes of upper-case letters.
 * `lower` succeeds for ASCII codes of lower-case.
   letters
 * `letter` succeeds for ASCII codes of letters.
 * `alphanum` succeeds for ASCII codes of letters or 
    decimal digits.
 * `printable` succeeds for ASCII codes in the range between
   `!` and `~` (inclusive). 

### Mappers

Mappers change the value of the topmost cell on the data 
stack as pure functions. They always succeed.

 * `1+` (pronounced *"one-plus"*) increments the top 
   cell of the data stack by one. Sets *carry* on overflow.
 * `1-` (pronounced *"one-minus"*) decrements the top 
   cell of the data stack by one. Sets *carry* on underflow.
 * `cell+` (pronounced *"cell-plus"*) increments the top 
   cell of the data stack by the byte size of one cell.
 * `cell-` (pronounced *"cell-minus"*) decrements the top 
   cell of the data stack by the byte size of one cell.
 * `cells` multiplies the top cell of the data stack by 
   the byte size of one cell.
 * `invert` inverts every bit of the cell.

### Relations

All these relations succeed, if the two topmost cells 
on the stack are in the corresponding relation, dropping 
the topmost element. If the two topmost cells are not in 
the relation, the computation fails.

Relations curried with a single argument become filters.

Note on the recommended pronunciation: reading 
concatenative programming languages sounds somewhat like 
Yoda from Star Wars. We'll just reinforce this pattern 
here.

 * `=` (pronounced *"equals"*) compares two cells
 * `<>` (pronounced *"equals-not"*) compares two cells
 * `u<` (pronounced *"u-less-is"*) compares two cells as 
   unsigned integers.
 * `u<=` (pronounced *"u-less-is-or-equals"*) compares two 
   cells as unsigned integers.
 * `u>` (pronounced *"u-greater-is"*) compares two cells as 
   unsigned integers
 * `u>=` (pronounced *"u-greater-is-or-equals"*) compares 
   two cells as unsigned integers.
 * `s<>` (pronounced *"ess-equals-not"*) compares two 
   strings referenced by the two cells on the top of the 
   stack.
 * `s=` (pronounced *"ess-equals"*) compares two strings
   referenced by the two cells on the top of the stack.

### Failure Handling

`&` (pronounced *"pend"*) registers the reference from 
the top of the stack as the failure handler. It is useful 
for writing *generators* whose name by convention also ends 
with a `&` symbol.

Example:
```
{: scan& nonempty { 1+ }~ scan& & dup }~ c@
```

This generator called `scan&` takes a reference to a 
string as an argument on the data stack and produces its 
characters in sequence. At the end of the string, it fails.

`|` (pronounced *"or"*) is the disjunction combinator. 
It takes two references to computations as arguments and 
executes the first one with the second one as the 
failure handler. In practice, the disjunction succeeds if
any of its arguments succeed or in other words only fails 
if both arguments fail.

`'id|` (pronounced *"tick-id-or"*) implements `'id |`. 
It takes a reference to a computation as its sole 
argument, executing it with an empty failure handler. 
The idiomatic use of this word is giving it a 
tail-recursive computation that fails upon some condition 
resulting in a terminating loop that succeeds.

*TODO: a good example*

`}~|` (pronounced *"tail-or"*) ends a computation with a 
disjunction. It is equivalent to `}~ |` but the idiom is 
worth implementing as a single word.

Example:
```
{: hello& " Hello " }~ scan&

{: world& " world!" }~ scan&

{: helloWorld& ' hello& ' world& }~|
```

We have defined two generators and then chained them 
together using `}~|`.


`'id}~|` (pronounced *"tick-id-tail-or"*) implements 
`'id }~ |`, ending a computation.

Example:
```
{: countdown { 1- carry? dup . }~self 'id}~|
```

We defined a word `countdown` that takes an integer from 
the top of the stack and counts down to zero, succeeding 
in the end.

`cut` deregisters the current failure handler. It is 
particularly useful when we are only interested in the first 
result from a generator that passes a filter.

Example:
```
{: assoc ( key value list -( heap )- )
dup @ link swap ! swap , , }

{: recall ( key list -( heap )- value )
traverse& @ third s= cut drop nip cell+ cell+ @ }
```

In this example, the word `assoc` creates an association 
between a key and a value provided on the stack just 
below a reference to the list's head; a variable 
initialized with 0 for an empty association list. The 
more interesting word `recall` traverses the association 
list searching for the value corresponding to the 
provided key. Once such an association is found, the 
unneeded data are removed from the stack and the value 
is returned. If there is no such association in the 
list, the computation fails, because the generator fails.

The below example illustrates how `cut` works:

Example:
```
{: cutTest
  {
    { 1 . cut }~fail
    { 2 . }~fail
  }~|
  { 3 . }
}~|

```

The above defined `cutTest` word would output `1 3 `.

### Predefined constants

 * `base` points to a single byte containing the current base
 * `bl` is the ASCII code of the whitespace
 * `pad` points to the buffer where words are read from the 
   input line.
 * `tib` points to a reference to the unread portion of the 
   input line.

### Miscellaneous

 * `bye` releases all resources held by Seed and exits
 * `carry?` fails, if the previous operation set the 
   carry flag
 * `execute` takes a reference to a computation off the top 
   of the stack and executes it.
 * `literal` takes the cell on the top of the stack and 
   compiles a literal from it. Useful in macros.
 * `output` executes `seedl` with handlers set up in such a
   way that input is read from the rest of the input 
   stream and output is written to wherever object code 
   is expected. Typically, the first word in a Seed source.
 * `s>number` takes a string and transforms it into a number 
   on the top of the stack. However, it is not a mapper, 
   because it can fail and depends on the current base.
 * `seedl` is the Seed loop.
 * `traverse&` is a generator traversing a linked list 
   created by `link`. It generates references to the 
   *head* of each list element and after reaching the end of 
   the list it fails.
