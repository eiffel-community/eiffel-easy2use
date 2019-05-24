#
#   Copyright 2019 Ericsson AB.
#   For a full list of individual contributors, please see the commit history.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# example_publisher.py
import json
import pika, os, logging
logging.basicConfig()

# Parse CLODUAMQP_URL (fallback to localhost)
url = os.environ.get('CLOUDAMQP_URL', 'amqp://myuser:myuser@10.210.17.118:30000/%2f')

params = pika.URLParameters(url)
params.socket_timeout = 5

connection = pika.BlockingConnection(params) # Connect to CloudAMQP
channel = connection.channel() # start a channel
channel.queue_declare(queue='er001-eiffelxxx.eiffelintelligence.messageConsumer.durable', durable=True) # Declare a queue
# send a message

# Reading event data
with open('events.json', 'r') as f:
     data_events = json.load(f)

index = 0
for event in data_events:
 #print(event)
 channel.basic_publish(exchange='ei-poc-4', routing_key='#', body=json.dumps(event))
 index += 1
 if index==100:
   break

print("Sent : %s events" % index)
connection.close()