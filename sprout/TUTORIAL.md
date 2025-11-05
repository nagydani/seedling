# Sprout Tutorial

## Greetings

When learning a new programming language, it is 
customary to begin with making the computer greet the 
world. In Sprout, this looks as follows:

```
" Hello, world!" s. cr
```

If you enter the above line, you will see the following 
output:
```
Hello, world!
 ok
```

You can immediately notice three important characteristics 
of Sprout:

 * There is an extra space after the opening quote of the 
   string literal. This is due to the extremely simple 
   parsing rules of Sprout. We will talk more about them 
   later. In short, words in Sprout are separated by one 
   or more whitespace characters or newlines. And the 
   opening quotation mark is also just a word.

 * The word order is similar to how master Yoda from 
   Star Wars speaks: verbs typically follow the subject. 
   Or in programmer-speak: functions follow their arguments.

 * When it is done executing your commands, it responds 
   with ` ok`. The leading space is there to separate it 
   from outputs that do not end with a new line.

In the example above the word `s.` outputs its sole 
argument, while the word `cr` (short for "carriage return")
begins a new line.

However, this is not yet a program, just a command. To make 
it a program, enclose it in curly braces:

```
{ " Hello, world!" s. cr }
```

If you type this, seemingly nothing happens, but if you 
type `execute` now, the greeting appears.

We can also create new words using existing words. Let 
us give the name `greet` to our program:

```
{: greet " Hello, world!" s. cr }
```

From now on, we just need to say `greet` for the 
computer to greet the world.

## Arithmetics

Sprout uses reverse Polish notation (or RPN for short): 
numbers go on a stack, while operators take their 
arguments (typically one or two) from the top of the 
stack and place the result back on the top of the stack.

For example, if we want to calculate 3 * (10 + 5) / 9 we 
should write

```
3 10 5 + * 9 / .
```

The dot in the end just outputs the number at the top of 
the stack. There are plenty of tutorials on RPN 
calculations out there, so we won't spend more time on 
them.

## Control Structures

What if we want to repeat our greeting multiple times? 
Well, the original Sprout vocabulary does not contain anything 
that would do this, but we can create our own word `times`:

```
{: times ( x n -- )
{ 0<> 1- >r dup >r execute r> r> }~self
{ drop }~ drop }~|
```

Before we figure out what all this gibberish means, 
let's try it out:

```
{ greet } 3 times
```

It should produce the following output:

```
Hello, world!
Hello, world!
Hello, world!
```

The word `greet` is enclosed in curly braces to turn
it into a quoted computation. There is also a shorthand
for quoting single word computations, namely the tick
mark `'`. Try this:

```
' greet 3 times
```

The output is the same, but there is a slight difference 
under the hood: in the latter case the computer does not 
need to create and store a new anonymous program (a so 
called *quotation*), it merely refers to the program 
already stored under the word `greet`.

Now, let us delve into the internals of `times`!

The stuff in round parentheses is just a comment. It can 
be omitted as Sprout ignores it. In this case, it tells 
the reader that `times` takes two arguments -- an 
executable computation and a natural number -- and 
leaves nothing on the stack. *Note that this so-called 
type signature will be formalized in the future and will 
be somewhat different.*

The next unit is a quotation: `{ 0<> 1- >r dup >r 
execute r> r> }~self`. Note that it is closed not by a 
closing brace, but by the word `}~self` meaning that the 
last step of the computation is to start over. As a 
general note, we can instruct the computer to follow up 
a computation with another -- named -- computation by 
using the `}~` word (pronounced "*tail*") followed by the 
name of the computation. As an exercise, you can try to 
guess what the `greeet` word defined as follows does, 
without trying it out: `{: greeet " Hello world!" s. 
cr }~ greeet`. How could you express it differently?

Then comes another quotation: `{ drop }~ drop` the word 
`drop` removes the topmost element of the stack. By now, 
you should be able to figure out that this quotation 
just `drop`s two elements. It could have been written as 
`{ drop drop }`, but using tails is more efficient.

Finally, the definition of `times` ends with the word 
`}~|`, which is just two words contracted into one, 
because they are used so often together: `}~ |`. Now, 
you already know `}~`, `|` pronounced "*or*" and called 
"*disjunction*" will be discussed a bit later. For now, 
it is sufficient to say that it takes two computations, 
which are given as quotations in this example.

