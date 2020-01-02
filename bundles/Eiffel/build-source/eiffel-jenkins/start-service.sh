#!/bin/bash

# These two varibales need to be set from Docker-compose or K8S at startup if MB and/or DB healthcheck should be used.
#WAIT_MB_HOSTS="localhost:15672 localhost:15672"
#WAIT_DB_HOSTS="localhost:27017 localhost:27017"

if [ ! -z "$WAIT_MB_HOSTS" ]
then
  /eiffel/health-check.sh "$WAIT_MB_HOSTS"
fi

if [ ! -z "$WAIT_DB_HOSTS" ]
then
  /eiffel/health-check.sh "$WAIT_DB_HOSTS"
fi

echo
echo "Starting Eiffel-Jenkins"
echo

/tmp/generate-fem-settings.sh && /usr/local/bin/jenkins.sh
