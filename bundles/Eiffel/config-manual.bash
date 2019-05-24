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
# This config file can be sourced if you wish to execute docker or kubectl
# commands manually instead of using the easy2use CLI.

source ../../utilities/cli/cli_utils.bash
source ../../config-default.bash

export TARGET_TYPE=Docker

source component-versions.bash
source base-config.bash
source config-bundle.bash
source docker-base-config.bash
source components-configuration.bash


cat <<EOF
Docker & Kubernetes for Eiffel bundle environment prepared.
Now you can start use docker-compose/docker/kubectl/helm commands
in Eiffel bundle.
EOF
