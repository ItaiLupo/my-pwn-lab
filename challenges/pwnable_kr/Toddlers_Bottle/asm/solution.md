## What to run to get flag

make upload  
and on the machine  
(cat /tmp/shell_random_number.bin; cat) | nc 0 10015

## Explian

it's a very simple shell code that just need to open a file with a long name and print it's contents.  
we make sure to put the string of the name in the .text section and compile with nostd and standalone and do fpic to make all the code use only relative addresses.  
do the objdump to get the text section with the code out and it works.

## Note

there is a simple local runner and a file with the same name for quilty of life testing  
make test  
will run and compile it printing aaa instead of the real key
