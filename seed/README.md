# The Seed

## Abstract

The Seed is a basic abstraction above the computer 
hardware and the operating system (if there is one; some 
Seeds may run on the "bare metal"). It is a program 
implementing the Seed language. The *Seed language* is a 
low-level programming language whose objective is to 
compile other Seeds and the Sprout (a hihger-level 
language with similar syntax, but richer semantics) as 
well as hardware drivers for it.

All Seeds are written in Seed language, and thus can 
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
   * [Compilation](#compilation)
   * [Vocabularies](#vocabularies)
 * [Word Rerefence](#word-reference)

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

Seeds should provide facilities for executing machine code 
and/or calls to the host operating system (if there is one), 
but these need not be standardized across Seeds as that 
code is not portable anyway.

## The Seed Language

The Seed langauge is heavily inspired by Forth, so many 
of its features and conventions will be familiar to 
those who already know Forth. However, this 
specification makes no further references to Forth; 
knowing Forth is not required to understand it.

### Parsing

Seed sources consist of *lines* (not exceeding 64 
characters) terminated by either `LF` or `CR LF` 
sequences. Lines consist of *words* delimited by one or 
more *whitespace* (blanks, ASCII code 32). Words cosist 
of *printable ASCII* characters in the range between ! 
and ~ (inclusive) and must be at most 30 characters 
long. Seed is case-sensitive, thus `Foo`, `FOO` and 
`foo` are three different words.

### Seed Execution

Seed starts in *interpret mode*, reading a line from 
the input, iterating through its words and executing the 
corresponding computation (called *interpret mode 
behavior*) for each one. In the beginning only the words 
specified in this document are allowed in Seed source; 
all other words must be ultimately defined in terms of 
these.

Computations in Seed may *succeed* or *fail* (see below 
for more details), however, all computations in Seed 
source must succeed.

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
(a computation itself) and the failure handler is 
deregistered (making the previous error handler active) 
and executed. Conditional failure is the only means of 
conditional branching in Seed. Unconditional failure is 
always a tail call, as the computation cannot succeed, 
once it failed.

In addition to the two stacks, a memory area called 
*heap* or *dictionary* (the two are used synonymously in 
the context of Seed) is available to Seed programs, 
which may be allocated as needed. Definitions of newly 
created words go here as well as any data that the Seed 
program may use. Note that Seed has no facilities for 
freeing up heap space. The heap forms a continuous 
memory area with addresses starting at some arbitrary 
number. Heap references must fit into one cell.

### Compilation

In addition to their *interpeter mode behavior* 
described above, words in Seed have a *compile mode 
behavior*: a computation that receives a reference to 
their interpret mode behavior as its argument on the 
stack when compiling *quotations* or *colon definitions*.

Quotations are computations that are built as a sequence 
of other computations. Colon definitions are named 
quotations that can be later referenced by their names.

The default compile mode behavior is to compile a call 
to the interpret mode behavior and succeed. Compiler 
mode behaviors that fail cause the end of the 
compilation.

### Vocabularies

Seed can handle multiple vocabularies (namespaces). It 
is searching for words in the *context vocabulary* and 
adds new definitions to the *current vocabulary*. In the 
beginning, both the context and the current vocabulary is 
the initial vocabulary named `seed`. Each new word added 
to it is immediately usable.

A newly created vocabulary already contains all the 
words from the current vocabulary at the time of 
creation. The word making the newly created vocabulary 
context (which is the name of the vocabulary) is added 
to the *parent vocabulary*, but is not part of the new 
vocabulary.

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
 * [.](#output-functions)
 * [/](#binary-arithmetic-primitives)
 * [/mod](#binary-arithmetic-primitives)
 * [0<>](#filters)
 * [0=](#filters)
 * [1+](#mappers)
 * [1-](#mappers)
 * [<](#relations)
 * [<=](#relations)
 * [<>](#relations)
 * [=](#relations)
 * [>](#relations)
 * [>=](#relations)
 * [>lit](#other-ways-to-create-and-modify-words)
 * [>lower](#mappers)
 * [>r](#stack-manipulation)
 * [>upper](#mappers)
 * [@](#heap-effects)
 * [\[](#unnamed-macros)
 * [\\](#comments)
 * [\]](#unnamed-macros)
 * [allot](#heap-effects)
 * [alphanum](#filters)
 * [and](#bitwise-logic-primitives)
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
 * [cons](#heap-effects)
 * [constant](#other-ways-to-create-and-modify-words)
 * [context](#predefined-constants)
 * [cr](#output-functions)
 * [create](#other-ways-to-create-and-modify-words)
 * [current](#predefined-constants)
 * [cut](#failure-handling)
 * [ddigit](#filters)
 * [decimal](#numeric-literals)
 * [definitions](#vocabulary-manipulation-words)
 * [dictionary](#predefined-constants)
 * [digit>int](#mappers)
 * [does](#other-ways-to-create-and-modify-words)
 * [dp](#predefined-constants)
 * [drop](#stack-manipulation)
 * [dup](#stack-manipulation)
 * [effect](#effect-handling)
 * [emit](#output-effects)
 * [endcomp](#other-ways-to-create-and-modify-words)
 * [endtail](#other-ways-to-create-and-modify-words)
 * [execute](#miscellaneous)
 * [find](#vocabulary-manipulation-words)
 * [handle](#effect-handling)
 * [here](#heap-effects)
 * [hex](#numeric-literals)
 * [immediate](#other-ways-to-create-and-modify-words)
 * [input](#input-effects)
 * [key](#input-effects)
 * [last](#vocabulary-manipulation-words)
 * [length](#mappers)
 * [letter](#filters)
 * [literal](#miscellaneous)
 * [lower](#filters)
 * [mod](#binary-arithmetic-primitives)
 * [nip](#stack-manipulation)
 * [nonempty](#filters)
 * [or](#bitwise-logic-primitives)
 * [over](#stack-manipulation)
 * [pad](#predefined-constants)
 * [postpone](#postponed-colon-definitions)
 * [printable](#filters)
 * [quotate](#other-ways-to-create-and-modify-words)
 * [r>](#stack-manipulation)
 * [s,](#heap-effects)
 * [s<>](#relations)
 * [s=](#relations)
 * [s>number](#miscellaneous)
 * [search](#vocabulary-manipulation-words)
 * [seed](#vocabulary-manipulation-words)
 * [seedl](#miscellaneous)
 * [space](#output-functions)
 * [swap](#stack-manipulation)
 * [third](#stack-manipulation)
 * [tib](#predefined-constants)
 * [traverse&](#miscellaneous)
 * [type](#output-functions)
 * [u*](#binary-arithmetic-primitives)
 * [upper](#filters)
 * [variable](#other-ways-to-create-and-modify-words)
 * [vocabulary](#vocabulary-manipulation-words)
 * [word](#input-functions)
 * [write](#output-effects)
 * [ws](#filters)
 * [wsskip](#mappers)
 * [xor](#bitwise-logic-primitives)
 * [{](#quotations)
 * [{:](#colon-definitions)
 * [{::](#postponed-colon-definitions)
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
would place zero on the data stack.

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
" Hello world!"
```

Places the reference to `Hello world!` on the data 
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

Example:
```
{ " Hello world!" type }~ cr
```

Places a reference to a computation that outputs 
`Hello world!` and a newline character on the data stack.

### Colon Definitions

Colon definitions start with the word `{:` (pronounced 
*"colon"*) and end the same way as quotations. Instead 
of placing the reference on the data stack, an 
association between the following word and the further 
described computation is written into the dictionary and 
added to the current vocabulary. The computation becomes 
the interpret mode behavior of the word, while the 
compile mode behavior is to compile a call to it.

Example:
```
{: greet " Hello world!" type }~ cr
```

Creates a new word `greet` outputting `Hello world!` and 
a newline.

### Postponed Colon Definitions

Using the word `postpone`, it is possible to postpone a 
colon definition of the following word, so that we can 
use the word before actually defining the computation 
associated with it. This comes in handy, for example, 
when two computations call each other.

The compile mode behavior changes (see later) must be 
added after the `postpone` statement, not the postponed 
definition. The postponed definition itself begins with 
the word `{::` (pronounced *"colon-colon"*) with a 
syntax that is identical to `{:`.

By convention, the type signature comment is added after 
the newly defined word both in the `postpone` statement 
and the actual definition.

### Other Ways to Create and Modify Words

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
 * `effect` creates a word that can be used in computations 
   that are given as the first argument to `handle`. See 
   [below](#effect-handling).

All the above words create words whose compile mode behavior 
is to compile a call to their (above described) interpret 
mode behavior, which always succeeds.

 * `does` changes the compile mode behavior of the most 
   recently defined word in the current vocabulary to 
   the computation to which a reference is popped off 
   the stack. This computation is given a reference on 
   the stack to the interpret mode behavior when 
   compiling the word.
 * `immediate` sets the compile mode behavior of the 
   most recently defined word in the current vocabulary 
   to executing the interpret mode behavior, effectively 
   turning the word into a named macro.

Below are other compile mode behaviors that can be assigned 
by `does`:

 * `endcomp` compiles a call to the interpret mode behavior 
   and ends the compiling.
 * `endtail` compiles a call to the interpret mode behavior,
   then a tail call to the interpret mode behavior of the 
   following word and then ends the compiling.
 * `>lit` compiles a literal from the interpret mode 
   behavior of the word that returns the value on the 
   stack as its interpret mode behavior (such as `ascii` and
   `'`).
 * `quotate` compiles a literal from the interpret mode 
   behavior of the word that allocates some data on the 
   heap and returns a reference to it (such as `"` and 
   `{`).

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
    number of bytes on the data stack. Places the bytes 
    actually written onto the data stack.

All of the above always succeeds.

### Output Functions

The functions below use the `emit` effect.

 * `.` outputs a numeral string in the current base 
   corresponding to the value popped from the data stack
   followed by a whitespace.
 * `space` outputs a whitespace.
 * `cr` outputs a line 
    ending of the underlying platform.
 * `type` outputs a zero-terminated string (without the 
    trailing zero) popping the reference from the data 
    stack.

All of the above always succeeds.

### Input Effects

 * `key` reads a byte from the input source and places it on 
   the stack.
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
 * `cons` takes a reference to a linked list and allocates 
   a new element linking to that list. The reference to the 
   new element is returned on the top of the stack.


All of the above always succeeds. *TODO: Out of memory 
effect*

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
 * `u*` (pronounced *"u-star"*) takes two cells from 
   the top of the data stack and replaces them by the 
   lower and the upper cells of their product. Unsigned.
 * `/mod` (pronounced *"slash-mod"*) takes two cells 
   from the top of the data stack and replaces them by 
   the reminder and the quotient after division. Unsigned.
 * `*` (pronounced *"star"*) impements `u* drop`.
 * `/` (pronounced *"slash"*) implements `/mod nip`.
 * `mod` implements `/mod drop`.

All of the above always succeeds.

### Bitwise Logic Primitives

 * `or` replaces the top two cells of the data stack by 
   their bitwise or.
 * `and` replaces the top two cells of the data stack by 
   their bitwise and.
 * `xor` replaces the top two cells of the data stack by 
   their bitwise xor.

All of the above always succeeds.

### Filters

Filters are functions that, depending on its value, 
either leave the topmost cell of the stack unchanged 
succeeding or fail.

 * `0=` (pronounced *"zero-equal"*) succeeds for zero
   values.
 * `0<>` (pronounced *"zero-unequal"*) succeeds for 
   non-zero.
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
 * `>lower` (pronounced *"to-lower") changes upper-case 
   letters to lower-case letters leaving every other value 
   unchanged.
 * `>upper` (pronounced *"to-upper") changes lower-case 
   letters to upper-case letters leaving every other value 
   unchanged.
 * `wsskip` (pronounced *"whitespace-skip"*) changes the 
   reference to a zero-terminated string to one without 
   leading whitespace characters.

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

 * `<` (pronounced *"less-is"*) compares two cells as 
   unsigned integers.
 * `<=` (pronounced *"less-is-or-equals"*) compares two 
   cells as unsigned integers.
 * `<>` (pronounced *"equals-not"*) compares two cells
 * `=` (pronounced *"equals"*) compares two cells
 * `>` (pronounced *"greater-is"*) compares two cells as 
   unsigned integers
 * `>=` (pronounced *"greater-is-or-equals"*) compares 
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
dup @ cons swap ! swap , , }

{: recall ( key list -( heap )- value )
traverse& third over @ = cut drop drop nip cell+ cell+ @ }
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

### Effect Handling

The word `handle` takes three arguments from the top of 
the stack (from bottom to top): a computation that 
contains calls to the handled effect, a computation that 
is the effect handler and a reference to the effect to 
handle. The handler is registered, the first computation is 
executed with the second substituted for the effect and then 
the handler is deregistered.

*TODO: a good example*

### Vocabulary Manipulation Words

The following two words only make sense in interpret mode.

 * `vocabulary` creates a new vocabulary adding its name
   to the current vocabulary. The new vocabulary's name 
   makes it the context vocabulary.
 * `definitions` sets the current vocabulary to the context 
   vocabulary, i. e. after `definitions` new word definitions 
   will be added to what was the context vocabulary before.

### Predefined constants

 * `base` points to a single byte containing the current base
 * `bl` is the ASCII code of the whitespace
 * `context` is a reference to the reference to the context 
    vocabulary.
 * `current` is a reference to the reference to the current 
    vocabulary
 * `dictionary` the lowmost writable address of the heap
 * `dp` the dictionary pointer, read by `here`
 * `pad` points to the buffer where words are read from the 
   input line.
 * `tib` points to a reference to the unread portion of the 
   input line.

### Miscellaneous

 * `bye` releases all resources held by Seed and exits
 * `carry?` fails, if the previous operation set the 
   carry flag
 * `literal` takes the cell on the top of the stack and 
   compiles a literal from it. Useful in macros.
 * `s>number` takes a string and transforms it into a number 
   on the top of the stack. However, it is not a mapper, 
   because it can fail and depends on the current base.
 * `execute` takes a reference to a computation off the top 
   of the stack and executes it.
 * `seedl` is the Seed loop.
 * `traverse&` is a generator traversing a linked list 
   created by `cons`. It generates references to the 
   *head* of each list element and after reaching the end of 
   the list it fails.
