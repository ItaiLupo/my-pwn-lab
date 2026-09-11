
this bash command work  
python3 -c '  
import socket, time  
time.sleep(0.5)  
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  
s.connect(("127.0.0.1", 9999))  
s.sendall(b"\xde\xad\xbe\xef")  
s.close()  
' &(cat /tmp/in0; cat) | env $'\xde\xad\xbe\xef'=$'\xca\xfe\xba\xbe' /home/input2/input2 {1.} $'\x00' $'\x20\x0a\x0d' 9999 {68.} 2< /tmp/in2

note you need to write the correct magic values to in0 and in1 head of time. and in the file \x0a in you cwd  
note you need to symlink the flag to you correct working directory sense in the ssh you can't create files in the home folder only in tmp when using the ssh.
