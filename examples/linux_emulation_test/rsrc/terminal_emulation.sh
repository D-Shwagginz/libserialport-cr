sudo apt install socat

#create the two linked pseudoterminals
socat -d -d pty,raw,echo=0 pty,raw,echo=0 &