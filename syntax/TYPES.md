# Types and Polymorphism

While Seedling-based languages can be dynamically typed, none of 
the three languages within the scope of this project are.

Type specifications are tuples consisting of types.

## Seed

Seed has no type checking, but type declarations are still necessary 
for compilation, though only for expressing the arity of functions, 
which in this context simply means the depth of the input and output 
stack effect.

Side effect declarations are ignored.

There is no polymorphism of any kind in Seed.

The following types are defined:

### Unsigned Integer

Denoted by `N`, it is a non-negative integer of the size of one 
machine word. Arithmetic overflow (result exceeding the word size) 
or underflow (negative result) results in failure. Seed sources 
never perform arithmetic operations overflowing 8 bits. *Maybe 16?*

### Character

Denoted by `C`, it denotes a single character. In Seed sources, 
characters never hold values exceeting 7 bits, for which 
ASCII encoding is assumed. In most implementations, it is 
an alias of `N`.

### Address

Denoted by `A` it points to a location in memory. The offset between two 
addresses is an integer, in Seed sources only non-negative offsets are used.
Addresses can be modified in both directions by non-negative offsets.
In most implementations, it is an alias of `N`.

### Sequence

Denoted by `S`, sequences are memory regions that can be cheaply spliced. 
In Seed, only byte sequences are defined. Typically represented as an 
`( A N )` tuple, but the start address and the length (number of elements) 
in the sequence requires explicit conversion, albeit in most implementation 
it results in no additional code compiled.

### Execution Token

Denoted by `E`, it contains all information required to execute compiled 
code. Together with an effect specification and data on the stack, it 
represents a closure. In most implementations, it is an alias of `A`.

### Quotation

Denoted by `Q`, quotations represent code subject to compilation. In Seed, 
they are represented by a byte sequence containing the ASCII source code 
to be compiled, but in higher-level languages they can be represented by 
some more processed data structure. Quotations require an additional 
*compilation context* to compile, consisting of type declaration and 
vocabulary.

### Vector

*Maybe not necessary.*

Denoted by `V`, vectors represent variable-depth data on the stack. Their 
representation contains their depth as the last element on the stack of type 
`N`.

## Sprout

Sprout allows for type-based polymorphism, whereby the vocabulary used for 
compiling a quotation depends on the input type.

## Seedling
