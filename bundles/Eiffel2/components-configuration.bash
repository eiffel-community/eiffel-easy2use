
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
# Common configurations

### RestApi URLs. See config-docker.bash and config-k8s.bash for SERVICE_PORT
### variable configuration. What is SERVICE_PORT? /erabbkk
export EIFFEL2_REMREM_GENERATE_URL="http://${EIFFEL2_REMREM_GENERATE}:${EIFFEL2_REMREM_GENERATE_APPLICATION_PORT}"
export EIFFEL2_REMREM_PUBLISH_URL="http://${EIFFEL2_REMREM_PUBLISH}:${EIFFEL2_REMREM_PUBLISH_APPLICATION_PORT}"
export EIFFEL2_REMREM_PUBLISH_PRODUCER_URL="http://${EIFFEL2_REMREM_PUBLISH}:${EIFFEL2_REMREM_PUBLISH_APPLICATION_PORT}/producer"
export EIFFEL2_REMREM_GENERATE_EIFFELSEMANTICS_URL="http://${EIFFEL2_REMREM_GENERATE}:${EIFFEL2_REMREM_GENERATE_APPLICATION_PORT}/eiffelsemantics"
export EIFFEL2_REMREM_PUBLISH_PRODUCER_EIFFELSEMANTICS_URL="http://${EIFFEL2_REMREM_PUBLISH}:${EIFFEL2_REMREM_PUBLISH_APPLICATION_PORT}/producer/msg?mp=eiffelsemantics"
export EIFFEL2_REMREM_PUBLISH_GEN_PUB_URL="http://${EIFFEL2_REMREM_PUBLISH}:${EIFFEL2_REMREM_GENERATE_APPLICATION_PORT}/generateAndpublish?mp=eiffelsemantics&parseData=false&msgType="

export EIFFEL2_ER_SEARCH_URL="http://${EIFFEL2_ER}:${EIFFEL2_ER_APPLICATION_PORT}/search/"
export EIFFEL2_ER_REST_URL="http://${EIFFEL2_ER}:${EIFFEL2_ER_APPLICATION_PORT}"

export EIFFEL2_NEXUS_URL=http://${EIFFEL2_NEXUS3}:${EIFFEL2_NEXUS_APPLICATION_PORT}/


## Common RabbitMq, MongoDb, Nexus and Mail settings
export EIFFEL2_RABBITMQ_VHOST=/
export EIFFEL2_RABBITMQ_USER=myuser
export EIFFEL2_RABBITMQ_PASSWORD=myuser
export EIFFEL2_RABBITMQ_EXCHANGE="ei-poc-4"
export EIFFEL2_RABBITMQ_DOMAIN_ID=eiffel2
export EIFFEL2_RABBITMQ_BINDING_KEY=#

export EIFFEL2_MONGODB_USER=
export EIFFEL2_MONGODB_PASSWORD=


export EIFFEL2_NEXUS_USER=admin
export EIFFEL2_NEXUS_PASSWORD=admin123
export EIFFEL2_NEXUS_URL=http://${EIFFEL2_NEXUS3}:${EIFFEL2_NEXUS_APPLICATION_PORT}/

export MAIL_HOST=mail.lmera.ericsson.se
export MAIL_PORT=25
export MAIL_USER=
export MAIL_PASSWORD=
export MAIL_PROPERTIES_AUTH_ENABLE=false
export MAIL_PROPERTIES_STARTTLS_ENABLE=false



## Common Eiffel configurations

# Common EI configurations
export EIFFEL2_EI_SEARCH_QUERY_PREFIX=object
export EIFFEL2_EI_AGGREGATED_OBJECT_NAME=aggregatedObject
export EIFFEL2_EI_RABBITMQ_CONSUMER_NAME=messageConsumer
export EIFFEL2_EI_RABBITMQ_TLS_VERSION=
export EIFFEL2_EI_RABBITMQ_QUEUE_DURABLE=true
export EIFFEL2_EI_MERGE_ID_MAKER=%IdentifyRules%
export EIFFEL2_EI_AGGREGATED_DB_TTL=

# Common RemRem configurations
export EIFFEL2_REMREM_USER=guest
export EIFFEL2_REMREM_PASSWORD=guest

## Common Eiffel configurations

export EIFFEL2_EI_SEARCH_QUERY_PREFIX=object
export EIFFEL2_EI_AGGREGATED_OBJECT_NAME=aggregatedObject


################################################################


### Specific component settings for both Docker and K8S

### EI Frontend service ###

export EIFFEL2_EI_FRONTEND_EI_INSTANCES_LIST="[\
{ \"contextPath\": \"\"\, \"port\": \"${EIFFEL2_EI_BACKEND_ARTIFACT_APPLICATION_PORT}\"\, \"name\": \"${EIFFEL2_EI_BACKEND_ARTIFACT}\"\, \"host\": \"${EIFFEL2_EI_BACKEND_ARTIFACT}\"\, \"https\": false\, \"defaultBackend\": true}\,\
{ \"contextPath\": \"\"\, \"port\": \"${EIFFEL2_EI_BACKEND_SOURCECHANGE_APPLICATION_PORT}\"\, \"name\": \"${EIFFEL2_EI_BACKEND_SOURCECHANGE}\"\, \"host\": \"${EIFFEL2_EI_BACKEND_SOURCECHANGE}\"\, \"https\": false\, \"defaultBackend\": false}\,\
{ \"contextPath\": \"\"\, \"port\": \"${EIFFEL2_EI_BACKEND_TESTEXECUTION_APPLICATION_PORT}\"\, \"name\": \"${EIFFEL2_EI_BACKEND_TESTEXECUTION}\"\, \"host\": \"${EIFFEL2_EI_BACKEND_TESTEXECUTION}\"\, \"https\": false\, \"defaultBackend\": false}\,\
{ \"contextPath\": \"\"\, \"port\": \"${EIFFEL2_EI_BACKEND_ALLEVENTS_APPLICATION_PORT}\"\, \"name\": \"${EIFFEL2_EI_BACKEND_ALLEVENTS}\"\, \"host\": \"${EIFFEL2_EI_BACKEND_ALLEVENTS}\"\, \"https\": false\, \"defaultBackend\": false}\
]"

