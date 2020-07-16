# String Equality Example

This example showcases how languages operating on different levels of abstraction can be sufficiently similar to facilitate learning, interfacing and development.

## Seed

Seed is essentially a cross-platform assembler and few things of importance will be ever written directly in it. 
However, it specifies the program down to very fine detail, so it has a place in optimizations and expressing 
such detail where appropriate. Seed has no type information, it needs to be meta-programmed directly. It can be 
compiled into machine code (or digital circuitry) sequentially, word by word.

### Example 1: Raw, Uncommented Seed

This code looks quite unreadable, but we will help it in our next example.

```
addrSize natSize + const strSize

{
  local }[ strSize natSize + ]{ @
  ' =
  'fail| }[ strSize addrSize + ]{
  local }[ strSize strSize + ]{ $
  {
    bite
    local }[ strSize strSize + natSize + ]{ $
    bite
    local }[ natSize strSize + natSize + ]{ ~ @
  }
  {
    ' =
    'fail| }[ strSize strSize + natSize + strSize + ]{
    drop
    local }[ strSize strSize + natSize + strSize + ]{ let$
    ~ drop
  }
  ' while
  'fail| }[ strSize ]{
  ~ drip
} defFn $=
```
