key 1 is 0x00008ce4 which is just the value of pc at this line.  
key 2 is 0x00008d0c we need to follow the bx into thumb mode and then take the pc and add 4.  
key 3 is 0x00008d80 which is the lr so the line after the call for key3

we can add them and get 108400
