( ) ( "EOF" "read.ERR" ) ( "C" ) "read" effect

( "C" ) { dup 32 le } ( ) ( "C" "?" ) "whitespace?" fn

"syntax" fail

( "C" ) {
  whitespace not { syntax } and drop
} ( "syntax" ) ( "C" ) "whitespace" fn

( "C" ) {
  whitespace { syntax } and drop
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