export CONFIG_EIFFEL2_EI_FRONTEND="
spring.application.name=${EIFFEL2_EI_FRONTEND}
server.port=${EIFFEL2_EI_FRONTEND_INTERNAL_PORT}
ei.frontend.service.host=${EIFFEL2_EI_FRONTEND}
ei.frontend.service.port=${EIFFEL2_EI_FRONTEND_EXTERNAL_APPLICATION_PORT}
ei.frontend.context.path=
ei.use.secure.http.frontend=false
ei.backend.instances.list.json.content=${EIFFEL2_EI_FRONTEND_EI_INSTANCES_LIST}
ei.backend.instances.filepath=/tmp/eiInstancesListFile.json
logging.level.root=ERROR
logging.level.org.springframework.web=DEBUG
logging.level.com.ericsson.ei=DEBUG"


## K8S Format
export K8S_CONFIG_EIFFEL2_EI_FRONTEND="|-
$CONFIG_EIFFEL2_EI_FRONTEND"

export K8S_ENV_CONFIG_EIFFEL2_EI_FRONTEND=""

# Docker format
CONFIG_EIFFEL2_EI_FRONTEND_WITHOUT_COMMA_ESCAPE=$(echo -e "$CONFIG_EIFFEL2_EI_FRONTEND" | sed -e 's/\\,/,/g')
export DOCKER_CONFIG_EIFFEL2_EI_FRONTEND=$CONFIG_EIFFEL2_EI_FRONTEND_WITHOUT_COMMA_ESCAPE

### End of EI Frontend service ###

### EI Backend Allevents service ###

## General format for both Docker and K8S
export CONFIG_EIFFEL2_EI_BACKEND_ALLEVENTS="
SpringApplicationName=${EIFFEL2_EI_BACKEND_ALLEVENTS}
server.port=${EIFFEL2_EI_BACKEND_ALLEVENTS_INTERNAL_PORT}
rules.path=/rules/AllEventsRules-Eiffel-Toulouse-Version.json
rabbitmq.domainId=${EIFFEL2_RABBITMQ_DOMAIN_ID}
rabbitmq.componentName=eiffelintelligence-allevents
rabbitmq.waitlist.queue.suffix=waitlist-allevents
rabbitmq.host=${EIFFEL2_RABBITMQ}
rabbitmq.port=${EIFFEL2_RABBITMQ_AMQP_APPLICATION_PORT}
rabbitmq.exchange.name=${EIFFEL2_RABBITMQ_EXCHANGE}
rabbitmq.consumerName=${EIFFEL2_EI_RABBITMQ_CONSUMER_NAME}
rabbitmq.queue.durable=${EIFFEL2_EI_RABBITMQ_QUEUE_DURABLE}
rabbitmq.tlsVersion=${EIFFEL2_RABBITMQ_TLS_VERSION}
rabbitmq.user=${EIFFEL2_RABBITMQ_USER}
rabbitmq.password=${EIFFEL2_RABBITMQ_PASSWORD}
mergeidmarker=${EIFFEL2_EI_MERGE_ID_MAKER}
spring.data.mongodb.host=${EIFFEL2_MONGODB}
spring.data.mongodb.port=${EIFFEL2_MONGODB_APPLICATION_PORT}
spring.data.mongodb.database=eiffel2_intelligence-allevents
missedNotificationDataBaseName=eiffel2_intelligence-allevents_MissedNotification
missedNotificationCollectionName=Notification
aggregated.object.name=aggregatedObject
aggregated.collection.name=aggregated_objects
aggregated.collection.ttlValue=${EIFFEL2_EI_AGGREGATED_DB_TTL}
event_object_map.collection.name=event_object_map
waitlist.collection.name=wait_list
waitlist.collection.ttlValue=600
waitlist.initialDelayResend=2000
waitlist.fixedRateResend=15000
subscription.collection.name=subscription
subscription.collection.repeatFlagHandlerName=subscription_repeat_handler
testaggregated.enabled=false
threads.corePoolSize=100
threads.queueCapacity=5000
threads.maxPoolSize=150
search.query.prefix=${EIFFEL2_EI_SEARCH_QUERY_PREFIX}
aggregated.object.name=${EIFFEL2_EI_AGGREGATED_OBJECT_NAME}
email.sender=noreply@ericsson.com
email.subject=Email Subscription Notification
notification.failAttempt=3
notification.ttl.value=600
spring.mail.host=${MAIL_HOST}
spring.mail.port=${MAIL_PORT}
spring.mail.username=${MAIL_USER}
spring.mail.password=${MAIL_PASSWORD}
spring.mail.properties.mail.smtp.auth=${MAIL_PROPERTIES_AUTH_ENABLE}
spring.mail.properties.mail.smtp.starttls.enable=${MAIL_PROPERTIES_STARTTLS_ENABLE}
ldap.enabled=false
ldap.url=
ldap.base.dn=
ldap.username=
ldap.password=
ldap.user.filter=
er.url=${EIFFEL2_ER_SEARCH_URL}
logging.level.root=ERROR
logging.level.org.springframework.web=DEBUG
logging.level.com.ericsson.ei=DEBUG"

## K8S Format
export K8S_CONFIG_EIFFEL2_EI_BACKEND_ALLEVENTS="|-
$CONFIG_EIFFEL2_EI_BACKEND_ALLEVENTS"

export K8S_ENV_CONFIG_EIFFEL2_EI_BACKEND_ALLEVENTS="WAIT_MB_HOSTS: '$EIFFEL2_RABBITMQ\:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}'
WAIT_DB_HOSTS: '$EIFFEL2_MONGODB\:${EIFFEL2_MONGODB_APPLICATION_PORT}'"

# Docker format
export DOCKER_CONFIG_EIFFEL2_EI_BACKEND_ALLEVENTS="$CONFIG_EIFFEL2_EI_BACKEND_ALLEVENTS
WAIT_MB_HOSTS=$EIFFEL2_RABBITMQ:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}
WAIT_DB_HOSTS=$EIFFEL2_MONGODB:${EIFFEL2_MONGODB_APPLICATION_PORT}"

### End of EI Backend Allevents service ###

### EI Backend Artifact service ###

