# Algebraic Effects

All functions in Seedling can declare *effects*. Functions with no effect are 
said to be *pure*. The effects of a function are a mathematical *set*. 
The effects of a composite function must be a *superset of the union* of its 
consituent functions, minus the effects *handled* by the function. Effects with 
an empty handler are said to be *ignored*. Syntactically, effect sets are 
represented as a *tuple*, with each effect in the set included once, in 
arbitrary order, excluding *implied* ones (details below).

Effects are generic functions and they can be called just like regular 
functions, with the same syntax. Calling the effect will result in executing 
its *handler* function. Effects called within a function *must* be declared 
as the function's effects, however, it is not mandatory to call all declared 
effects.

Just like functions, effects can also have declared effects. These effects 
are  said to be *implied*. Listing the effect in the tuple representing the 
effect set, implied effects also become part of the effect set. However, 
the handlers of implied effects will only be called if the handler of the 
effect (or any other function) explicitly calls them. Handling is *not 
implied*. The effect itself is, obviously, also implied and does not 
need to be declared.

# Failures

The most fundamental effect is `fail`. It is somewhat special, because it is 
very deeply woven into the runtime. Unlike other effects, `fail` cannot be 
*completely* ignored. If its hander is empty, it still sets the *failed 
state*. All Seedling-based languages, beginning with Seed must implement this 
effect.

## Failed State

This is the most lightweight handling of failures, it cannot be turned off.
Literals do not change the failed state. Functions except `ifso` and 
`otherwise` (as well as those composed of them) are allowed to have undefined 
behavior in the failed state, as normally failures are expected to be handled.

The only argument of `ifso` is a *quotation*. It is *called in success state* 
and *dropped in failed state*, preserving the failed state.

The only argument of `otherwise` is a *quotation*. It is *called in the 
failed state* simultaneously resetting success state and *dropped in success 
state*.

This is very low-level behavior useful for implementing higher-level 
functionality. Most users of Seedling-based languages will never have to 
deal with it. However, these are the architecture-dependent primitives that 
need to be implemented by those porting Seed to a new architecture.

## Handling Failures

Registering a low-level handler for `fail` is done by `dodge`, which has a 
single argument, a quotation for dodging the failure. The quotation is called 
upon failure, but it begins execution in success state. If the quotation 
returns, execution of the failed function continues in the failed state.

Unregistering the handler and thereby restoring the previous handler for 
`fail` is done by `undodge`. If the default handler setting the failed state 
is reached, attempts to `undodge` fail.

Within the low-level handler, reclaiming the stack frame to where `dodge` was 
called can be accomplished by calling `bag` (as in "holding the bag"), 
effectively turning a failure into an *exception*, which it normally should be.

Again, this is low-level behavior with which primarily porters of Seed need to 
concern themselves, implementing `dodge`, `undodge` and `bag` as low-level 
primitives.

The standard way of handling failures is the following:

`try` with two quotation arguments with only the first one having `fail` among 
its effects. Both must have identical input types and identical output types. 
The first one is called and upon failure the second one is also called.

The following two functions are also handling failures, but unlike `try` they 
can `fail` themselves.

`and` with two quotation arguments, both of which have `fail` among their effects.
Both must have the same input and output types (i.e. the four type tuples must 
all be identical). The first quotation is called and upon success the second one 
is also called. It fails, if the first one fails or if the first one succeeds and 
the second one fails.

`or` with two quotation arguments, both of which have `fail` among their effects.
Both must have the same input and output types (i.e. the four type tuples must 
all be identical). The first quotation is called and upon failure the second one 
is also called. It fails, if both fail.

# Exceptions

Exceptions are special effects that can only be called at the end of a quotation, 
through what is effectively a tail call. *To be continued ...*
