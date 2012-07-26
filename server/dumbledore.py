#-*- coding: utf-8 -*-
#
#  Dumbledore.py
#  voldemort
#
#  Created by  on 7/23/12.
#  Copyright (c) 2012 Quantive,Inc. All rights reserved.
#

#import os
#import sys

from gevent import monkey; monkey.patch_all()
from gevent import spawn as Spawn
import gevent
from gevent_zeromq import zmq
import redis
import msgpack

r = redis.StrictRedis(host='127.0.0.1', port=6377, db=0)
z = zmq.Context()

socket = z.socket(zmq.REP)
socket.bind("tcp://*:5566")

def start(application):
    """docstring for start"""
    while True:
        buffer = socket.recv()
        req = msgpack.loads(buffer)
        method = getattr(application,req['method'])
        res = msgpack.dumps(method(**req['kwargs']))
        socket.send(res)
        
class Protocol(object):
    """docstring for ClassName"""
    def register(self,email, device, nick):
        """docstring for register"""
        if r.hexists(email,device):
            return {'code':2,'data':'you have registed the same device!'}
        else:
            r.hset(email,device,nick)
            return {'code':1,'data':'successful!'}
    
    def fetch(self,email, device, update = None):
        """docstring for fname"""
        cmt = "commit_%s_%s"%(device,email)
        commit = r.hgetall(cmt)
        print commit
        if not commit:
            return {'code':0,'data':'no task for this device!'}
        if (update == None) or (int(update) < int(commit['last_update'])):
            task_id = "task_%s_%s"%(device,email)
            task = r.lrange(task_id,0,-1)
            task = map(lambda x:msgpack.loads(x),task)
            print task
            return {'code':1,'data':task,'update':int(commit['last_update'])}
        else:
            return {'code':2,'data':'no more update data!'}
        
        

if __name__ == "__main__":            
    Spawn(start(Protocol())).join()