Now let us look inside the first quotation. It begins 
with the word `0<>`, which is synonymous to `0 <>`, but 
it is used so frequently, that it is worth having in a 
single word. It checks whether the number on the top of 
the stack equals zero. If not, the computation continues. 
If, however, it does equal zero, the computation 
*fails*. Failure is a very important concept in Sprout, we 
shall discuss it in more detail.

But for now, assume that the number was not equal to 
zero. The next word is `1-` (again, synonymous with `1 
-`), which decrements it by one. Then comes `>r`, which 
takes an element off the top of the stack and places it 
on the top of another stack, called *return stack* 
(hence the `r`). In this example, we just use it to move 
things out of the way. Next comes `dup` which 
*dup*licates the topmost element on the stack (which is 
a reference to the computation in this case). The copy 
is immediately moved over to the return stack by the 
following `>r`. What remains on the stack is the 
executable computation, which we immediately `execute`. 
Finally, we move the two arguments back from the return 
stack to our normal stack (called *data stack*) and 
start over. So, it goes 'round and 'round decrementing 
the number and executing the computation until the 
number reaches 0.

Now, it is time to explain disjunction. Its two 
arguments are called *predicate* and *subject*. It first 
executes the predicate. If it *succeeds* (which cannot 
happen in our case, as it loops back on itself), then 
that is the end of it, the disjunction succeeds. If, 
however, it fails, then the subject is executed. The 
disjunction itself succeeds if either of its arguments 
succeeds, either the predicate *or* the subject. If 
both fail, the disjunction fails.

In our case, the predicate never succeeds, but 
necessarily fails, when the counter reaches zero. At 
this point, the subject of the disjunction is executed, 
which drops the two arguments of `times` from the stack 
and succeeds.

The more astute reader might have noticed that there is 
another way for the predicate to fail: if the execution 
of the argument of `times` fails. In this case, the 
presented version of `times` does something completely 
wrong. In a later lesson, we are going to fix it to do 
the correct thing and let the entire disjunction fail. 
This simple version of repetition works only with 
computations that never fail and it never fails itself.

The following word implements the so called `while` 
combinator. Similarly to disjunction, it takes two 
executable arguments, a predicate and a subject. 
However, it works differently: It executes the subject, 
if the predicate succeeds and if the subject also 
succeeds, it starts over. If the predicate fails, the 
combinator succeeds. If the subject fails, the 
combinator fails. In other words, it keeps executing the 
subject *while* the predicate succeeds.

```
{: while ( x x -( fail )- )
>r dup >r
{ r>drop r>drop r>drop } |
r> r> swap >r dup >r execute r> r> swap }~self
```

As an exercise, you can work out how this word actually 
works. The type signature tells the reader that this 
word takes two executable arguments and may fail. The 
word `r>drop` just drops the topmost element of the 
return stack. It is synonymous with `r> drop`, but does 
not bother with moving data to the data stack only to be 
discarded from there, so it is more efficient.

To see how it can be used, look at the below example 
that outputs the beginning of a string up to the first 
blank:

```
{: s.word ( a -( emit )- )
{ ( a -( fail )- a c ) nonempty dup c@ bl }~ <>
{ ( a c -( emit)- a ) emit }~ 1+
}~ while
```

The type signature tells us that this word takes one 
argument (a reference to a string, in this case) and has 
the side effect of `emit`ting stuff to the output. I 
also added type signatures to the predicate and subject 
quotations. The predicate takes a string reference, can 
fail and returns a string reference and a character. The 
subject takes a string reference and a character, can 
`emit` as a side effect and returns a string reference.

The word `nonempty` fails, if the argument references an 
empty string. The word `c@` takes a string reference and 
returns the first character of the string. The word `bl` 
takes no arguments and returns a blank character. The 
word `<>` takes two arguments and fails, if the two are 
equal. If not, it succeeds with returning the first 
argument. Thus, the subject fails on empty strings and 
on strings starting with a blank. If it succeeds, it 
passes the original string and its first character as 
an argument to the subject.

The subject `emit`s the character and increments the 
string reference. Note how the subject and the predicate 
pass arguments around in the data stack: each expects as 
arguments what the other leaves on the top of the stack.

## Generators, Filters, Mappers

A common task in programming is to iterate through a 
number of objects and process them one by one. Sprout uses 
*generators* for this purpose. A generator word, by 
convention ending with the `&` symbol, either leaves 
the next object on the stack or, if there are no more 
objects, it fails. When what follows the generator 
fails, the generator generates the next object (or fails 
itself).

Let us explore the following very simple generator that 
generates each successive character from a string:

