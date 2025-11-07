# Execution of Sprout Sources

The [Sprout language specification](README.md) describes the duality of 
*interpret mode* and *compile mode* behavior of words, while this document 
details the rationale behind it. At first, this duality may be a little 
confusing, but it is necessary to understand it for programming in Sprout.

## Introduction

Sprout is generally an *early binding* or *static* language, with the 
meaning of each word is fixed at the time of reading it from the source code, 
the same word at the same place in the source always has the same meaning. 
The source code is read sequentially, with no possiblity to re-read what 
has already been read.

The process of reading a word from the input and doing something depending on 
that word is referred to as *interpreting* the input. In order not to fix 
anything about the syntax that cannot be changed within the confines of the 
language itself, there is no syntax defined in the interpreter, each word 
is associated with its own *interpret mode behavior*.

It is not difficult to see that without some way of describing deferred 
computations that are not executed immediately, interpreting a 
sequentially read source cannot be Turing-complete. However, merely 
storing what is being read is not a suitable way of describing deferred 
computations, as the meaning of the words in its description might 
change by the time it needs to be executed, but the static nature of the 
language requires that it be fixed at the time of reading.

The process of looking up each word and creating a deferred computation from 
their meanings is referred to as *compiling*. Since some words' interpret 
mode behavior might alter the meaning of the words following them, creating 
a deferred computation from a sequence of words that does the same as 
interpreting them immediately is impossible without the program doing the 
*compiling* (called *compiler*) knowing what each word does.

## Why Interpreting?

One solution ensuring that immediately executable computations and deferred 
computations are written in the same static language would be always creating 
deferred computations upon reading the input and executing them afterwards. 
However, always compiling the input poses a number of challenges.

Chief among them is that in order for allowing the use of new words 
immediately after their definition, some computations, like the 
extension of the dictionary, cannot be deferred indefinitely and the 
compiler needs to be quite clever about knowing which computation can be 
deferred indefinitely and which needs to be executed before compiling the 
rest of the input.

To avoid the resulting complexity, Sprout and [Seed](../seed/README.md) 
interpret the input, executing everything immediately, with some words 
launching the compiler that reads the input up to some word that stops it.

## Differences between Compiling and Interpreting

The naive compilation strategy of chaining together the interpret mode 
behaviors of each successive word as a deferred computation breaks down 
with words that influence the interpretation of what follows. In most 
cases, the desired behavior is not deferring that influence until 
execution, but for it to have *immediate* effect. A typical example 
would be words changing the base of numeric literals, such as `hex`.

In addition to regular and immediate words, there are also some more 
complicated cases, typically involving reading the input, such as `'` 
(tick). Its interpret mode behavior is to read the next word and place a 
reference to its interpret mode behavior onto the stack. Making it a 
regular word would make the resulting computation to read the input and 
look up a word at execution. Making it an immediate word would place 
the reference onto the stack right after reading the word instead of 
compiling the corresponding action. Neither corresponds to compiling the 
placing the reference onto the stack.

In order not to restrict the programmer in their ability to meta-program the 
compiler, each word has a separate *compile time behavior* that is 
executed during compilation with a reference to the *interpret mode behavior* 
as an argument on the stack. It can be anything. However, the default is 
compiling the interpret mode behavior into the deferred computation. 
Immediate execution is an available option. However, the programmer is 
free to write any (deferred) computation.

## A Note on Cross-Compiling

So far, only the case when computations are deferred to be executed on the 
same computer later was discussed. However, a very important use case of 
Sprout (as well as Seed) is compiling programs executable on different 
computers. This is called cross-compilation.

The principal challenge here is that if we want to use freshly defined 
words not only in programs interpreted and compiled on the target 
architecture but also in words defined later during the cross-compiling, 
their compile time behaviors must be defined both in terms of the host 
and target architectures. This is not a problem with regular words, as 
both default compile time behaviors can be supplied in advance. With all 
the other words, however, it is a problem, as their compile time behavior 
needs to be compiled for the host architecture as well, even though at the 
time of cross-compiling host architecture definitions are not possible.

The solution is that the compile time behaviors of irregular words on 
the host architecture must be described in advance before cross-compiling. 
Usually, there are only a handful of those, so it is not that much of an 
overhead.

## Creative Meta-Programming

The source of the greatest confusion is usually second-order 
meta-programming: creating words to create words. Not just extending the 
dictionary, but extending the ways of extending the dictionary.

The key here is that `create`, contrarily to expectations, is a *regular 
word*. When used in the interpreted context, it creates a new word whose 
interpret mode behavior is to return a reference to whatever follows it 
on the heap. This implies that words that contain `create` in their 
definitions themselves are going to read the input to determine the name 
of the created word. The same is true for `constant`. Thus, both words 
can be used to create words that create words that initialize a data 
structure or a constant, respectively.

**Note:** The third option, for words creating executable words is currently 
`effect` but this will change soon, as it is an abuse of the notation and 
inconsistent with the cross-compiler.
