## get the libc offsets
we can move the p to got entry of some the libc functions and print them.
we just need to use < then cange the correct byte of to make it point to got and then use . to print the addreses.
then useing pwntools and saveing into a pickle file, see exploit/leak_got_addr_offsets.py

## getting the attack to work.
### overideing 1 function with system.
so I tryied to get put char to work,
as it seemd like when calling it the stack might have p on the top.
then it whould have passed it as the parm 
and then we can just have p point to the string we constsract 
with the right values but the stack wasn't the way I needed it for that to work.

### returning to main
but I could override it into main and then I can use more functions,
in this case I could use memset and fgets,
memset recive 3 parms and the first is an empty buffer on the stack,
we can change it to a call to gets and now gets will put the user input into this buffer.
fgets get 3 parms the first is the buffer we just wrote to so it can be system, and this will be a win.

when jumping to the start of main it crashes but if jump right before the first puts call it works.
in order to overide the libc functions once we first need to get the corrent aslr,
by printing some got addr that got called alrady(so it will point to the libc and not the plt)
then we can use are offsets from before to get libc base and then the real addreses of system and gets.
then we just use the , to write to them.
see exploit/attack.py for the working script.
