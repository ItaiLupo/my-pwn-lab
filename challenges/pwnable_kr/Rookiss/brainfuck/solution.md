we needed to use < to change p to the got and override the entrys for:  
putchar into main  
memset into gets  
fgets into system

for that we needed to get the libc version/offsets by printing some got offsets.  
and on the live run print a libc got entry that was populated to get the aslr.

tecnicaly we could have done one script with one connection but it was easier to debug and run that way.

see the exploit/ for the scripts.  
see notes/ for more details
