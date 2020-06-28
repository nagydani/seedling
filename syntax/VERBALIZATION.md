# Verbalization

## Introduction

Human thinking and consciousness is greatly enhanced by verbalizing our 
thoughts. For those thinking in English while programming (a useful 
habit to get into), this document provides a guide to vocalize raw 
Seedling code.

It is important to note that Seedling is designed around the principle 
that code formatting and verbalization are deeply subjective. Users of 
Seedling typically do not read or write raw Seedling, but a representation 
thereof that is a matter of personal or team preferences. Different 
representations may come with different verbalizations. However, 
*developers* of Seedling might find it useful to be able to verbalize 
raw Seedling.

Because of the reverse polish notation, raw Seedling sounds a lot like [Yoda] 
from [Star Wars].

## Symbols

| Symbol | Pronounced | Meaning
| ---    | ---        | ---
| `{`    | brace      | beginning of a code literal
| `}`    | unbrace    | end of a code literal
| `"`    | quote      | beginning of a string literal
| `"`    | unquote    | end of a string literal
| `'`    | tick       | reference to executable code
| `~`    | tail       | continue with executing a function
| `\|`   | or        | conjunction executing term 1 then iff it fails, term 2
| `!`    | not        | success upon failure, failure upon success
| `+`    | plus       | sum of two values
| `-`    | minus      | difference of two values
| `=`    | equals     | two values equal
| `<`    | greater is | the second value is greater than the first
| `>`    | less is    | the second value is less than the first
| `,`    | comma      | append the second value to the first one

> Fun fact: it is fairly common that a block of code does something until it 
> fails and finally does something else. Such code in raw Seedling  ends 
> with `~ |` pronounced as *tail or*.

[Yoda]: https://starwars.fandom.com/wiki/Yoda
[Star Wars]: https://en.wikipedia.org/wiki/Star_Wars
