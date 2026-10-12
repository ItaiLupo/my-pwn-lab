see exploit/attack.py for the python scripts and notes/ for more info.

we can use option 2 to input a buffer that will go straight to printf.  
with this buffer we can print the active adder of main stack frame.  
on the frame there is buffer we can at the start put s shell code that goes into exec.  
then we can use option 4 to exit but say n, this will free a buffer that has function pointer that are still in use.  
then using option 3 we can use malloc to get that buffer back.  
on that buffer we write the addr to our shell code.  
then it will be call next time we use 2 or 3 and we can print the flag.
