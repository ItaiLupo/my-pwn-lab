## Exploiting the gets

we can see that after gets if it fails it return very soon after, it does call atoi and puts and then return.  
atoi get our buffer so as long as it starts with 0 we should be fine and pass atoi.

our buffer is of size 100 and looking in ghidra is at offset 0x78,  
ghidra added EBP for us so we need to write 120 bytes of garbage where the first char needs to be a number.  
now we need to find where to jump to.  
we can jump to the line that calls open or to functions A to G and back to this functions,  
I want to try doing a chain even if it is harder so we will try to call A to first G.

we can run objdump -t with grep```

```c
08041333 g F .text	00000032 D  
080412cf g F .text	00000032 B  
08041397 g F .text	00000032 F  
08041365 g F .text	00000032 E  
08041301 g F .text	00000032 C  
080413c9 g F .text	00000032 G  
0804129d g F .text	00000032 A  
0804150b g F .text	0000018d ropme
```

so are chain will be this A to G and then back to ropme

now we just need to have a script that send the exploit then sum everything up,  
and then send the sum back and gets the flag.