```
{: scan& ( a -( & )- c )
nonempty { 1+ }~ scan& & dup }~ c@
```

Without going into how it works under the hood, let us see 
what it does and how to use it:

```
{: mys. ( a -( emit )- )
{ scan& emit }~fail
'id}~|
```

This example is just an alternative implementation of 
`s.`, using `scan&`. The closing word `'id}~|` is 
synonymous with `'id }~|`, where `'id` is a reference to 
an empty computation (the so-called *identity*, hence 
the name). We use disjunction with identity to turn the 
failure of the generator into a success of our computation.

Let us modify it to emit only capital letters from the 
argument string:

```
{: s.caps ( a -( emit )- )
{ scan& upper emit }~fail
'id}~|
```

Thus,

```
" THE quick brown FOX jumps over THE lazy DOG." s.caps
```

would output `THEFOXTHEDOG`. The word `upper` is a 
so-called *filter* that leaves alone upper-case letters 
and fails on everything else. By the way, `0<>` from 
earlier examples is also a filter and so is `nonempty`. 
In general, anything that either succeeds with arguments 
passed on unchanged or fails is a filter.

Another thing we might want to do is substituting each 
element with something else. For instance, we might want 
to change all letters to upper case:

```
{: shout ( a -( emit )- )
{ scan& >upper emit }~fail
'id}~|
```

As expected, the *mapper* `>upper` (pronounced 
"*toupper*") changes lower case letter to upper case and 
leaves everything else alone unchanged. Try:

```
" Hello, world!" shout
```

It should output `HELLO, WORLD!`. In general, mappers 
are computations that take one argument from the stack 
and leave one value on the stack that is purely a function 
of the argument. Mappers always succeed.

Let us now construct our own filter, using a generator 
and a mapper! Suppose, we want to filter for vowels. We 
need a word that leaves vowels unchanged and fails on 
everything else. The easiest way to do so is to generate 
all vowels and check the argument against them:

```
{: vowel ( c -( fail )- c )
" AEIOU" scan& third >upper = cut drop }~ drop
```

Here we find a few novelties. The word `third` copies 
the third element from the top of the stack onto the top 
of the stack. In this example, it brings up the argument 
of the function. After mapping it to upper case, we 
check whether it equals the letter just generated. If 
it doesn't, we generate the next one and check again. If 
the generator runs its course, the whole computation 
fails, which is exactly what we want, if the capitalized 
version of our argument is not among the capital vowels. 

But what if it is, and `=` succeeds? The next word, 
`cut` "turns off" the current generator, so that we do 
not search any further; subsequent failures are no 
longer caught by it. The two elements on the stack above 
the argument (the rest of the generated string and the 
current letter generated from it) are dropped so that only 
the filter's argument remains.

Now, let's try it:

```
{: s.vowels ( a -( emit )- )
{ scan& vowel emit }~fail
'id}~|

" THE quick brown FOX jumps over THE lazy DOG." s.vowels
```

The output, as expected, is `EuioOuoeEaO`. What if we 
want to filter for either vowels or whitespace? We just 
use disjunction with a filter that filters for 
whitespace (`ws`):

```
{: s.vowelwords ( a -( emit )- )
{ scan& ' vowel ' ws | emit }~fail
'id}~|

" THE quick brown FOX jumps over THE lazy DOG." s.vowelwords
```

The output is `E ui o O u oe E a O`. In general, if we 
want to combine filters to create a new filter that lets 
through what either lets through, we use disjunction. To 
combine filters so that only what passes both passes, we 
just put them after one another (for efficiency, use the 
one that is less likely to succeed first). In Sprout, 
function composition is this simple.

Now that we have seen how to use our `scan&` generator, we 
can actually look into how it works in order to be able to 
write our own generators.

The first word is `nonempty`: scanning an empty string 
results in a failure immediately. Then comes a quotation 
that increments the string reference and tail-calls 
`scan&`. The next word is `&` (pronounced "*pend*"), 
which registers the provided quotation as the failure 
handler. `dup` and `c@` put the first character of the 
string on the stack without consuming the string 
pointer, which is the state of our generator. So, when a 
failure occurs down the line, the registered quotation 
kicks in, takes a step in the string and restarts the 
generator, again registering itself as the error handler.

Here is another simple generator, generating numbers 
from *n*-1 to 0, given the number *n* on the top of the 
stack:

```
{: countdown& ( n -( & )- n )
0<> 1- 'self & }~ dup
```

