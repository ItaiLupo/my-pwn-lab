## overview
we have a 32 bit elf and that we need to get the flag by exploiting,
we don't have any source code so disasm is the main option.

### elf overview
from main we have 2 functions we care about init_ABCDEFG and ropme the reset is just the ctf setup.
the init function put what seem to be a strong random in 'a' to 'g' vars and then put there sum in sum
all 7 of them have the same formula 
var = strong_random * -0x21524111 +
      (uint)(0xcafebabd < (uint)(temp_random * -0x21524111)) * 0x35014542;
      
where strong random is rand with a seed that /dev/urandom gave.

ropme asks for 2 user inputs one with scanf and one with gets
the second one needs to be equal to sum from earlier to get the flag

to get 'a' to 'g' we need to call the functions with the same name but capital.
but we can on paper call only one at a time and to call it we already need to know that value it prints.

so a solution will be something that call A to G from the first input or  just jumps to the open of flag.
the first scanf is %d  