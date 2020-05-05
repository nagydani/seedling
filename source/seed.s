( "T" "T" "T" "S" ) ( "heap" "object" ) ( ) "effect" effect

( "T" "Q" "T" "T" "S" ) ( "heap" "object" ) ( ) "fn" effect

( "T" "T" "S" ) {
\ No type tracking in Seed
  dropS dropT dropT
} ( ) ( ) "cast" fn

( ) ( "EOF" "read.ERR" ) ( "C" ) "read" effect

( "C" ) ( "I" ) "castI" cast

( "C" ) { dup castI 32 le } ( ) ( "C" "?" ) "whitespace?" fn

"syntax" fail

( "C" ) {
  whitespace? not { syntax } and drop
} ( "syntax" ) ( "C" ) "whitespace" fn

( "C" ) {
  whitespace? { syntax } and drop
} ( "syntax" ) ( "C" ) "printable" fn

( "A" "N" ) ( "S" ) "castS" cast

( ) { here 0 castS } ( ) ( "S" ) "emptyS" fn

( ) {
  emptyS
  {
    read whitespace drop
  } "syntax" until
  {
    read printable appendC
  } "syntax" until
  castS
} ( "EOF" "read.ERR" "heap" ) ( "S" ) "word" fn
