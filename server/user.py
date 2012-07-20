#!/usr/bin/env python
# encoding: utf-8
"""
user.py

Created by Guang Feng on 2012-07-19.
Copyright (c) 2012 __MyCompanyName__. All rights reserved.
"""

from gevent import monkey; monkey.patch_all()
from gevent import spawn as Spawn
import gevent
from gevent_zeromq import zmq
import redis
import msgpack

r = redis.StrictRedis(host='127.0.0.1', port=6379, db=0)
z = zmq.Context()

socket = z.socket(zmq.REP)
socket.bind("tcp://*:5566")

def check(user,device):
    return r.hexists(user,device)

def register(sock):
    while True:
        msg = sock.recv()
        _data = msgpack.loads(msg)
        if check(_data['email'],_data['device']):
            sock.send("you have registed the same device!")
        else:
            r.hset(_data['email'],_data['device'],_data['device_nick'])
            sock.send("successful!");
        
server = Spawn(register,socket)
server.join()

    
    
        
        
        
        


