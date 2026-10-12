## Overview

this program print a number and asks for it back  
then it asks for a BASE64 data and md5 sum it?  
then it uses system to write date into file log? which fails

## Elf overview

### Main overview

first it uses scanf to get an int and check that the int is the same as a random int it printed.  
it gets the random int using time() output as the seed for srand,  
and then calls my_hash which returns the seed. 

then it prints some stuff with puts or exit if the captca was wrong  
then it calls  
process_hash

### my_hash Overview

this function gets 8 random numbers and returns that:  

```c
return random_numbers[5] + random_numbers[1] + (random_numbers[2] - random_numbers[3]) +
         random_numbers[8] + random_numbers[7] + (random_numbers[4] - random_numbers[6]);
```

if you know the srand seed which is the exact time you would be able to get the stack canary? what?  
how did they even use the stack canary in return value(probably uses random_char\[8] and it got the canary on the overflow)?

note time is only a full second accurate so it is possible to get

```c
int result = function_return_value;
int canary = result - random_numbers[5] 
                    - random_numbers[1] 
                    - random_numbers[2] 
                    + random_numbers[3] 
                    - random_numbers[7] 
                    - random_numbers[4] 
                    + random_numbers[6];
```

so by getting the first 8 numbers out of rand and throwing the first we can get the value of the canary

### process_hash Overview

first the inputs  
it getchar in a while the input char isn't 10 so it wait for a new line I guess after the scanf?

then it fgets to a buffer up to 0x400

the function wait for new line and fgets.

then it decode the input as base64 and calc and prints it's md5 sum.  
note the output buffer of the base 64 is 128 int32 or 512,  
while from 1024 bytes of base64 is larger then that and is 768  
if we input such string we will get a stack overflow at some point

## Win condition

get the value of the canary for that run.  
use that value to overflow the stack and create a rop that calls system with custom string

## Important addresses

0x08049187 main calls to system here  
0x0804b0e0 the addr of the input buffer of the user inputted BASE64 value
