# Principles

## Preliminaries

Seedling-based programming languages (additionally defined ones: Seed and Sprout) 
are derived from Seedling by extensions and restrictions. It is sufficiently 
flexible for defining futher programming and markup languages on its basis in a 
similar fashion. This is one of its main objectives.

Seedling source can be interpreted left to right, buffering at most one **word**. 
A word is a sequence of printable symbols with explicit whitespace or end-of-line 
delimiters on both sides. Source containing characters *different* from printable 
ones in 7-bit ASCII is *not* considered **fully portable**. Source containing 
characters *different* from printable ones in 7-bit ASCII outside of string 
literals is *not* considered **partially portable**. Source containing words longer 
than 64 characters is *not* considered **partially portable**. The amount of 
whitespace (if greater than zero) outside of string literals is inconsequential.

Seedling source is a sequence of **literals** and **operators**.

## Literals

### Numeric Literals

### String Literals

### Quotation Literals

### Tuple Literals

## Operators

### Postfix Operators
