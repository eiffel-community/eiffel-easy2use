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
# Network in Docker. Note! This is not yet propagated to docker-compose.yml.
NETWORK=eiffel_2.0_1
[[ ! -z ${DOCKER_NETWORK_OVERRIDE} ]] && NETWORK=${DOCKER_NETWORK_OVERRIDE}
#verbose "Network to use: $NETWORK"
 
 
export EIFFEL_DOCKER_NETWORK=$NETWORK
export EIFFEL_NETWORK_NAME=eiffel2_network