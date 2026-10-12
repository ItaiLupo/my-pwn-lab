## Things to do

first I need to write a script that get the canary value for me using the time as the seed.  
second I need a script to gen the rop string and output it as base64  
then in the rop I need  
find a buffer I know the address of.  
call gets with this buffer addr.  
call system with this buffer addr.

or  
call system with a pointer to a string with the wanted value.

### Get the canary

see exploit/attack.py there isn't much to say on this.

### The ROP to call system

now that we know the canary we just need to overwrite the stack.  
first we construct our buffer and then we encode into base64 so it will expend the same way.  
we can write the return adder to system got.plt this will call system with static adder we know  
(it works becose system got called).  
we just need to put at the top of the stack of the call our /bin/sh and that works  
we also know the adder of the user input buffer sense it is global so we can put the /bin/sh  
on it and have the pointer point to where we put it.
