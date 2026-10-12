## Using the name buffer overflow.

when the program asks for a name it asks for 24 bytes for a 24 byte buffer.  
so we can have it not have a null byte at the end.  
this will print into o\[3] which is the address of the function greetings.  
it will print the lower half of it which is c007400a the rest should be 0  
we could have just gotten it from ghidra,  
but this tells has the elf has PIE disabled and some and the .text  
loads into a static address with no aslr

if we could get the addresses of 2 libc calls we can use them,  
to get the libc base and the offset of system!

## Printing the stack

we can use the printf and %i$p to print the full stack until the program crash in a loop

### The stack

Slot 10: b'0x7ffd2ed2c060'  
Slot 14: b'0x4141414141414141'  
Slot 15: b'0x4141414141414141'  
Slot 16: b'0x4141414141414141'  
Slot 19: b'0x7097e7c14d90'  

we can see quite a call to libc like in the return addr of main to \_\_start  
we dont have any more clear calls so we can use the version of libc that elf uses.  
we can get use that to get the addr of libc start and from that libc base and system.

we can also see our original name buffer before it was copied to global var.  
and we can see slot 10 whice is a pointer to start of main stack frame.

### Using the double free.

#### Calling system

now that we know how to get the live addr of system we need to get call it.  
if use 4 exit but don't exit it frees the buffer with the function pointers.  
then in 3 it call malloc right after calling free on a buffer of the same intrnal size.  
this gives as the same pointer that is used for the function pointer in the form of o3(o)  
but now we can overwrite o3.  
so we can write /bin/sh and system.  
system is called but not with /bin/sh!  
free is called before it and overwrite the first byte with data...  
so we can't use system like that.

but we also don't get any other call we can change.

#### Calling a shell script.

but we do know a buffer on stack we can control and the stack is exactuble.  
so we can write a shell script on the name buffer at the start.  
that shell script needs to have the /bin/sh string and call the syscall execve with it.

so we can write it at the start.  
then we get the stack adder of main and do -0x20 to get the adder of that buffer.  
then we override the function adder with it.