## General format for both Docker and K8S
export CONFIG_EIFFEL2_EI_BACKEND_ARTIFACT="
SpringApplicationName=${EIFFEL2_EI_BACKEND_ARTIFACT}
server.port=${EIFFEL2_EI_BACKEND_ARTIFACT_INTERNAL_PORT}
rules.path=/rules/ArtifactRules-Eiffel-Toulouse-Version.json
rabbitmq.domainId=${EIFFEL2_RABBITMQ_DOMAIN_ID}
rabbitmq.componentName=eiffelintelligence-artifact
rabbitmq.waitlist.queue.suffix=waitlist-artifact
rabbitmq.host=${EIFFEL2_RABBITMQ}
rabbitmq.port=${EIFFEL2_RABBITMQ_AMQP_APPLICATION_PORT}
rabbitmq.exchange.name=${EIFFEL2_RABBITMQ_EXCHANGE}
rabbitmq.consumerName=${EIFFEL2_EI_RABBITMQ_CONSUMER_NAME}
rabbitmq.queue.durable=${EIFFEL2_EI_RABBITMQ_QUEUE_DURABLE}
rabbitmq.tlsVersion=${EIFFEL2_RABBITMQ_TLS_VERSION}
rabbitmq.user=${EIFFEL2_RABBITMQ_USER}
rabbitmq.password=${EIFFEL2_RABBITMQ_PASSWORD}
mergeidmarker=${EIFFEL2_EI_MERGE_ID_MAKER}
spring.data.mongodb.host=${EIFFEL2_MONGODB}
spring.data.mongodb.port=${EIFFEL2_MONGODB_APPLICATION_PORT}
spring.data.mongodb.database=eiffel2_intelligence-artifact
missedNotificationDataBaseName=eiffel2_intelligence-artifact_MissedNotification
missedNotificationCollectionName=Notification
aggregated.object.name=aggregatedObject
aggregated.collection.name=aggregated_objects
aggregated.collection.ttlValue=${EIFFEL2_EI_AGGREGATED_DB_TTL}
event_object_map.collection.name=event_object_map
waitlist.collection.name=wait_list
waitlist.collection.ttlValue=600
waitlist.initialDelayResend=2000
waitlist.fixedRateResend=15000
subscription.collection.name=subscription
subscription.collection.repeatFlagHandlerName=subscription_repeat_handler
testaggregated.enabled=false
threads.corePoolSize=100
threads.queueCapacity=5000
threads.maxPoolSize=150
search.query.prefix=${EIFFEL2_EI_SEARCH_QUERY_PREFIX}
aggregated.object.name=${EIFFEL2_EI_AGGREGATED_OBJECT_NAME}
email.sender=noreply@ericsson.com
email.subject=Email Subscription Notification
notification.failAttempt=3
notification.ttl.value=600
spring.mail.host=${MAIL_HOST}
spring.mail.port=${MAIL_PORT}
spring.mail.username=${MAIL_USER}
spring.mail.password=${MAIL_PASSWORD}
spring.mail.properties.mail.smtp.auth=${MAIL_PROPERTIES_AUTH_ENABLE}
spring.mail.properties.mail.smtp.starttls.enable=${MAIL_PROPERTIES_STARTTLS_ENABLE}
ldap.enabled=false
ldap.url=
ldap.base.dn=
ldap.username=
ldap.password=
ldap.user.filter=
er.url=${EIFFEL2_ER_SEARCH_URL}
logging.level.root=ERROR
logging.level.org.springframework.web=DEBUG
logging.level.com.ericsson.ei=DEBUG"

## K8S Format
export K8S_CONFIG_EIFFEL2_EI_BACKEND_ARTIFACT="|-
$CONFIG_EIFFEL2_EI_BACKEND_ARTIFACT"

export K8S_ENV_CONFIG_EIFFEL2_EI_BACKEND_ARTIFACT="WAIT_MB_HOSTS: '$EIFFEL2_RABBITMQ\:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}'
WAIT_DB_HOSTS: '$EIFFEL2_MONGODB\:${EIFFEL2_MONGODB_APPLICATION_PORT}'"

# Docker format
export DOCKER_CONFIG_EIFFEL2_EI_BACKEND_ARTIFACT="$CONFIG_EIFFEL2_EI_BACKEND_ARTIFACT
WAIT_MB_HOSTS=$EIFFEL2_RABBITMQ:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}
WAIT_DB_HOSTS=$EIFFEL2_MONGODB:${EIFFEL2_MONGODB_APPLICATION_PORT}"

### End of EI Backend Artifact service ###


### EI Backend TestExecution service ###

## General format for both Docker and K8S
export CONFIG_EIFFEL2_EI_BACKEND_TESTEXECUTION="
SpringApplicationName=${EIFFEL2_EI_BACKEND_TESTEXECUTION}
server.port=${EIFFEL2_EI_BACKEND_TESTEXECUTION_INTERNAL_PORT}
rules.path=/rules/TestExecutionObjectRules-Eiffel-Toulouse-Version.json
rabbitmq.domainId=${EIFFEL2_RABBITMQ_DOMAIN_ID}
rabbitmq.componentName=eiffelintelligence-testexecution
rabbitmq.waitlist.queue.suffix=waitlist-testexecution
rabbitmq.host=${EIFFEL2_RABBITMQ}
rabbitmq.port=${EIFFEL2_RABBITMQ_AMQP_APPLICATION_PORT}
rabbitmq.exchange.name=${EIFFEL2_RABBITMQ_EXCHANGE}
rabbitmq.consumerName=${EIFFEL2_EI_RABBITMQ_CONSUMER_NAME}
rabbitmq.queue.durable=${EIFFEL2_EI_RABBITMQ_QUEUE_DURABLE}
rabbitmq.tlsVersion=${EIFFEL2_RABBITMQ_TLS_VERSION}
rabbitmq.user=${EIFFEL2_RABBITMQ_USER}
rabbitmq.password=${EIFFEL2_RABBITMQ_PASSWORD}
mergeidmarker=${EIFFEL2_EI_MERGE_ID_MAKER}
spring.data.mongodb.host=${EIFFEL2_MONGODB}
spring.data.mongodb.port=${EIFFEL2_MONGODB_APPLICATION_PORT}
spring.data.mongodb.database=eiffel2_intelligence-testexecution
missedNotificationDataBaseName=eiffel2_intelligence-testexecution_MissedNotification
missedNotificationCollectionName=Notification
aggregated.object.name=aggregatedObject
aggregated.collection.name=aggregated_objects
aggregated.collection.ttlValue=${EIFFEL2_EI_AGGREGATED_DB_TTL}
event_object_map.collection.name=event_object_map
waitlist.collection.name=wait_list
waitlist.collection.ttlValue=600
waitlist.initialDelayResend=2000
waitlist.fixedRateResend=15000
subscription.collection.name=subscription
subscription.collection.repeatFlagHandlerName=subscription_repeat_handler
testaggregated.enabled=false
threads.corePoolSize=100
threads.queueCapacity=5000
threads.maxPoolSize=150
search.query.prefix=${EIFFEL2_EI_SEARCH_QUERY_PREFIX}
aggregated.object.name=${EIFFEL2_EI_AGGREGATED_OBJECT_NAME}
email.sender=noreply@ericsson.com
email.subject=Email Subscription Notification
notification.failAttempt=3
notification.ttl.value=600
spring.mail.host=${MAIL_HOST}
spring.mail.port=${MAIL_PORT}
spring.mail.username=${MAIL_USER}
spring.mail.password=${MAIL_PASSWORD}
spring.mail.properties.mail.smtp.auth=${MAIL_PROPERTIES_AUTH_ENABLE}
spring.mail.properties.mail.smtp.starttls.enable=${MAIL_PROPERTIES_STARTTLS_ENABLE}
ldap.enabled=false
ldap.url=
ldap.base.dn=
ldap.username=
ldap.password=
ldap.user.filter=
er.url=${EIFFEL2_ER_SEARCH_URL}
logging.level.root=ERROR
logging.level.org.springframework.web=DEBUG
logging.level.com.ericsson.ei=DEBUG"

