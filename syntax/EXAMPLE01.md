# String Equality Example

This example showcases how languages operating on different levels of abstraction can be sufficiently similar to facilitate learning, interfacing and development.

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
`( Str` 


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
[ addr ; ptr nat ; len ] record str

{ [ str ; a str ; b] in
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
          ↓↓↓-( fail )-
          [ str maybe str char str char char ] out }
↓↓↓↓↓↓↓↓↓↓↓{ [ str ; b str char str char char ] in
            ↓↓↓↓↓↓↓↓↓↓↓↓' =
            'fail| 10
            ↓↓↓↓↓↓↓↓↓↓drop
            ⤈⤈⤈⤈⤈⤈⤈⤈⤈⤈local 10 ;; b
            ↓↓↓↓↓↓↓↓↓↓let$
            ↓↓↓↓↓↓~ drop
            -( fail )-
            [ maybe str str ] out }
↓↓↓' while
'fail| 3
↓↓↓~ drip
-( fail )-
[ maybe str ] out } defFn $=
```

The following annotations have been used (all ignored by Seed compiler):

`;` followed by a word labels the top of the stack at that point with that 
word. `;;` is used after `local` indicating the label where it actually reaches.
`[` and `]` enclose the sequence of slots of record types. Followed by `in` and 
`out`, they indicate the function's input and output type, respectively. The word 
`maybe` among these delimits the slots that are not returned upon failure. 
If the failure return type is not a prefix of the success return type, another word 
`|maybe` ( *or-maybe* ) should delimit the success type from the failure type. 
The `.` ( *dot* ) follows a label and is followed by another label from the type 
referenced by the first label, addressing a particular slot within it. Finally, 
`-(` and `)-` enclose the effect set of the function.

This is about as readable as Seed gets (which is, admittedly, not very much). 
More interestingly, with these annotations, Seed code becomes valid Sprout code. 
While Sprout code is not typically written this way (see the next example), but 
a trivial configuration of the Sprout compiler can turn any Sprout code into such 
annotated Seed code which is still valid Sprout code. This is important for 
bootstrapping so that Seed can build Sprout.

