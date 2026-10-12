## Overview

this program ask for a name  
then it asks for an echo mode there are 4 options
- 1. : BOF echo
- 2. : FSB echo
- 3. : UAF echo
- 4. : exit  
1 is not supported

2 and 3 print back you name ask for input and print it back. 

and 4 ask for confirm and exits.

0 gives a core dump

## Elf overview

### Main

there are 2 global array of function pointers that get init at the start.  
one is of size 0x28 or size_t\[5] and has it 3 and 4 spots with functions and called o.  
the other is size size_t\[3] and has the 3 echo types functions and called func.

next it asks for a string of len 24 and put it in a char\[24] array.

then it asks for a menu and put it in uint.  
if the menu is less then 3.  
it uses it to call from the first array but it first remove 1 from it.  
so when calling it will **-1** to 2.  
-1 points to dtor_idx.6533 so some sort of distractor which is 0 at the start.

it also takes the first 4 bytes of the input name and put them in a global called id.

it takes the user input and put it at the start of o  
of seem like some sort of global context

### Echo1-3

echo1 just prints not supported and returns.

echo 2  
calls o 3 with o is the input  
then call get_input with a size 32 buffer  
then print that buffer  
then calls o 4 with o again.

echo 3 does the same thing but instead of stack buffer it is a heap buffer.

get_input is just call to fgets on std in

o3 and o4 just printf what they are given with a header.

so if our input is exactly the size of the buffer it will print the adder of 3 and o4 until the first null byte.

### Imprtant notes,

echo 2 uses printf with the user buffer.  
echo 3 uses malloc.  
exit free o buffer before it ask for confirem,  
so it might be used after it is freed.

checksec --file=bin/echo2

Stack: No canary found  
NX: NX unknown - GNU_STACK missing  
PIE: No PIE (0x400000)  
Stack: Executable  
RWX: Has RWX segments  
Stripped: No

it has no PIE and the stack is executable

### Win condition

find the live addr of system with printf of echo 2.  
use exit to free o  
use echo 3 to get the pointer of o from malloc  
write /bin/sh to the start of and then the addr of system to o 4.  
this will make the final call of echo 3 which o4(o)  
be system("/bin/sh")