## K8S Format
export K8S_CONFIG_EIFFEL2_EI_BACKEND_TESTEXECUTION="|-
$CONFIG_EIFFEL2_EI_BACKEND_TESTEXECUTION"

export K8S_ENV_CONFIG_EIFFEL2_EI_BACKEND_TESTEXECUTION="WAIT_MB_HOSTS: '$EIFFEL2_RABBITMQ\:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}'
WAIT_DB_HOSTS: '$EIFFEL2_MONGODB\:${EIFFEL2_MONGODB_APPLICATION_PORT}'"

# Docker format
export DOCKER_CONFIG_EIFFEL2_EI_BACKEND_TESTEXECUTION="$CONFIG_EIFFEL2_EI_BACKEND_TESTEXECUTION
WAIT_MB_HOSTS=$EIFFEL2_RABBITMQ:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}
WAIT_DB_HOSTS=$EIFFEL2_MONGODB:${EIFFEL2_MONGODB_APPLICATION_PORT}"

### End of EI Backend TestExecution service ###


### EI Backend SourceChange service ###

## General format for both Docker and K8S
export CONFIG_EIFFEL2_EI_BACKEND_SOURCECHANGE="
SpringApplicationName=${EIFFEL2_EI_BACKEND_SOURCECHANGE}
server.port=${EIFFEL2_EI_BACKEND_SOURCECHANGE_INTERNAL_PORT}
rules.path=/rules/SourceChangeObjectRules-Eiffel-Toulouse-Version.json
rabbitmq.domainId=${EIFFEL2_RABBITMQ_DOMAIN_ID}
rabbitmq.componentName=eiffelintelligence-sourcechange
rabbitmq.waitlist.queue.suffix=waitlist-sourcechange
rabbitmq.host=${EIFFEL2_RABBITMQ}
rabbitmq.port=${EIFFEL2_RABBITMQ_AMQP_APPLICATION_PORT}
rabbitmq.exchange.name=${EIFFEL2_RABBITMQ_EXCHANGE}
rabbitmq.consumerName=${EIFFEL2_EI_RABBITMQ_CONSUMER_NAME}
rabbitmq.queue.durable=${EIFFEL2_EI_RABBITMQ_QUEUE_DURABLE}
rabbitmq.tlsVersion=${EIFFEL2_RABBITMQ_TLS_VERSION}
rabbitmq.user=${EIFFEL2_RABBITMQ_USER}
rabbitmq.password=${EIFFEL2_RABBITMQ_PASSWORD}
mergeidmarker=${EIFFEL2_EI_MERGE_ID_MAKER}
spring.data.mongodb.host=${EIFFEL2_MONGODB}
spring.data.mongodb.port=${EIFFEL2_MONGODB_APPLICATION_PORT}
spring.data.mongodb.database=eiffel2_intelligence-sourcechange
missedNotificationDataBaseName=eiffel2_intelligence-sourcechange_MissedNotification
missedNotificationCollectionName=Notification
aggregated.object.name=aggregatedObject
aggregated.collection.name=aggregated_objects
aggregated.collection.ttlValue=${EIFFEL2_EI_AGGREGATED_DB_TTL}
event_object_map.collection.name=event_object_map
waitlist.collection.name=wait_list
waitlist.collection.ttlValue=600
waitlist.initialDelayResend=2000
waitlist.fixedRateResend=15000
subscription.collection.name=subscription
subscription.collection.repeatFlagHandlerName=subscription_repeat_handler
testaggregated.enabled=false
threads.corePoolSize=100
threads.queueCapacity=5000
threads.maxPoolSize=150
search.query.prefix=${EIFFEL2_EI_SEARCH_QUERY_PREFIX}
aggregated.object.name=${EIFFEL2_EI_AGGREGATED_OBJECT_NAME}
email.sender=noreply@ericsson.com
email.subject=Email Subscription Notification
notification.failAttempt=3
notification.ttl.value=600
spring.mail.host=${MAIL_HOST}
spring.mail.port=${MAIL_PORT}
spring.mail.username=${MAIL_USER}
spring.mail.password=${MAIL_PASSWORD}
spring.mail.properties.mail.smtp.auth=${MAIL_PROPERTIES_AUTH_ENABLE}
spring.mail.properties.mail.smtp.starttls.enable=${MAIL_PROPERTIES_STARTTLS_ENABLE}
ldap.enabled=false
ldap.url=
ldap.base.dn=
ldap.username=
ldap.password=
ldap.user.filter=
er.url=${EIFFEL2_ER_SEARCH_URL}
logging.level.root=ERROR
logging.level.org.springframework.web=ERROR
logging.level.com.ericsson.ei=DEBUG"

## K8S Format
export K8S_CONFIG_EIFFEL2_EI_BACKEND_SOURCECHANGE="|-
$CONFIG_EIFFEL2_EI_BACKEND_SOURCECHANGE"

export K8S_ENV_CONFIG_EIFFEL2_EI_BACKEND_SOURCECHANGE="WAIT_MB_HOSTS: '$EIFFEL2_RABBITMQ\:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}'
WAIT_DB_HOSTS: '$EIFFEL2_MONGODB\:${EIFFEL2_MONGODB_APPLICATION_PORT}'"

