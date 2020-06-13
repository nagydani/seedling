# Types and Polymorphism

While Seedling-based languages can be dynamically typed, none of 
the three languages within the scope of this project are.

## Seedling

Seedling has algebraic types. Any type is either `Primitive` or
`Record` or `Union`.

### Primitive types

Primitive types are (typically short) blobs of data with no 
accessible internal structure. Their only property is their size or, 
in more abstract terms, the possible number of different instances.

Primitive types can be instantiated by functions (called constructors) 
that either place a reference onto the stack or an instance. All 
references can exist on the stack, but not all instances.

One special primitive type is the `EmptyType` that has only one instance, 
`Nothing`. `Nothing` is the unit element of Seedling's type algebra.
`Nothing` cannot be instantiated (constructed), only referenced.

### Record

A record is the product type of other types. In Seedling, record types 
are built by a sequence of two-argument compositions. A `Record` type 
descriptor is typically a `Record` itself, containing two type 
references.

The product of any type with `Nothing` is the type itself.

### Union

Instances of a union type can be any of its members. The `Union` type 
descriptor is typically a `Record` of two functions (wrapped in 
`Primitive` data types called `Snippet`): One consumes a reference to a 
type descriptor and *fails* if this union cannot be of that type. The 
other consumes a reference to an instance of the `Union` and returns a 
reference to the type descriptor of the type of that particular 
instance.

### References

The type descriptor of a `Reference` is a `Record` consisting of a 
reference to the `Type` of the referenced instance, and some other 
information (typically a `Primitive`) needed to identify an instance of 
the referenced type.

Some references can be de-referenced to an instance of the corresponding 
type on the stack, but not for all types or even not for all instances 
of the same type depending on the type. References, however, can always 
be placed on the stack.

### Type Descriptors

The exact type of type descriptors is not part of Seedling specification 
and can differ between different platforms. Access to type descriptors 
is provided by standardized [effects](EFFECTS.md) so that platforms are 
capable of self-modification through replaced handlers.

The following information is available through effects:

 * The size of referenced `Primitive` types in bytes (which is the base 256 
   logarithm of the maximum possible number of instances). Platform-specific 
   restrictions may apply, like sizes of primitives on some 64-bit platforms 
   always being multiples of 8, or similar. The size of `Nothing` is 0.

 * References to the two members of a `Record`. Larger `Records` are 
   represented as binary trees of `Records`.

 * References to the following functions of a `Union` type:
   - The type of a referenced instance of a union type,
   - A "refined" reference (cast),
   - Checking whether a union type can have members of a given type.

 * The data stack is a `Record` with the right-hand member being the topmost 
   element on the stack and the left-hand member being the rest of the stack.

 * The call stack is a `Record` with the left-hand member being the topmost 
   element on the stack and the right-hand member being the rest of the stack.

## Sprout

Sprout allows for type-based polymorphism, whereby the vocabulary used for 
compiling a quotation depends on the input type.

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

