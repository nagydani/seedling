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

C is so tighly woven into the fabric of computing that if you do anything with computers, sooner rather than later you will have to either execute, write, read or interface with C code. Most things from the list above have been done in C or some C-derived language. Quite a few are regularly done that way and have been for the last half century. While C permeates everything, the problems caused by the inadequacy of C for the tasks to which it is applied regularly creates problems of magnitude quite comparable to that of the whole programming endeavor. C is the glue that keeps our computing together and is part of the reason why things break and fall apart more often than they should.

C was created by geniuses at AT&T Bell Labs in the late 1960's. It has some evolutionary advantages over every other programming language in existence allowing it to outcompete them in the long run. It created an incredibly strong network effect, but it also successfully broke pre-existing network effects and replaced entrenched programming languages in many tasks, as the obviously superior choice, well worth the effort of rewriting a lot of code. Most of us (very much including myself) are considerably dumber than the pioneers of C, but we have the advantage of 50 years of hindsight and we can learn from them. They have proven that it is possible to overhaul the computing infrastrucutre and the time is ripe for a new overhaul.

This project aims to lay the foundations for exactly that. There are countless others attempting to do the same, but since all of them have failed so far and the prize is huge, it is worth trying.

## How To Go About It and How Not To?

Many people *feel* that *some* programming language would be the right foundation for computing instead of C. When considering a programming lanuguage for this ambitious task, quite a bit of reflection is warranted. If your language of choice has been around for a long time, since it has *failed to conquer the world* so far for so long,  **there *must* be something wrong with it**. It is hard to accept this obvious truth about our favorite programming language, but we should be honest about it, if we hope to succeed. If it has *not* been around for a long time, it will *very probably* fail for one of the many unknown and unknowable reasons inherent in not having stood the test of time. So the right approach -- in my view -- is to take a battle-tested language and *fix whatever might be wrong with it*. Also, there is nothing inherently wrong with taking ideas from other languages that are better in that particular regard, very much (and very probably) including C. Yet, we should abstain from cargo cult practices and imitate some feature hoping that it would help without understanding why.

## The Most Important Features

### Self-hosting

Everything depends on C, C depends on nothing. No programming task should be too menial for a foundational language.
It should be able to replicate itself onto bare hardware, old or new, with minimal effort and no outside help. If you get lazy here and relegate the basic stuff to C, you already lost. If you really-really want to avoid to have to rewrite some big piece of C code, compile it to your new foundations and use it from there. This is a very important part of how C conquered the world. While nobody wanted to rewrite stuff like `RANLIB` or `LINPACK` originally written in FORTRAN, instead of lazily interfacing with FORTRAN, these things are turned into C code with `f2c`. There is no need to write a C backend for the new foundations, but at some point (though not necessarily in the very beginning) it is important to write a C compiler to it, in it. Actually, the very remarkable and so far unsurpassed self-hosting capabilities of C can be of help here, greatly reducing the amount of code that needs to be written, but they should be used very carefully in order for the new foundations to eat C and not the other way around. At some point, we should be able to add the `c2s` tool that turns C code into something digestible for our seedling to our arsenal.

In particular, the new foundational language should be a cross-platform assembler no worse than C. It should be able to target absolutely every computing platform, old and new. It should also be able to self-host on the widest possible variety of architectures, including stuff with a transistor count that is ridiculously low by today's standards, for two reasons:
 * Anti-fragility against big civilizational shocks: If, for any reason, the availability of computing power drops radically from today's SciFi-surpassing levels of almost unimaginable abundance, it should *not* be a reason to abandon the seedling and go back to C. If we don't pass that test, C will be kept around as a very reasonable insurance policy and hinder the adoption of seedling even in the absence of big shocks.
  * Anti-fragility against architectural breaktrhoughs: One of the possible scenarios for the continued march of Moore's Law is massive parallelism blurring the boundaries between memory and processor gates, keeping the entire computer uniformly busy instead of compartmentalizing it into an incredibly hot CPU becoming a thermodynamic bottleneck and an almost entirely idle memory. In this scenario, the computer becomes a huge array of universal compute cells that can be freely allocated in appropriate quantities for computing tasks of any size. It is entirely possible and even likely that the transistor counts of individual cells will be very low. Seedling or its progeny should be the obvious choice for their programming.

As a bonus, this ability might allow us to conquer the world beyond silicon: if we look carefully, nature is full of arrangements that just *happen to be* Turing-complete, if only barely so. All it takes is to be able to express nand gates with sufficient freedom to connect them. It would be nice to harness them for our purposes by expressing our intentions in a familiar programming language. Some of these have inherently very low gate counts making people interested in programming them dabble on the lowest level and miss quite a few opportunities.

### Low Barrier to Entry

For network effects, we need masses. In the beginning, we cannot afford turning away people. What experienced programmers often forget is that most people that could benefit from being able to program are less capable of certain cognitive tasks than themselves. They also tend to forget that some things that are second nature to them are ridiculously difficult for beginners and might discourage the beginner from learning stuff even if they would be otherwise perfectly capable of mastering it.

The amount of unusual syntax needs to be minimized and simple things should be expressed by short and readable code without a deep knowledge of the language.