# Docker format
export DOCKER_CONFIG_EIFFEL2_EI_BACKEND_SOURCECHANGE="$CONFIG_EIFFEL2_EI_BACKEND_SOURCECHANGE
WAIT_MB_HOSTS=$EIFFEL2_RABBITMQ:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}
WAIT_DB_HOSTS=$EIFFEL2_MONGODB:${EIFFEL2_MONGODB_APPLICATION_PORT}"

### End of EI Backend SourceChange service ###


### Dummy ER service ###
export CONFIG_EIFFEL2_DUMMY_ER="
mongodb=true
mongodb.host=${EIFFEL2_MONGODB}
mongodb.port=${EIFFEL2_MONGODB_APPLICATION_PORT}
database.name=eiffel
collection.name=events"

## K8S Format
export K8S_CONFIG_EIFFEL2_DUMMY_ER="|-
$CONFIG_EIFFEL2_DUMMY_ER"

# Docker format
export DOCKER_CONFIG_EIFFEL2_DUMMY_ER="$CONFIG_EIFFEL2_DUMMY_ER"

### End of Dummy ER service ###


### Eiffel-ER service ###

export CONFIG_EIFFEL2_ER="
server.contextPath=/
server.port=${EIFFEL2_ER_INTERNAL_PORT}
rabbitmq.host=${EIFFEL2_RABBITMQ}
rabbitmq.port=${EIFFEL2_RABBITMQ_AMQP_APPLICATION_PORT}
rabbitmq.componentName=eiffel-er
rabbitmq.domainId=${EIFFEL2_RABBITMQ_DOMAIN_ID}
rabbitmq.durable=true
rabbitmq.user=${EIFFEL2_RABBITMQ_USER}
rabbitmq.password=${EIFFEL2_RABBITMQ_PASSWORD}
rabbitmq.exchangeName=${EIFFEL2_RABBITMQ_EXCHANGE}
rabbitmq.bindingKey=${EIFFEL2_RABBITMQ_BINDING_KEY}
rabbitmq.autoDelete=false
rabbitmq.createExchangeIfNotExisting=true
rabbitmq.consumerName=messageConsumer
mongodb.host=${EIFFEL2_MONGODB}
mongodb.port=${EIFFEL2_MONGODB_APPLICATION_PORT}
mongodb.database=eiffel
mongodb.collection=events
mongodb.user=${EIFFEL2_MONGODB_USER}
mongodb.password=${EIFFEL2_MONGODB_PASSWORD}
mongodb.indexes='meta.id\,links.target\,links.type\,meta.time\,data.gav.groupId\,data.gav.artifactId'
mongodb.externalERs=
search.limit=100
search.levels=10
eventrepo2.URL=https://eiffel.lmera.ericsson.se/com.ericsson.duraci/eiffel_erri/index.html
index.staticIndex.indexOn=false
index.staticIndex.filePath=src/main/resources/static_indexes.json
index.dynamicIndex.indexOn=false
index.dynamicIndex.indexCreationDay=SUNDAY
index.dynamicIndex.indexCreationTime=11:50:00
index.dynamicIndex.maxIndexesCount=5
index.dynamicIndex.filePath=src/main/resources/dynamic_indexing.json
index.dynamicIndex.fileUpdatePeriod=30"


## K8S Format
export K8S_CONFIG_EIFFEL2_ER="|-
$CONFIG_EIFFEL2_ER"

export K8S_ENV_CONFIG_EIFFEL2_ER="WAIT_MB_HOSTS: '$EIFFEL2_RABBITMQ\:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}'
WAIT_DB_HOSTS: '$EIFFEL2_MONGODB\:${EIFFEL2_MONGODB_APPLICATION_PORT}'"

# Docker format
export DOCKER_CONFIG_EIFFEL2_ER="$CONFIG_EIFFEL2_ER
WAIT_MB_HOSTS=$EIFFEL2_RABBITMQ:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}
WAIT_DB_HOSTS=$EIFFEL2_MONGODB:${EIFFEL2_MONGODB_APPLICATION_PORT}"

### End of Eiffel-ER service ###


### RemRem-Publish service ###



