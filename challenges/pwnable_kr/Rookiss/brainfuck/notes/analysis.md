## Overview

we have a brain fuck interpreter with no \[ \]  
so we can print and do basic math  
we also only have the elf,  
we need to get a shell or the flag some how.

## Elf overview

first thing of note in main we use fgets to get a 1024 input buffer from stdin but it is a safe fgets.
then it loops over the buffer and call a function named do_brainfuck for each char.

in do_brainfuck  
most of it looks fine but the operation < and > work on the pointer p unbonded, what is p?  
0804a080 l O .bss	00000004 p  
0804a0a0 l O .bss	00000400 tape

it it s byte pointer,
and it doesn't seem to have any thing limiting writing before or after it

in main we can see  
p = tape;

so p starts at tape.  
so by doing < 32 times we will overwrite p.  

so we can change any one of the bytes of p which is 0x0804a0a0 at the start,  
but will be 0804a080 to 0804a084 when we change it.

after we change it we can still add or remove to it but within the 1024 input buffer size.  

let's check over address of interest.  

0x080484f7 is main function start addr.
0x080485dc is so do_brainfuck start addr.

fget got entry is 0x0804A010
puts got entry is  0x0804A018
putchar got entry is  0x0804A030
getchar got entry is 0x0804A00C
memset got entry is 0x0804A02C

all libc functions which are used by main/do_brainfuck,
and we can mostly control when they are called.



.text is mapped as non writeable.
the got is writeable and we can get to it.

so again by changing the second byte to 84 we are at the got,

but how do we set what we pass to it?  
we need to print out the address of the live libc functions,
and get the libc version and offsets so we can later overide the address with the correct adress.

also we need to find system so we should find the offset from there we can get the address of system and use getchar to override it to?  

we can use pwntools for the address finding we just need to get the addr of puts and of \_\_libc_start_main_addr or something

## win condtion
print a few of the got entry of the libc functions and use them to get the libc version and the libc offset of the function we need.
on the attack, find the aslr and use it to get the live addr of the functions we need.
find a way to get system to be called with /bin/sh or cat flag.
