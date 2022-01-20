#!/usr/bin/env python
import pika, sys, os
import subprocess
def main():
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.queue_declare(queue='reqtodom2')

    def callback(ch, method, properties, body):
        
        print ('hellllo')
        subprocess.call("../p4project/hellome.sh")

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
