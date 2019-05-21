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
#!/bin/bash

# These two varibales need to be set from Docker-compose or K8S at startup if MB and/or DB healthcheck should be used.
#WAIT_MB_HOSTS="localhost:15672 localhost:15672"

if [ ! -z "$WAIT_MB_HOSTS" ]
then
  /eiffel/health-check.sh "$WAIT_MB_HOSTS"
fi

echo
echo "Starting Eiffel RemRem-Publish"
echo

catalina.sh run
