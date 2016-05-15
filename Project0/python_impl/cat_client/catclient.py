#!/usr/bin/python

import socket
import time
import sys

host='catserver'
port = int(sys.argv[2])
skt = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
skt.connect((host, port))

fd = open(sys.argv[1], 'r')
line = [s.lower() for s in fd.readlines()]
cnt = len(line)
#i = 0
if cnt == 0:
    print "Empty Input File."
    skt.close()
    quit()

start = time.time()

while time.time() - start < 30:
    skt.sendall('LINE\n')
    buff = skt.recv(1024)
    while buff[-1] != '\n':
        buff += skt.recv(1024)
    #print "Received: " + buff
    if buff.lower() in line:
        print "OK"
    else:
        print "MISIING"
    #i = (i+1) % cnt
    time.sleep(3)

skt.close()
