# Seed Tutorial

## Greetings

When learning a new programming language, it is 
customary to begin with making the computer greet the 
world. In Seed, this looks as follows:

```
" Hello, world!" type cr
```

If you enter the above line, you will see the following 
output:
```
Hello, world!
 ok
```

You can immediately notice three important characteristics 
of Seed:

 * There is a space between the opening quote of the 
   string literal. This is due to the extremely simple 
   parsing rules of Seed. We will talk more about them 
   later. In short, words in Seed are separated by one 
   or more whitespace characters or newlines. And the 
   opening quotation mark is also just a word.

 * The word order is similar to how master Yoda from 
   Star Wars speaks: verbs typically follow the subject. 
   Or in programmer-speak: functions follow their arguments.

 * When it is done executing your commands, it responds 
   with ` ok`. The leading space is there to separate it 
   from outputs that do not end with a new line.

In the example above the word `type` outputs its sole 
argument, while the word `cr` (short for "carriage return")
begins a new line.

However, this is not yet a program, just a command. To make 
it a program, enclose it in curly braces:

```
{ " Hello, world!" type cr }
```

If you type this, seemingly nothing happens, but if you 
type `execute` now, the greeting appears.

We can also create new words using existing words. Let 
us give the name `greet` to our program:

```
{: greet " Hello, world!" type cr }
```

From now on, we just need to say `greet` for the 
computer to greet the world.

## Arithmetics

Seed uses reverse Polish notation (or RPN for short): 
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
Well, the original Seed vocabulary does not contain anything 
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

The word `greet` is enclosed in curly braces, because it 
makes it a computation. In fact, there is an alternative 
way to refer to computations corresponding to single 
words, the tick mark `'`. Try this:

```
' greet 3 times
```

It does the same. The difference is that in the latter 
case the computer does not need to create and store a new 
program (called "quotation"), it merely refers to the 
computation represented by the word `greet`.

Now, let us delve into the internals of `times`!

The stuff in round parentheses is just a comment. It can 
be omitted as Seed ignores it. In this case, it tells 
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
without trying it out: `{: greeet " Hello world!" type 
cr }~ greeet`. How could you express it differently?

Then comes another quotation: `{ drop }~ drop` the word 
`drop` removes the topmost element of the stack. By now, 
you should be able to figure out that this quotation 
just `drop`s two elements. It could have been written as 
`{ drop drop }`, but using tails is more efficient.

Finally, the definition of `times` ends with the word 
`}~|`, which is, again, just two words contracted into 
one, because they are used so often together: `}~ |`. 
Now, you already know `}~`, `|` pronounced "*or*" and 
called "*disjunction*" will be discussed a bit later. 
For now, it is sufficient to say that it takes two 
computations, which are given as quotations in this 
example.

Now let us look inside the first quotation. It begins with the 
word `0<>`, which is synonymous to `0 <>`, but it is used 
so frequently, that it is worth having in a single word. 
It checks whether the number on the top of the stack 
equals zero. If no, the computation continues. If, however,
it does equal zero, the computation *fails*. Failure is 
a very important concept in Seed, we shall discuss it in 
more detail.

But for now, assume that the number was not equal to 
zero. The next word is `1-` (again, synonymous with `1 
-`), which decrements it by one. Then comes `>r`, which 
takes an element off the top of the stack and places it 
on the top of another stack, called *return stack* 
(hence the `r`). In this example, we just use it to move 
things out of the way. Next comes `dup` which *dup*licates 
the topmost element on the stack. The copy is immediately 
moved over to the return stack by the following `>r`. What 
remains on the stack is the executable computation, which 
we immediately `execute`. Finally, we move the two arguments 
back from the return stack to our normal stack (called 
*data stack*) and start over. So, it goes 'round and 'round 
decrementing the number and executing the computation 
until the number reaches 0.

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
