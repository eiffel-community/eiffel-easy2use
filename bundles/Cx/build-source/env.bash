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
source ../component-versions.bash
source ../config-bundle.bash
source ../config-docker.bash

alias build="docker-compose -f docker-compose.yml -f ../docker-compose.yml build"

echo "Build command prepared and ready to be used. To build a service, execute: build <service name>"
