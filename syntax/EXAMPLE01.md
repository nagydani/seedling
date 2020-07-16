# String Equality Example

This example showcases how languages operating on different levels of abstraction can be sufficiently similar to 
facilitate learning, interfacing and language development.

## Contents

 * Seed
   - [Example 1](#example-1-raw-uncommented-seed)
   - [Example 2](#example-2-commented-and-formatted-seed)
 * Sprout
   - [Example 3](#example-3-using-sprout-features)
 * Seedling
   - [Example 4](#example-4-concise-seedling)

## Seed

Seed is essentially a cross-platform assembler and few things of importance will be ever written directly in it. 
However, it specifies the program down to very fine detail, so it has a place in optimizations and expressing 
such detail where appropriate. Seed has no type information, it needs to be meta-programmed directly. It can be 
compiled into machine code (or digital circuitry) sequentially, word by word.

### Example 1: Raw, Uncommented Seed

This code looks quite unreadable, but we will help it in our next example.

```
addrSize natSize + const strSize

{
  local }[ strSize natSize + ]{ @
  ' =
  'fail| }[ strSize addrSize + ]{
  local }[ strSize strSize + ]{ $
  {
    bite
    local }[ strSize strSize + charSize + ]{ $
    bite
    local }[ charSize strSize + charSize + ]{ ~ C@
  }
  {
    ' C=
    'fail| }[ strSize strSize + charSize + strSize + ]{
    drop
    local }[ strSize strSize + charSize + strSize + ]{ let$
    ~ drop
  }
  ' while
  'fail| }[ strSize ]{
  ~ drip
} defFn $=
```

Note that everything is measured in cells here, which might be one bit on the 
hardware level, 8 bits on an 8-bit CPU or 64 bits on a 64-bit CPU. A string is 
represented as the address of its first character followed by the number of 
characters in it as a natural number. The words `=` and `C=` check natural numbers 
and characters, respectively, for equality. On some platforms these two may be 
the same. The `'` (pronounced *tick*) is a reference to the function following it. 
`|` (pronounced *or*) is the disjunction operator taking two references to functions, 
evaluating the first then, upon failure, the second. So `'fail|` ( *tick-fail-or* ) 
seems to be redundant (and on a higher level of abstraction it is, as we shall see), 
but here it specifies how many cells to discard from the stack upon failure. The 
`~` (pronounced *tail*) indicates a tail call. Again, at a higher level it does not 
need to be explicitly specified, but in seed, it does. The pairs `}[` and `]{` enclose 
a numeric expression that needs to be compiled into the code (meta-number) as one 
numeric literal. `@` (pronounced *fetch*) replaces an address with a natural number 
at that address. `C@` ( *char-fetch* or *C-fetch*) replaces it with a character. 
On some platforms, `C@` and `@` can be the same. `$` ( *string* or *string-fetch* )
fetches a string, i.e. an address followed by a natural number.

The word `let` stores a natural number at the address popped off the stack, whereas 
`let$` ( *let-string* ) stores a string.

The word `local` reaches back into the stack a number of cells and leaves that address 
on the top of the stack. In Seed, one can reach back as far as natural numbers allow, as 
Seed is not aware of the arity of the functions or their type in general.

The word `drip` drops a string-sized number of cells.

The word `bite` denotes a function that takes a string, can read the memory, 
can fail and returns a string followed by a character. It fails, if the argument 
string is empty, in which case it does not return anything. Upon success, it 
returns the string without the first character followed by that very first character. 
Its type using what is a comment convention in Seed and syntax higher up would be 
`( str -( fail )- maybe str char )` 


### Example 2: Commented and Formatted Seed

The exact same code can be annotated a bit further, using commenting conventions 
that will become syntax in higher level languages. Additional indentation by 
downwards-pointing arrows (treated as whitespace) might indicate cells on the stack 
that are affected by the composed function as a whole, but not affected by that 
particular function. They are like leads on a circuit diagram. To reinforce that 
analogy, we can add horizontal strokes to arrows to the appropriate depth next to `local` 
words. In this 8-bit example, characters and natural numbers are 1 cells each, 
addresses are 2 cells and, consequently, strings are 3 cells. Because of this, 
gone are `C@` and `C=`, replaced by `@` and `=`, respectively.

```
[ addr ; ptr nat ; len ] rec str

{ in [ str ; a str ; b]
↓↓⤈⤈⤈⤈local 4 ;; a . len
↓↓↓↓↓↓@
↓↓↓↓↓↓↓' =
'fail| 5
⤈⤈⤈⤈⤈⤈local 6 ;; a
↓↓↓↓↓↓$
↓↓↓↓↓↓↓↓↓{ [ str ; b str ; a ] in
          ↓↓↓bite ; aFirst
          ⤈⤈⤈⤈⤈⤈⤈local 7 ;; b
          ↓↓↓↓↓↓↓$
          ↓↓↓↓↓↓↓bite ; bFirst
          ↓↓↓↓↓↓⤈⤈⤈⤈⤈local 5 ;; aFirst
          ↓↓↓↓↓↓↓↓↓↓↓~ @
          ↓↓↓can -( fail )-
          [ str maybe str char str char char ] out }
↓↓↓↓↓↓↓↓↓↓↓{ [ str ; b str char str char char ] in
            ↓↓↓↓↓↓↓↓↓↓↓↓' =
            'fail| 10
            ↓↓↓↓↓↓↓↓↓↓drop
            ⤈⤈⤈⤈⤈⤈⤈⤈⤈⤈local 10 ;; b
            ↓↓↓↓↓↓↓↓↓↓let$
            ↓↓↓↓↓↓~ drop
            can -( fail )-
            [ maybe str str ] out }
↓↓↓' while
'fail| 3
↓↓↓~ drip
can -( fail )-
out [ maybe str ] } defFn $=
```

The following annotations have been used (all ignored by Seed compiler):

`;` followed by a word labels the top of the stack at that point with that 
word. `;;` is used after `local` indicating the label where it actually reaches.
`[` and `]` enclose the sequence of slots of record types. Preceeded by `in` and 
`out`, they indicate the function's input and output type, respectively. The word 
`maybe` among these delimits the slots that are not returned upon failure. 
If the failure return type is not a prefix of the success return type, another word 
`|maybe` ( *or-maybe* ) should delimit the success type from the failure type. 
The `.` ( *dot* ) follows a label and is followed by another label from the type 
referenced by the first label, addressing a particular slot within it. Finally, 
`-(` and `)-` enclose the effect set of the function preceeded by `can`. If the 
effect set is empty (i.e. for pure functions), use `--` or simply omit it.

This is about as readable as Seed gets (which is, admittedly, not very much). 
More interestingly, with these annotations, Seed code becomes valid Sprout code. 
While Sprout code is not typically written this way (see the next example), but 
a trivial configuration of the Sprout compiler can turn any Sprout code into such 
annotated Seed code which is still valid Sprout code. This is important for 
bootstrapping so that Seed can build Sprout.

**Note** Strictly speaking memory reading is also an effect of string equality, but it is 
omitted here for simplicity (just like time and heat).

## Sprout

Sprout is a low-level systems programming language, much like C. It has a rudimentary 
type system, so at this level of abstraction, programmers do not need to concern 
themselves with cell-level granularity. The compliler knows how long various types 
are and can perform the relevant calculations and safety checks based on that. The 
arity of functions is measured in type slots rather than cells. However, memory 
and stack management are still very much the programmer's task.

### Example 3: Using Sprout Features

This is still recognizably the same algorithm, but the code below is no longer 
valid Seed code, as it relies on some calculations done by the Sprout compiler 
based on type information. Also, it is a lot more readable, while still not 
quite intuitive:

```
[ addr ; ptr nat ; len ] rec str

{ in [ str ; a str ; b]
↓↓a . len @
↓↓=
↓↓drop
↓↓a $
↓↓↓{ in [ str ; b str ; a ]
    ↓bite ; aFirst
    ↓↓↓b $
    ↓↓↓bite ; bFirst
    ↓↓↓↓↓aFirst @
    ↓can -( fail )-
    out [ str maybe str char str char char ] }
↓↓↓↓{ in [ str ; b str char str char char ]
     ↓↓↓↓=
     ↓↓↓↓drop
     ↓↓↓↓b let
     ↓↓drop
     can -( fail )-
     out [ maybe Str Str ] }
while
↓drop
can -( fail )-
out [ maybe Str ] } defFn =
```

Gone are the explicit tail calls (`~`), as the Seed compiler knows the functions' 
type and thus knows which functions have `~` as their effects so it can safely 
add `~` before the final call of each function that does not have this effect.

Gone are `'fail|` statements, because by default (and in the vast majority of 
cases) failing functions do not return any arguments (it is good programming 
practice to expose only such functions) so the compiler knows how deeply to 
discard the stack upon failure. In the rare cases when not the entire return 
argument of a function that can `fail` is `maybe`, it is best specified in the 
return argument by placing `maybe` or `|maybe` appropriately and let the 
compiler synchronize all failures rather than inferring the type from the code. 
This is somewhat in contrast to `drop` statements, which are also somewhat redundant 
with the return type, but letting the editor continually infer the type as one 
writes the code is a very powerful aid and guiding this aid by `drop` statements 
is quite natural. Also, `drop` statements, unlike `'fail|`'s do not need to be 
synchronized. So `drop` statement still appear in Sprout code, though they, too, 
will be gone at higher levels of abstraction.

**Note** The word `maybe` is just syntactic sugar. As a trivial example, 
the most common case when the failing function does not return anything can be 
expressed both as `out [ maybe ... ]` and as `out [ ... |maybe ]`, but the former 
is preferable. Everything `maybe` conveys can be expressed with `|maybe`, but often 
in a more verbose manner. The converse, however, is not true.

Also gone are special `let` and `drop` statements (`let$` and `drip`), as now the 
compiler can figure it out from the stack type and function types how to pick the 
right version of a polymorphic function. However, this is only an option. As an 
illustration, I left `$` in the code even though it would work perfectly with 
the polymorphic `@` now. Note, furthermore, that the name of our function changed 
from `$=` to simply `=` as the semantics is exactly the same as that of other 
equality functions, and since we have type information, we can simply make this 
a variant of the polymorhpic `=` function particularly for strings.

Gone are `local` statements, as we can use labels in their stead.

## Seedling

Seedling is a general-purpose application programming and algorithm-sketching 
language at around the abstraction level of Python. It is also probably the best 
starting point for learning programming and then delve deeper in the direction of 
gates and transistors (Sprout and Seed are steps in that direction) or climb higher 
in the direction of automated proof assistants. The main difference from Sprout is 
that Memory and stack management are no longer the programmer's job.

### Example 4: Concise Seedling

While still recognizably the same algorithm, at this level of abstraction the code 
becomes very readable. A lot of implementation detail is figured out by the compiler, 
this is more-or-less the minimal description of the algorithm without knowing what 
equality is. Incidentally, this is the highest level of abstraction at which this 
code still needs to be written; go one step higher, and the compiler would be able 
to derive equality function for strings simply from the type declaration of `str` 
and the declaration of abstract `=`.

```
{ in [ str ; a str ; b ]
a len b len =
a @ ; c
{ b bite ; one
  c bite ; other }
{ one @ other @ = }
while
can -( fail )-
out [ maybe str ] } defFn =
```

The internal representation of `str` is no longer relevant; as long as we have 
`len` and `bite` functions operating on them (or references to them), the compiler 
knows what to do.

Note that the type of the inner functions is omitted. However, unlike the first 
example, this is not because it doesn't have one, but because it is not interesting: 
Different types would satisfy the specification and it is really not important where 
and how everything is eventually dropped. We may give different objectives to the 
Seedling compiler about optimizing for speed, stack space, energy efficiency, 
object code length, etc. and they may result in different types for the inner functions. 
At this level, we do not care about lower-level details. We only specify what we 
do care about, like the function's type `( str str -( fail )- maybe str )` and the 
general structure of the algorithm. As long as our specification contains no 
contradictions, the compiler finds us a solution.
