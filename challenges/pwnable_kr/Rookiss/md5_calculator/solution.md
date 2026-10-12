first we can use math to get the stack canary from the printed captch.  
then we can use the buffer overflow from the base64 decoder to overwrite the stack.  
we can use it to overwrite the return adder to the adder of system got.plt.  
this will call system and we can put /bin/sh on the original base64 buffer some where sense we know it's base adder.  
then we put the adder of that at the top when calling system and we get a shell.
