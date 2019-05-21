#!/bin/bash
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
#NC_BIN=nc.traditional
#NC_BIN=nc
SLEEP_LENGTH=8

WAIT_HOSTS="${@}"

echo "Will wait for fallowing hosts getting started:"
echo "${WAIT_HOSTS}"

wait_for_service() {
  echo Waiting for $1 to listen on $2...
   LOOP=1
   while [ "$LOOP" != "0" ];
     do
     echo "Waiting on host: ${1}:${2}"
     sleep $SLEEP_LENGTH
     curl $1:$2
     RESULT=$?
     echo "Service check result: $RESULT"
     if [ $RESULT == 0  ]
     then
       LOOP=0
     fi
     done
}

echo
echo "Waiting for components to start"
echo

for URL in `echo "${WAIT_HOSTS}"`
do
  wait_for_service `echo $URL | sed s/\:/\ /`
  echo "Host $URL detected started."
done

echo
echo "All services detected as started."
echo

exit 0
