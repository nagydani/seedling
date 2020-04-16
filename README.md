# Seedling

A Programming Language for Everyone and Everything

## Motivation

It is a very sorry state of affairs that we use completely unrelated, different and often quite incompatible programming languages for
 * teaching programming,
 * interacting with the command line and scripting the shell,
 * solving numerical problems of high complexity,
 * programming microcontrollers and device drivers,
 * marking up (or down) hypertext,
 * writing interpreters and compilers,
 * writing macros for, well, anything,
 * assembling machine code with full control over each bit,
 * describing the build process of a complex piece of software,
 * drafting smart contracts for decentralized applications,
 * transacting with these smart contracts,
 * synthesizing or annotating nucleotide sequences,
 * cooking gourmet dishes,
 * choreographing stage performances.

The only thing worse than solving all these different programming tasks in different programming languages is using the *wrong* language for a particular task. Experienced programmers would answer that different langauges are suited for different purposes, so why not let a thousand flowers bloom? There is nothing wrong with using different programming languages, but the fact that they all differ in some unnecessary ways causes several problems:
 * Life is too short for learning everything (and so are project deadlines), especially radically different, unfamiliar things.
 * Because of this, we regularly apply inadequate tools for the only reason that we *know* them.
 * The sheer variety of radically different approaches to programming unnecessarily intimidates beginners scaring them into believing that they will never learn programming and, even more importantly, unnecesarily *clouds the notion of what programming is*, making the beginner's life miserable.

Ever since Alan Turing's seminal insight, we *know* that programming tasks are *fundamentally* the same and that any Turing-complete language can express everything, but the human and computational costs can be quite different (only up to a polynomial factor, mathematicians would retort, but when years of life and wads of money are at stake, we *do* care about those).

Every now and then you meet programmers enamored with some programming language that advocate for using *their* favorite language for everything, but with one notable exception they usually don't succeed in convincing the rest of the world and for very good reasons. Not for a long time, anyway; sometimes programming languages do become fashionable for a short while, but as soon as their limitations become apparent and the coolness factor wears off, they either go entirely out of fashion or, in the best case, carve out a niche for tasks for which they are particularly well suited. The exception is **C**.

C is so tighly woven into the fabric of computing that if you do anything with computers, sooner rather than later you will have to either execute, write, read or interface with C code. Most things from the list above have been done in C or some C-like language. Quite a few are regularly done that way and have been for the last half century. While C permeates everything, the problems caused by the inadequacy of C for the tasks to which it is applied regularly creates problems of magnitude quite comparable to that of the whole programming endeavor. C is the glue that keeps our computing together and is part of the reason why things fall apart more often than they should.

C was created by geniuses at AT&T Bell Labs in the late 1960's. It has some evolutionary advantages over every other programming language in existence allowing it to outcompete them in the long run. It created an incredibly strong network effect, but it also successfully broke pre-existing network effects and replaced entrenched programming languages in many tasks, as the obviously superior choice, well worth the effort of rewriting a lot of code.
