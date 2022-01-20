#!/usr/bin/env python
import pika
import sys
import os
def sndmsg(id):
 #message = id + ":" + pip
 message = id
 credentials = pika.PlainCredentials(username= 'test', password='test')
 parameters = pika.ConnectionParameters(host='145.100.130.148',
                                   port=5672,
                                   virtual_host= '/',
                                   credentials=credentials)
 connection = pika.BlockingConnection(parameters)
 channel = connection.channel()
 channel.queue_declare(queue='hello')
 channel.basic_publish(exchange='',
                      routing_key='hello',
                      body= message)
 print(" [x] Sent 'Hello World!'")
 connection.close()
if __name__ == '__main__':
      if len(sys.argv) < 1:
        print("Usage: python3 <id> <public ip>")
      else:
        id = sys.argv[1]
        #pip = sys.argv[2]
        sndmsg(id)
