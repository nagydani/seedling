### What kind of language is Seedling (going to be)? 

A
[functional](#what-is-a-functional-language) 
[concatenative](#what-is-a-concatenative-language) language with 
[algebraic types](#what-are-algebraic-types) and 
[effects](#what-are-algebraic-effects). Execution control in Seedling is 
[goal-directed](#what-is-goal-directed-execution).
 
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

### What is goal-directed execution?

Goal-directed execution is contrasted with *boolean-directed* execution. Conditional execution depends on whether 
or not functions *succeed* or more generally whether tasks achieve their goals and yield the expected result. All functions can *succeed*, therefore success is an implicit [effect](#what-are-algebriaic-effects) of all functions, which is typically ignored in single-threaded (one task) execution (though it can be handled for debugging purposes). Some functions can also *fail*, meaning that the goal of their computation cannot be achieved given their input. Failure is an explicit effect (called `fail` in Seedling) that backtracks the computation to wherever it is caught (catching is the only possible handling of a failure).

In concurrent execution, goals of computations can depend on the success of more than one task. Tasks can *yield* results 
that can be *processed* by other tasks. A task processing the result of another task that failed also fails.

Examples of languages with goal-directed execution control would be [make][make], [Icon][Icon] and [Prolog][Prolog]. 

Human reasoning can also be demonstrated to be naturally goal-directed, making goal-directed execution easier to understand.

[FORTH]: https://en.wikipedia.org/wiki/Forth_(programming_language)
[Factor]:  https://factorcode.org/
[PS]: https://en.wikipedia.org/wiki/PostScript
[RPL]: https://en.wikipedia.org/wiki/RPL_(programming_language)
[make]: https://en.wikipedia.org/wiki/Make_(software)
[Icon]: https://en.wikipedia.org/wiki/Icon_(programming_language)
[Prolog]: https://en.wikipedia.org/wiki/Prolog
