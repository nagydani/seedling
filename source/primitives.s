(
\ integer type
)
"I" type

(
\ unsigned integer type
)
"N" type

(
\ character type
)
"C" type

(
\ boolean type
)
"?" type

(
\ integer type
)
"I" type

(
\ address type
)
"A" type

( I ) {
\ drop an integer from the stack
} ( ) ( ) "drop" fn

( N ) {
\ drop an unsigned integer from the stack
} ( ) ( ) "drop" fn

( C ) {
\ drop a character from the stack
} ( ) ( ) "drop" fn

( ? ) {
\ drop a boolean from the stack
} ( ) ( ) "drop" fn

( A ) {
\ drop an address from the stack
} ( ) ( ) "dropA" fn

( T ) {
\ drop a tuple from the stack
} ( ) ( ) "dropT" fn

( I ) {
\ duplicate an integer on the stack
} ( I I ) "dup" fn

( N ) {
\ duplicate an unsigned integer on the stack
} ( N N ) "dup" fn

( C ) {
\ duplicate a character on the stack
} ( C C ) "dup" fn

( ? ) {
\ duplicate a boolean on the stack
} ( ? ? ) "dup" fn