export CONFIG_EIFFEL2_REMREM_PUBLISH="
server.port=${EIFFEL2_REMREM_PUBLISH_INTERNAL_PORT}
jasypt.encryptor.password=
rabbitmq.instances.jsonlist=[\
{ \"mp\": \"eiffelsemantics\"\, \"host\": \"${EIFFEL2_RABBITMQ}\"\, \"port\": \"${EIFFEL2_RABBITMQ_AMQP_APPLICATION_PORT}\"\, \"username\": \"${EIFFEL2_RABBITMQ_USER}\"\, \"password\": \"${EIFFEL2_RABBITMQ_PASSWORD}\"\, \"tls\": \"${EIFFEL2_REMREM_PUBLISH_RABBITMQ_TLS}\"\, \"exchangeName\": \"${EIFFEL2_RABBITMQ_EXCHANGE}\"\, \"domainId\": \"${EIFFEL2_RABBITMQ_DOMAIN_ID}\" }\
]
generate.server.uri=${EIFFEL2_REMREM_GENERATE_URL}
generate.server.path=
activedirectory.publish.enabled=false
activedirectory.ldapUrl=
activedirectory.managerPassword=
activedirectory.managerDn=
activedirectory.rootDn=
activedirectory.userSearchFilter=
logging.level.root=ERROR
logging.level.org.springframework.web=ERROR
logging.level.com.ericsson.eiffel.remrem.producer=DEBUG"

# K8S format
export K8S_CONFIG_EIFFEL2_REMREM_PUBLISH="|-
$CONFIG_EIFFEL2_REMREM_PUBLISH"

export K8S_ENV_CONFIG_EIFFEL2_REMREM_PUBLISH="WAIT_MB_HOSTS: '$EIFFEL2_RABBITMQ\:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}'"

# Docker format
CONFIG_EIFFEL2_REMREM_PUBLISH_WITHOUT_COMMA_ESCAPE=$(echo -e "$CONFIG_EIFFEL2_REMREM_PUBLISH" | sed -e 's/\\,/,/g')
export DOCKER_CONFIG_EIFFEL2_REMREM_PUBLISH="$CONFIG_EIFFEL2_REMREM_PUBLISH_WITHOUT_COMMA_ESCAPE
WAIT_MB_HOSTS=$EIFFEL2_RABBITMQ:${EIFFEL2_RABBITMQ_WEB_APPLICATION_PORT}"

### End of RemRem-Publish service ###


### RemRem-Generate service ###

export CONFIG_EIFFEL2_REMREM_GENERATE="
server.port=${EIFFEL2_REMREM_GENERATE_EXTERNAL_PORT}
jasypt.encryptor.password=
activedirectory.generate.enabled=false
activedirectory.ldapUrl=
activedirectory.managerPassword=
activedirectory.managerDn=
activedirectory.rootDn=
activedirectory.userSearchFilter=
logging.level.root=ERROR
logging.level.org.springframework.web=ERROR
logging.level.com.ericsson.eiffel.remrem.producer=DEBUG"

# K8S format
export K8S_CONFIG_EIFFEL2_REMREM_GENERATE="|-
$CONFIG_EIFFEL2_REMREM_GENERATE"

# Docker format
export DOCKER_CONFIG_EIFFEL2_REMREM_GENERATE="$CONFIG_EIFFEL2_REMREM_GENERATE"

### End of RemRem-Generate service ###


### Nexus service ###


# K8S format
export K8S_CONFIG_EIFFEL2_NEXUS3="NEXUS_USER_NAME: '${EIFFEL2_NEXUS_USER}'
NEXUS_PASSWORD: '${EIFFEL2_NEXUS_PASSWORD}'"

# Docker format
export DOCKER_CONFIG_EIFFEL2_NEXUS3="NEXUS_USER_NAME=${EIFFEL2_NEXUS_USER}
NEXUS_PASSWORD=${EIFFEL2_NEXUS_PASSWORD}"

### End of Nexus service ###


### Jenkins service ###

# K8S format
export K8S_CONFIG_EIFFEL2_JENKINS="NEXUS_URL: '${EIFFEL2_NEXUS_URL}'
NEXUS_USER: '${EIFFEL2_NEXUS_USER}'
NEXUS_PASSWORD: '${EIFFEL2_NEXUS_PASSWORD}'
REMREM_PUBLISH_URL: '${EIFFEL2_REMREM_PUBLISH_URL}'"

# Docker format
export DOCKER_CONFIG_EIFFEL2_JENKINS="NEXUS_URL=${EIFFEL2_NEXUS_URL}
NEXUS_USER=${EIFFEL2_NEXUS_USER}
NEXUS_PASSWORD=${EIFFEL2_NEXUS_PASSWORD}
REMREM_PUBLISH_URL=${EIFFEL2_REMREM_PUBLISH_URL}"

### End of Jenkins service ###


### Eiffel-Jenkins service ###

## Eiffel-Jenkins with FEM plugin specific settings
export EIFFEL2_JENKINS_FEM_NEXUS_DOWNLOAD_REPO_NAME=/repositories/maven-releases/
export EIFFEL2_JENKINS_FEM_NEXUS_UPLOAD_REPO_NAME=/repositories/maven-releases/
export EIFFEL2_JENKINS_FEM_NEXUS_DESCRIPTION=nexus
export EIFFEL2_JENKINS_FEM_RABBITMQ_COMPONENT_NAME=eiffel-jenkins
export EIFFEL2_JENKINS_FEM_RABBITMQ_PROTOCOL=amqp
export EIFFEL2_JENKINS_FEM_RABBITMQ_CREATE_EXCHANGE=true
export EIFFEL2_JENKINS_FEM_BYPASS_IO=false

# K8S format
export K8S_CONFIG_EIFFEL2_JENKINS_FEM="NEXUS_DESCRIPTION: '${EIFFEL2_JENKINS_FEM_NEXUS_DESCRIPTION}'
NEXUS_URL: '${EIFFEL2_NEXUS_URL}'
NEXUS_USER: '${EIFFEL2_NEXUS_USER}'
NEXUS_PASSWORD: '${EIFFEL2_NEXUS_PASSWORD}'
NEXUS_DOWNLOAD_REPO_NAME: '${EIFFEL2_JENKINS_FEM_NEXUS_DOWNLOAD_REPO_NAME}'
NEXUS_UPLOAD_REPO_NAME: '${EIFFEL2_JENKINS_FEM_NEXUS_UPLOAD_REPO_NAME}'
RABBITMQ_HOST: '${EIFFEL2_RABBITMQ}'
RABBITMQ_PORT: '${EIFFEL2_RABBITMQ_AMQP_APPLICATION_PORT}'
RABBITMQ_EXCHANGE_NAME: '${EIFFEL2_RABBITMQ_EXCHANGE}'
RABBITMQ_COMPONENT_NAME: '${EIFFEL2_JENKINS_FEM_RABBITMQ_COMPONENT_NAME}'
RABBITMQ_PROTOCOL: '${EIFFEL2_JENKINS_FEM_RABBITMQ_PROTOCOL}'
RABBITMQ_CREATE_EXCHANGE: '${EIFFEL2_JENKINS_FEM_RABBITMQ_CREATE_EXCHANGE}'
RABBITMQ_USER: '${EIFFEL2_RABBITMQ_USER}'
RABBITMQ_PASSWORD: '${EIFFEL2_RABBITMQ_PASSWORD}'
RABBITMQ_DOMAIN_ID: '${EIFFEL2_RABBITMQ_DOMAIN_ID}'
REMREM_GENERATE_URL: '${EIFFEL2_REMREM_GENERATE_URL}'
REMREM_PUBLISH_URL: '${EIFFEL2_REMREM_PUBLISH_URL}'
REMREM_PUBLISH_GEN_PUB_URL: '${EIFFEL2_REMREM_PUBLISH_GEN_PUB_URL}'
REMREM_USER: '${EIFFEL2_REMREM_USER}'
REMREM_PASSWORD: '${EIFFEL2_REMREM_PASSWORD}'
ER_REST_URL: '${EIFFEL2_ER_REST_URL}'
BYPASS_IO: '${EIFFEL2_JENKINS_FEM_BYPASS_IO}'
FEM_VERSION: '${EIFFEL2_JENKINS_PLUGIN_VERSION}'
WAIT_MB_HOSTS: '${EIFFEL2_RABBITMQ}\:${EIFFEL2_RABBITMQ_WEB_EXTERNAL_PORT}'"

# Docker format
#      - JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties"
export DOCKER_CONFIG_EIFFEL2_JENKINS_FEM="NEXUS_DESCRIPTION=${EIFFEL2_JENKINS_FEM_NEXUS_DESCRIPTION}
NEXUS_URL=${EIFFEL2_NEXUS_URL}
NEXUS_USER=${EIFFEL2_NEXUS_USER}
NEXUS_PASSWORD=${EIFFEL2_NEXUS_PASSWORD}
NEXUS_DOWNLOAD_REPO_NAME=${EIFFEL2_JENKINS_FEM_NEXUS_DOWNLOAD_REPO_NAME}
NEXUS_UPLOAD_REPO_NAME=${EIFFEL2_JENKINS_FEM_NEXUS_UPLOAD_REPO_NAME}
RABBITMQ_HOST=${EIFFEL2_RABBITMQ}
RABBITMQ_PORT=${EIFFEL2_RABBITMQ_AMQP_APPLICATION_PORT}
RABBITMQ_EXCHANGE_NAME=${EIFFEL2_RABBITMQ_EXCHANGE}
RABBITMQ_COMPONENT_NAME=${EIFFEL2_JENKINS_FEM_RABBITMQ_COMPONENT_NAME}
RABBITMQ_PROTOCOL=${EIFFEL2_JENKINS_FEM_RABBITMQ_PROTOCOL}
RABBITMQ_CREATE_EXCHANGE=${EIFFEL2_JENKINS_FEM_RABBITMQ_CREATE_EXCHANGE}
RABBITMQ_USER=${EIFFEL2_RABBITMQ_USER}
RABBITMQ_PASSWORD=${EIFFEL2_RABBITMQ_PASSWORD}
RABBITMQ_DOMAIN_ID=${EIFFEL2_RABBITMQ_DOMAIN_ID}
REMREM_GENERATE_URL=${EIFFEL2_REMREM_GENERATE_URL}
REMREM_PUBLISH_URL=${EIFFEL2_REMREM_PUBLISH_URL}
REMREM_PUBLISH_GEN_PUB_URL=${EIFFEL2_REMREM_PUBLISH_GEN_PUB_URL}
REMREM_USER=${EIFFEL2_REMREM_USER}
REMREM_PASSWORD=${EIFFEL2_REMREM_PASSWORD}
ER_REST_URL=${EIFFEL2_ER_REST_URL}
BYPASS_IO=${EIFFEL2_JENKINS_FEM_BYPASS_IO}
FEM_VERSION=${EIFFEL2_JENKINS_PLUGIN_VERSION}
WAIT_MB_HOSTS=${EIFFEL2_RABBITMQ}\:${EIFFEL2_RABBITMQ_WEB_EXTERNAL_PORT}"

### End of Eiffel-Jenkins service ###




##### Generating Eiffel components Docker Environment files for docker-compose file. 

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

echo -e "$DOCKER_CONFIG_EIFFEL2_EI_FRONTEND" > $CURRENT_DIR/docker-env-files/ei-frontend.env
echo -e "$DOCKER_CONFIG_EIFFEL2_EI_BACKEND_ARTIFACT" > $CURRENT_DIR/docker-env-files/ei-backend-artifact.env
echo -e "$DOCKER_CONFIG_EIFFEL2_EI_BACKEND_SOURCECHANGE" > $CURRENT_DIR/docker-env-files/ei-backend-sourcechange.env
echo -e "$DOCKER_CONFIG_EIFFEL2_EI_BACKEND_TESTEXECUTION" > $CURRENT_DIR/docker-env-files/ei-backend-testexecution.env
echo -e "$DOCKER_CONFIG_EIFFEL2_EI_BACKEND_ALLEVENTS" > $CURRENT_DIR/docker-env-files/ei-backend-allevents.env
echo -e "$DOCKER_CONFIG_EIFFEL2_DUMMY_ER" > $CURRENT_DIR/docker-env-files/dummy-er.env
echo -e "$DOCKER_CONFIG_EIFFEL2_ER" > $CURRENT_DIR/docker-env-files/eiffel-er.env
echo -e "$DOCKER_CONFIG_EIFFEL2_REMREM_PUBLISH" > $CURRENT_DIR/docker-env-files/remrem-publish.env
echo -e "$DOCKER_CONFIG_EIFFEL2_REMREM_GENERATE" > $CURRENT_DIR/docker-env-files/remrem-generate.env
echo -e "$DOCKER_CONFIG_EIFFEL2_NEXUS3" > $CURRENT_DIR/docker-env-files/nexus.env
echo -e "$DOCKER_CONFIG_EIFFEL2_JENKINS" > $CURRENT_DIR/docker-env-files/jenkins.env
echo -e "$DOCKER_CONFIG_EIFFEL2_JENKINS_FEM" > $CURRENT_DIR/docker-env-files/eiffel-jenkins.env


############### Kubernetes MongoDb seed of data. For Docker look in docker-compose file. ########################

export EIFFEL2_EI_BACKEND_ARTIFACT_MONGODB_DATABASE_NAME=eiffel2_intelligence-artifact
export EIFFEL2_EI_BACKEND_ARTIFACT_MONGODB_MISSED_NOTIFICATION_DATABASE_NAME=eiffel2_intelligence-artifact_MissedNotification
export EIFFEL2_EI_BACKEND_SOURCECHANGE_MONGODB_DATABASE_NAME=eiffel2_intelligence-sourcechange
export EIFFEL2_EI_BACKEND_SOURCECHANGE_MONGODB_MISSED_NOTIFICATION_DATABASE_NAME=eiffel2_intelligence-sourcechange_MissedNotification
export EIFFEL2_EI_BACKEND_TESTEXECUTION_MONGODB_DATABASE_NAME=eiffel2_intelligence-testexecution
export EIFFEL2_EI_BACKEND_TESTEXECUTION_MONGODB_MISSED_NOTIFICATION_DATABASE_NAME=eiffel2_intelligence-testexecution_MissedNotification
export EIFFEL2_EI_BACKEND_ALLEVENTS_MONGODB_DATABASE_NAME=eiffel2_intelligence-allevents
export EIFFEL2_EI_BACKEND_ALLEVENTS_MONGODB_MISSED_NOTIFICATION_DATABASE_NAME=eiffel2_intelligence-allevents_MissedNotification

export K8S_CONFIG_EIFFEL2_MONGODB_SEED_INJECTENVVALUESTOFILESSH="#!/bin/bash
sed -i 's/EIFFEL2_JENKINS_FEM/${EIFFEL2_JENKINS_FEM}\:${EIFFEL2_JENKINS_FEM_EXTERNAL_PORT}/g' '/etc/pre-install/seed-data/ei_allevents/subscription.json'
sed -i 's/EIFFEL2_JENKINS/${EIFFEL2_JENKINS}\:${EIFFEL2_JENKINS_EXTERNAL_PORT}/g' '/etc/pre-install/seed-data/ei_allevents/subscription.json'
sed -i 's/EIFFEL2_JENKINS_FEM/${EIFFEL2_JENKINS_FEM}\:${EIFFEL2_JENKINS_FEM_EXTERNAL_PORT}/g' '/etc/pre-install/seed-data/ei_artifact/subscription.json'
sed -i 's/EIFFEL2_JENKINS/${EIFFEL2_JENKINS}\:${EIFFEL2_JENKINS_EXTERNAL_PORT}/g' '/etc/pre-install/seed-data/ei_artifact/subscription.json'
sed -i 's/EIFFEL2_JENKINS_FEM/${EIFFEL2_JENKINS_FEM}\:${EIFFEL2_JENKINS_FEM_EXTERNAL_PORT}/g' '/etc/pre-install/seed-data/ei_sourcechange/subscription.json'
sed -i 's/EIFFEL2_JENKINS/${EIFFEL2_JENKINS}\:${EIFFEL2_JENKINS_EXTERNAL_PORT}/g' '/etc/pre-install/seed-data/ei_sourcechange/subscription.json'
sed -i 's/EIFFEL2_JENKINS_FEM/${EIFFEL2_JENKINS_FEM}\:${EIFFEL2_JENKINS_FEM_EXTERNAL_PORT}/g' '/etc/pre-install/seed-data/ei_testexecution/subscription.json'
sed -i 's/EIFFEL2_JENKINS/${EIFFEL2_JENKINS}\:${EIFFEL2_JENKINS_EXTERNAL_PORT}/g' '/etc/pre-install/seed-data/ei_testexecution/subscription.json'"


export K8S_CONFIG_EIFFEL2_MONGODB_SEED_RUNSH="#!/bin/bash
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ARTIFACT_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/sessions.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ARTIFACT_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/aggregated_objects.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ARTIFACT_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/event_object_map.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ARTIFACT_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/wait_list.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ARTIFACT_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/ei_artifact/subscription.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ARTIFACT_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/subscription_repeat_handler.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ARTIFACT_MONGODB_MISSED_NOTIFICATION_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/Notification.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_SOURCECHANGE_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/sessions.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_SOURCECHANGE_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/aggregated_objects.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_SOURCECHANGE_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/event_object_map.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_SOURCECHANGE_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/wait_list.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_SOURCECHANGE_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/ei_sourcechange/subscription.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_SOURCECHANGE_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/subscription_repeat_handler.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_SOURCECHANGE_MONGODB_MISSED_NOTIFICATION_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/Notification.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_TESTEXECUTION_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/sessions.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_TESTEXECUTION_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/aggregated_objects.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_TESTEXECUTION_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/event_object_map.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_TESTEXECUTION_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/wait_list.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_TESTEXECUTION_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/ei_testexecution/subscription.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_TESTEXECUTION_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/subscription_repeat_handler.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_TESTEXECUTION_MONGODB_MISSED_NOTIFICATION_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/Notification.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ALLEVENTS_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/sessions.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ALLEVENTS_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/aggregated_objects.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ALLEVENTS_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/event_object_map.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ALLEVENTS_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/wait_list.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ALLEVENTS_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/ei_allevents/subscription.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ALLEVENTS_MONGODB_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/subscription_repeat_handler.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db ${EIFFEL2_EI_BACKEND_ALLEVENTS_MONGODB_MISSED_NOTIFICATION_DATABASE_NAME} --type json --file /etc/pre-install/seed-data/Notification.json --jsonArray &&
mongoimport --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT} --db eiffel --type json --file /etc/pre-install/seed-data/events.json --jsonArray &&
mongo eiffel --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.events.remove({})' &&
mongo MissedNotification-artifact --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.Notification.remove({})' &&
mongo MissedNotification-sourcechange --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.Notification.remove({})' &&
mongo MissedNotification-testexecution --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.Notification.remove({})' &&
mongo MissedNotification-allevents --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.Notification.remove({})' &&
mongo eiffel_intelligence-artifact --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.sessions.remove({})' &&
mongo eiffel_intelligence-artifact --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.aggregated_objects.remove({})' &&
mongo eiffel_intelligence-artifact --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.event_object_map.remove({})' &&
mongo eiffel_intelligence-artifact --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.wait_list.remove({})' &&
mongo eiffel_intelligence-artifact --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.subscription_repeat_handler.remove({})' &&
mongo eiffel_intelligence-sourcechange --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.sessions.remove({})' &&
mongo eiffel_intelligence-sourcechange --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.aggregated_objects.remove({})' &&
mongo eiffel_intelligence-sourcechange --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.event_object_map.remove({})' &&
mongo eiffel_intelligence-sourcechange --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.wait_list.remove({})' &&
mongo eiffel_intelligence-sourcechange --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.subscription_repeat_handler.remove({})' &&
mongo eiffel_intelligence-testexecution --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.sessions.remove({})' &&
mongo eiffel_intelligence-testexecution --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.aggregated_objects.remove({})' &&
mongo eiffel_intelligence-testexecution --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.event_object_map.remove({})' &&
mongo eiffel_intelligence-testexecution --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.wait_list.remove({})' &&
mongo eiffel_intelligence-testexecution --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.subscription_repeat_handler.remove({})' &&
mongo eiffel_intelligence-allevents --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.sessions.remove({})' &&
mongo eiffel_intelligence-allevents --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.aggregated_objects.remove({})' &&
mongo eiffel_intelligence-allevents --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.event_object_map.remove({})' &&
mongo eiffel_intelligence-allevents --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.wait_list.remove({})' &&
mongo eiffel_intelligence-allevents --host ${EIFFEL2_MONGODB}:${EIFFEL2_MONGODB_EXTERNAL_PORT}  --eval 'db.subscription_repeat_handler.remove({})'"

####### End of Kubernetes MongoDb seed of data. For Docker look in docker-compose file. #################################
