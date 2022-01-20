#!/usr/bin/env python
import pika, sys, os
import subprocess
def main():
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.queue_declare(queue='reqtodom2')
#    channel.queue_declare(queue='reqtodom3')
#    def fakecallback(ch, method, properties, body):
#       print ('this is fakecallback')
    def callback(ch, method, properties, body):
        print ('hellllo')
        subprocess.call("../p4project/phellome.sh")
        #subprocess.call(["./psend.py","5")
#    channel.basic_consume(queue='reqtodom3', on_message_callback=fakecallback, auto_ack=True)
    channel.basic_consume(queue='reqtodom2', on_message_callback=callback, auto_ack=True)

    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
