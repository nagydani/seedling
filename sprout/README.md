# The Sprout

## Abstract

The Sprout is a minimalist abstraction above the 
computer hardware and possibly an operating system (some 
Sprouts may run on the "bare metal"). It is a program 
implementing the Sprout language. The *Sprout language* 
is a low-level programming language whose objective is 
to compile other Sprouts and 
[Seedling](plan/stages.md#seedling) (a higher-level 
language with similar syntax, but much richer semantics) 
as well as hardware drivers for it. It is also possible 
to compile Seeds with Sprout, as the former is a proper 
subset of the latter.

All Sprouts are written in the Sprout language, and thus 
can compile each other. Every computer architecture 
requires its own Sprout. Porting the entire 
Seed/Sprout/Seedling stack onto a new architecture only 
requires writing a new Seed and a new Sprout for the 
target architecture and compiling it with any existing 
Seed. The rest is done using the new Sprout. In 
practice, it is probably easiest to modify a similar 
Sprout rather than writing it from scratch using this 
specification.

## Contents

 * [Requirements](#requirements)
 * [The Sprout Language](#the-sprout-language)
   * [Parsing](#parsing)
   * [Sprout Execution](#sprout-execution)
   * [Computational Model](#computational-model)
   * [Compilation](#compilation)
   * [Vocabularies](#vocabularies)
 * [Word Reference](#word-reference)

## Requirements

The system on which Sprout can run must have at least a 
sequential input steam through which source code is read 
and a sequential output stream through which the object 
code is written. For example, Sprouts for Unix-like 
operating systems read from stdin and write to stdout. A 
Sprout for some embedded device might use its serial 
console port.

The Sprout object code (typically less than a dozen 
kilobytes) and the Sprout stacks (typically less than a 
kilobyte) must fit into the RAM accessible to the 
Sprout, as well as the assembler and the cross-compiler 
(typically a few kilobytes each). Thus, a computer 
running Sprout and compiling the smallest of Sprouts 
must have at least sixteen or so kilobytes of free RAM 
after booting Sprout.

Importantly, the *Sprout source* needs not fit into the 
memory, so it can (and should!) be richly commented to 
aid understanding and modification. The source for each 
Sprout is a single UTF-8 file with lines not exceeding 
64 characters. Characters other than 7-bit ASCII are 
only allowed in comments, and character or string 
literals.

Sprouts should provide facilities for executing machine code 
and/or calls to the host operating system (if there is one), 
but these need not be standardized across Sprouts as that 
code is not portable anyway.

## The Sprout Language

The Sprout language is heavily inspired by Forth, 
therefore many of its features and conventions will be 
familiar to those who already know Forth. However, this 
specification makes no further references to Forth; 
knowing Forth is not required to understand it.

### Parsing

Sprout sources consist of *lines* (not exceeding 64 
characters) terminated by either `LF` or `CR LF` 
sequences. Lines beginning with a hash (`#`) are 
ignored. Lines consist of *words* delimited by one or 
more *whitespace* (blanks, ASCII code 32). Words consist 
of *printable ASCII* characters in the range between ! 
and ~ (inclusive) and must be at most 30 characters 
long. Sprout is case-sensitive, thus `Foo`, `FOO` and 
`foo` are three different words.

### Sprout Execution

Sprout starts in *interpret mode*, reading a line from 
the input, iterating through its words and executing the 
corresponding computation (called *interpret mode 
behavior*) for each one. In the beginning only the words 
specified in this document are allowed in Sprout source; 
all other words must be ultimately defined in terms of 
these.

Computations in Sprout may *succeed* or *fail* (see below 
for more details), however, all toplevel computations in 
Sprout source must succeed.

### Computational model

Sprout has two stacks, called *data stack* (or just *the 
stack* for short) and *return stack*. Both stacks have 
entries consisting of *cells* of equal size. The minimum 
cell size for Sprout is 16 bits. *Pure* computations only 
affect the data stack and *succeed*. *Impure* 
computations may have side effects. Calls (except *tail 
calls*, see below) to other computations place an entry 
to the return stack which is popped off the return stack 
in case of success and the calling computation is 
continued.

Computations may reference other computations or 
themselves in *tail calls* which is how they continue 
after success without affecting the return stack. Tail 
calls in Sprout are explicitly indicated, as described 
later.

A possible effect of a computation is *failure*, in 
which case both stacks are reset to their positions at 
the time of the registration of the most recent *failure 
handler* (which is a computation itself), the failure 
handler is deregistered (making the previous failure 
handler active), and then executed. Conditional failure 
is the only means of conditional branching in Sprout. 
Unconditional failure is always a tail call, as the 
computation cannot succeed, once it failed.

In addition to the two stacks, a third memory area is 
available to Sprout programs called *heap* or 
*dictionary* (the two are used synonymously in the 
context of Sprout). New entries can be allocated 
dynamically, and dictionary space can only be freed up 
in a LIFO fashion, similarly to stacks. Definitions of 
newly created words go here as well as any additional 
data that the Sprout program may want to use. The heap 
forms a continuous memory area with addresses starting 
at some arbitrary number. Heap references must fit into 
one cell.

For temporarily allocated memory, computations in Sprout 
can use memory *frames*, which are de-allocated when the 
computation succeeds or fails.

### Compilation

In addition to their *interpreter mode behavior* 
described above, words in Sprout have a *compile mode 
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

Sprout can handle multiple vocabularies (namespaces). It 
is searching for words in the *context vocabulary* and 
adds new definitions to the *current vocabulary*. In the 
beginning, both the context and the current vocabulary is 
the initial vocabulary named `sprout`. Each new word added 
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
 * [*](#arithmetic-primitives)
 * [+](#arithmetic-primitives)
 * [,](#heap-effects)
 * [-](#arithmetic-primitives)
 * [.](#output-functions)
 * [/](#arithmetic-primitives)
 * [0/](#exception-handling)
 * [0<](#filters)
 * [0<>](#filters)
 * [0>=](#filters)
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
 * [abs](#mappers)
 * [allot](#heap-effects)
 * [alphanum](#filters)
 * [and](#bitwise-primitives)
 * [ascii](#character-literals)
 * [ask](#computations-with-environment)
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
 * [du/mod](#arithmetic-primitives)
 * [dup](#stack-manipulation)
 * [effect](#effect-handling)
 * [emit](#output-functions)
 * [endcomp](#other-ways-to-create-and-modify-words)
 * [endtail](#other-ways-to-create-and-modify-words)
 * [execute](#miscellaneous)
 * [f.](#output-functions)
 * [f*](#arithmetic-primitives)
 * [f+](#arithmetic-primitives)
 * [f-](#arithmetic-primitives)
 * [f/](#arithmetic-primitives)
 * [f<](#relations)
 * [f<=](#relations)
 * [f<>](#relations)
 * [f=](#relations)
 * [f>](#relations)
 * [f>int](#mappers)
 * [f>=](#relations)
 * [f0<](#filters)
 * [f0<>](#filters)
 * [f0>=](#filters)
 * [f0=](#filters)
 * [fabs](#mappers)
 * [fbot](#frame-handling)
 * [ffrac](#mappers)
 * [fhalf](#mappers)
 * [finally](#miscellaneous)
 * [find](#vocabulary-manipulation-words)
 * [fint](#mappers)
 * [flog2](#mappers)
 * [fnegate](#mappers)
 * [frame](#frame-handling)
 * [ftop](#frame-handling)
 * [handle](#effect-handling)
 * [here](#heap-effects)
 * [hex](#numeric-literals)
 * [immediate](#other-ways-to-create-and-modify-words)
 * [int>f](#mappers)
 * [invert](#mappers)
 * [input](#input-effects)
 * [key](#input-effects)
 * [last](#vocabulary-manipulation-words)
 * [length](#mappers)
 * [letter](#filters)
 * [link](#heap-effects)
 * [literal](#miscellaneous)
 * [lower](#filters)
 * [lshift](#bitwise-primitives)
 * [mod](#arithmetic-primitives)
 * [negate](#mappers)
 * [nip](#stack-manipulation)
 * [nonempty](#filters)
 * [or](#bitwise-primitives)
 * [output](#miscellaneous)
 * [over](#stack-manipulation)
 * [pad](#predefined-constants)
 * [pfbot](#frame-handling)
 * [pftop](#frame-handling)
 * [postpone](#postponed-colon-definitions)
 * [printable](#filters)
 * [quotate](#other-ways-to-create-and-modify-words)
 * [r>](#stack-manipulation)
 * [r>drop](#stack-manipulation)
 * [reader](#computations-with-environment)
 * [rshift](#bitwise-primitives)
 * [s.](#output-functions)
 * [s,](#heap-effects)
 * [s<>](#relations)
 * [s=](#relations)
 * [s>number](#miscellaneous)
 * [search](#vocabulary-manipulation-words)
 * [space](#output-functions)
 * [sprout](#vocabulary-manipulation-words)
 * [sproutl](#miscellaneous)
 * [swap](#stack-manipulation)
 * [third](#stack-manipulation)
 * [tib](#predefined-constants)
 * [traverse&](#miscellaneous)
 * [u*](#arithmetic-primitives)
 * [u/](#arithmetic-primitives)
 * [u/mod](#arithmetic-primitives)
 * [u<](#relations)
 * [u<=](#relations)
 * [u>](#relations)
 * [u>=](#relations)
 * [u8bite](#input-functions)
 * [u8emit](#output-functions)
 * [u8length](#mappers)
 * [u8key](#input-functions)
 * [upper](#filters)
 * [utf8](#character-literals)
 * [variable](#other-ways-to-create-and-modify-words)
 * [vocabulary](#vocabulary-manipulation-words)
 * [word](#input-functions)
 * [write](#output-effects)
 * [ws](#filters)
 * [wsskip](#mappers)
 * [xor](#bitwise-primitives)
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

Integer literals are sequences of digits in the current 
base, preceded by a minus sign `-` for negative values, 
and optionally interspersed with `_` (underscore) 
characters, which are ignored. At least one digit must 
precede the first underscore. Sprout starts in base ten, 
but this can be changed. Digits from zero to nine are 
denoted by 0 to 9, whereas digits from ten to 
thirty-five are denoted by A to Z. Bases greater than 
thirty-six or smaller than two are not supported. Using 
digits greater or equal to the current base is not 
allowed.

Integer literals place their *value* onto the data stack 
as a single cell. If the numeral value described by the 
literal is greater than what would fit into a cell then 
the reminder after division by 2 to the power of the 
cell size is placed onto the stack. So, for example the 
numeric literal 10000 in the current base of sixteen 
would place zero on the data stack, if the cell size is 
sixteen bits.

Floating point literals begin with an optional `-` 
(minus sign) for negative values followed by a sequence 
of digits interspersed with optional underscores 
similarly to integer literals, but it must contain a 
fractional dot anywhere between before the first digit 
and after the last digit of the sequence. The sequence 
is optionally followed by the letter `e` and an integer 
literal indicating a multiplier of the current base 
raised to an integer power.

Floating point literals place a fixed number of cells 
(the actual number is architecture-dependent but is 
typically one or two) on the data stack, representing 
the floating-point value of the literal.

The words `hex` and `decimal` change the current base to 
sixteen and ten, respectively.

If a word is not found in the context vocabulary, an 
attempt to interpret it as a numeric literal is made. 
Thus, certain numeric values can be redefined as words, 
but unless their meaning is identical to the numeric 
literal they override, this can be very confusing and is 
best avoided.

### Character Literals

Character literals start with the word `utf8` and put 
the unicode codepoint of the first non-whitespace 
character encoded in UTF-8 onto the stack. Thus, `utf8 
A` would put decimal 65 on the stack and `utf8 €` would 
put decimal 8364 on the stack. The UTF-8 character must 
be followed by whitespace or line ending.

For compatibility with Seed, character literals in 
Sprout can also be written using the word `ascii` 
followed by a word, whose first character's ASCII code 
is placed on the top of the stack. Thus, `ascii A` would 
put decimal 65 on the stack and so would `ascii Alpha`. 
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

Example:
```
{ " Hello, world!" s. }~ cr
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
{: greet " Hello, world!" s. }~ cr
```

Creates a new word `greet` outputting `Hello, world!` and 
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
   [below](#effect-handling) for details. It takes a 
   reference to a computation that is the default handler 
   as its argument.
 * `exception` creates a word that can be used in 
   computations that are given as the first argument to 
   `catch`. See [below](#exception-handling) for details. 

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
   turning the word into a named macro. Synonymous with
   `' execute does`

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

 * `write` outputs a given number of bytes from the 
    heap. Expects a reference to the first byte and the 
    number of bytes on the data stack. Places the bytes 
    actually written onto the data stack.

All of the above always succeeds.

### Output Functions

The functions below use the `write` effect.

 * `emit` outputs a single byte popping it from the data 
    stack. If the value is outside of the byte range, the 
    least significant byte is outputed.
 * `.` outputs a numeral string in the current base 
   corresponding to the signed integer value popped from 
   the data stack followed by a blank.
 * `u.` outputs a numeral string in the current base 
   corresponding to the unsigned integer value popped 
   from the data stack followed by a blank.
 * `f.` outputs a numeral string in the current base 
   corresponding to the floating point value popped from 
   the data stack followed by a blank.
 * `s.` outputs a zero-terminated string (without the 
    trailing zero) popping the reference from the data 
    stack.
 * `u8emit` outputs a single unicode codepoint in UTF-8 
   encoding.
 * `space` outputs a blank.
 * `cr` outputs a line ending of the underlying
    platform.

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
   placing it on the data stack, and increments `tib`.
 * `u8bite` if the line pointed by `tib` is empty, 
   `u8bite` fails. Otherwise, it reads the first unicode 
   codepoint encoded in UTF-8 from `tib` placing it on the 
   data stack, and increments `tib`.
 * `u8key` reads a unicode codepoint encoded in UTF-8 from 
   the input source and places it on the stack.
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
 * `r>drop` (pronounced *"r-drop"*) drops the top element
   of the return stack. Equivalent to `r> drop`, but more
   efficient.

All of the above always succeeds.

### Arithmetic Primitives

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
 * `u/mod` (pronounced *"u-slash-mod"*) takes two cells 
   from the top of the data stack and replaces them by 
   the reminder and the quotient after division. 
   Unsigned, implements `0 swap du/mod`. Raises a '0/' 
   exception, if the divisor is zero.
 * `*` (pronounced *"star"*) multiplication, implements 
   `u* drop`.
 * `/` (pronounced *"slash"*) signed division, rounds 
   towards negative infinity. Raises a '0/' exception, 
   if the divisor is zero.
 * `u/` (pronounced *"u-slash"*) unsigned 
   division, implements `u/mod nip`. raises a '0/' exception,
   if the divisor is zero.
 * `mod` signed modulus, if not zero, same sign as 
   divisor. Raises a '0/' exception, if the divisor is zero
 * `umod` unsigned modulus, implements `u/mod drop`.
   Raises a '0/' exception, if the divisor is zero.

The following function has three argument cells.

 * `du/mod` (pronounced *"du-slash-mod"*) takes three 
   cells from the top of the data stack and replaces 
   them by the reminder and the quotient after divding 
   the first two as a double integer by the third (on 
   the top of the stack). Unsigned. Raises a '0/' exception,
   if the divisor is zero.

The following functions take two floating point cells 
off the top of the stack and replace them by the result 
of the calculation. Note that floating point cells may be 
more than one cell, depending on the architecture.

 * `f+` (pronounced *"f-plus"*) floating-point addition.
 * `f-` (pronounced *"f-minus"*) floating-point subtraction.
 * `f*` (pronounced *"f-star"*) floating-point multiplication.
 * `f/` (pronounced *"f-slash"*) floating-point division.
 * `f^` (pronounced *"f-hat"*) floating-point power.

All of the above always succeeds.

*TODO: division overflow effect*

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
 * `arshift` pops the counter off the top of the stack and 
   shifts the next cell (now on the top) a counter number 
   of times to the right, keeping the leftmost bit intact.

All of the above always succeeds.

### Filters

Filters are functions that, depending on its value, 
either leave the topmost cell of the stack unchanged 
succeeding or fail.

 * `0=` (pronounced *"zero-equal"*) succeeds for zero
   values.
 * `0<>` (pronounced *"zero-unequal"*) succeeds for 
   non-zero values.
 * '0>=' (pronounced *"non-negative"*) succeeds for
   non-negative values.
 * '0<' (pronounced *"negative"*) succeeds for negative
   values.
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

The filters below work on a floating-point cell which, 
depending on the architecture, may be one or more cells.

 * `f0=` (pronounced *"f-zero-equal"*) succeeds for zero
   values.
 * `f0<>` (pronounced *"f-zero-unequal"*) succeeds for 
   non-zero values.
 * 'f0>=' (pronounced *"f-non-negative"*) succeeds for
   non-negative values.
 * 'f0<' (pronounced *"f-negative"*) succeeds for negative
   values.

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
 * `>lower` (pronounced *"to-lower"*) changes upper-case 
   letters to lower-case letters leaving every other value 
   unchanged.
 * `>upper` (pronounced *"to-upper"*) changes lower-case 
   letters to upper-case letters leaving every other value 
   unchanged.
 * `wsskip` (pronounced *"whitespace-skip"*) changes the 
   reference to a zero-terminated string to one without 
   leading whitespace characters.
 * `abs` absolute value of a signed integer.
 * `negate` negates a signed integer.
 * `invert` inverts every bit of the cell.
 * `length` changes a string reference to its length *in 
   bytes*.
 * `u8length` changes a string reference to its length 
   *in characters* encoded in UTF-8.

The following mappers work on a floating-point cell, which 
is one or more cells depending on the architecture:

 * `fhalf` halves the value on the top of the stack.
 * `flog2` calculates the base 2 logarithm.
 * `fnegate` changes the sign of the value on the top of 
   the stack.
 * `fabs` takes the absolute value.
 * `fint` rounds to the nearest integer in the direction of
   negative infinity.
 * `ffrac` takes the fractional part. Guaranteed to be 
   between 0.0 (inclusive) and 1.0 (exclusive).

The words `f>int` and `int>f` convert between floating point 
numbers and signed integers.

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
 * `<` (pronounced *"less-is"*) compares two cells as 
   signed integers.
 * `<=` (pronounced *"less-is-or-equals"*) compares two 
   cells as signed integers.
 * `>` (pronounced *"greater-is"*) compares two cells as 
   signed integers
 * `>=` (pronounced *"greater-is-or-equals"*) compares 
   two cells as signed integers.
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

### Effect Handling

The word `handle` takes three arguments from the top of 
the stack (from bottom to top): a computation that may 
contain calls to the handled effect, a computation that 
is the effect handler and a reference to the effect to 
handle. The handler is registered, the first computation 
is executed with the second substituted for the effect 
and then the handler is deregistered.

*TODO: a good example*

### Exception Handling

Exceptions are special effects, which terminate the 
computation due to some exceptional condition. 
Exceptions are very similar to failures (indeed, failure 
is a special exception) in that once an exception is 
raised, there is no return to the computation. They are 
typically used to signal an error so bad that the 
computation cannot be completed to success nor failure.

The word `catch` takes three arguments from the top of 
the stack (from bottom to top): a computation that may 
raise the handled exception, a computation that is the 
exception handler and a reference to the exception to 
handle.

Example:
```
{: .quot { / . } { " nonsense " s. } ' 0/ }~ catch
```

The word `.quot` outputs the quotient after division, but 
if the divisor is zero, it outputs `nonsense `. It 
achieves this by catching the built-in exception `0/` 
which signals division by zero.

### Frame Handling

Another special effect is working memory use. The word 
`frame` takes two arguments form the top of the stack 
(from bottom to top): a computation that uses working 
memory and the amount of working memory in cells. The 
memory frame is allocated, then the computation executed 
and finally, the memory frame is reclaimed.

To the computation that uses working memory the 
following words are available:

 * `fbot` puts a reference to the base of the frame onto 
   the top of the stack.
 * `ftop` puts a reference to the top of the frame onto 
   the top of the stack. Note that this reference is only 
   for comparison, accessing it is an error.
 * `pfbot` puts a reference to the base of the previous 
   frame, if there is one, onto the top of the stack. 
   Otherwise, it fails.
 * `pftop` puts a reference to the top of the previous 
   frame, if there is one, onto the top of the stack. 
   Otherwise, it fails. Note that this reference is only 
   for comparison, accessing it is an error.

Example:
```
{ { pfbot . } 10 frame fbot . } 10 frame
```

Outputs the same address twice. It is the base reference 
of the outer frame.

### Computations with Environment

Yet another special effect is accessing a value (the 
so-called *environment*), possibly from multiple parts 
of the computation. The word `ask` places the environment 
onto the stack.

The word `reader` has two arguments (from bottom to top):
a reference to a computation to be executed with environment 
and the environment itself.

Example:
```
{: demo { ask { 0> 1- ask . }~self 'id}~| swap }~ reader
```

The above defined word `demo` takes a number off the top 
of the stack and outputs it as many times as the number 
itself.

### Vocabulary Manipulation Words

The word `find` searches the context vocabulary for the 
word in the `pad`. If it is not found, the computation 
fails. If it is found, then references to the interpret 
and compile mode behaviors are placed on the stack, in
this order.

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
 * `dictionary` the low-most writable address of the heap
 * `dp` the dictionary pointer, read by `here`
 * `pad` points to the buffer where words are read from the 
   input line.
 * `tib` points to a reference to the unread portion of the 
   input line.

### Miscellaneous

 * `bye` releases all resources held by Sprout and exits
 * `carry?` fails, if the previous operation set the 
   carry flag
 * `execute` takes a reference to a computation off the top 
   of the stack and executes it.
 * `finally` takes a reference to a computation off the top
   of the stack and schedules it for execution after the 
   current computation finishes in either success, failure 
   or an exception. *Important*: the computation scheduled 
   by `finally` must leave the stack as it was before its
   execution. It is typically used for cleanup of resources 
   such as open files.
 * `literal` takes the cell on the top of the stack and 
   compiles a literal from it. Useful in macros.
 * `output` executes `sproutl` with handlers set up in such a
   way that input is read from the rest of the input 
   stream and output is written to wherever object code 
   is expected. Typically, the first word in a Sprout source.
 * `s>number` takes a string and transforms it into a number 
   on the top of the stack. However, it is not a mapper, 
   because it can fail and depends on the current base.
 * `sproutl` is the Sprout loop.
 * `traverse&` is a generator traversing a linked list 
   created by `link`. It generates references to the 
   *head* of each list element and after reaching the end of 
   the list it fails.
