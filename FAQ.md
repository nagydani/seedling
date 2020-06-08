### What kind of language is Seedling (going to be)? 

A
[functional](#what-is-a-functional-language) 
[concatenative](#what-is-a-concatenative-language) language with 
[algebraic types](#what-are-algebraic-types) and 
[effects](#what-are-algebraic-effects). Control structures in Seedling are 
[goal oriented](#what-is-goal-oriented-control).
 
### What is a functional language?

A programming language in which functions are "first-class citizens", 
meaning that they can be passed, returned and manipulated (in case of 
functions composed, applied, etc.) just like any other data type.

### What is a conatenative language?

A programming language in which composition is denoted by concatenation. 
It is a syntactic principle allowing small parts of the program to be self-sufficient. 
Examples of existing concatenative languages inspiring Seedling would be [FORTH][FORTH], 
[Factor][Factor], [PostScript][PS] and [RPL][RPL].

### What are algebraic types?

Types which are composed of other types using *product-style* (e.g. records) and *sum-style* (e.g. unions) 
operations.

### What are algebraic effects?

In addition to their *argument type* and *return type* functions' type also incudes a set of effects. 
Typical effects would be *errors*, *I/O* and *resource use*.
Composition of functions results in the union of their effect sets being the effect set of the composed function. 
Effects can be removed (i.e. subtracted) from effects sets by explicit *handling*. Typical ways of handling 
effects are *catching* an error, *performing* the I/O operation or *accounting* for resource use. Another typical 
way of handling effects is *ignoring* them.

### What is goal-oriented control?

[FORTH]: https://en.wikipedia.org/wiki/Forth_(programming_language)
[Factor]:  https://factorcode.org/
[PS]: https://en.wikipedia.org/wiki/PostScript
[RPL]: https://en.wikipedia.org/wiki/RPL_(programming_language)
