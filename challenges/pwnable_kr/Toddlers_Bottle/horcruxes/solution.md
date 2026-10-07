using gets we can overflow the buffer and by writing 120 bytes we can start a rop.  
in the rop we can call all the functions that prints the part of the sum,  
and go back to the same function.  
then we give the sum back and get the key.  
see ./exploit/expolit.py for the script and [[challenges/pwnable_kr/Toddlers_Bottle/horcruxes/notes/scratchpad|scratchpad]] for the full solve details
