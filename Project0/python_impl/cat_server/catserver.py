#!/usr/bin/python

import socket
import sys

host = ''
port = int(sys.argv[2])
numclients = 1

skt = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
skt.bind((host, port))
skt.listen(numclients)
con, addr = skt.accept()

fd = open(sys.argv[1], 'r')
line = fd.readlines()
cnt = len(line)
i = 0
if cnt == 0:
    print "Empty Input File."
    con.close()
    quit()

while True:
    buff = con.recv(1024)
    if not buff: break
    if buff == 'LINE\n':
        buff = line[i].upper()
        con.sendall(buff)
        i = (i+1) % cnt

con.close()
