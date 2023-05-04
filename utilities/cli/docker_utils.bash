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
##-------------------------------------------------------------------------------------
## Docker specific utilities
##
##--------------------------------------------------------------------------------------


#-----------------------------
# execute_docker_command
#
# Execute the given command towards Docker using docker-compose based on the
# provided package or service(s)
#
# Prerequisites:
#  The current directory should be a bundles docker-compose directory
#
# Parameters:
#  $1: Command for docker-compose
#  $2: Flag for docker-compose
#-----------------------------
function execute_docker_command {
  local docker_compose_sub_cmd="$1"
  local docker_compose_flag="$2"
  local package="$3"
  local services="$4"

  verbose "execute_docker_command cmd: ${docker_compose_sub_cmd}"
  verbose "execute_docker_command flag: ${docker_compose_flag}"

  if [ -z "$services" ] && [ -z "$package" ]
  then
    print "Docker ${docker_compose_sub_cmd}"
    call "$DOCKER_COMPOSE_CMD stop" $noop

  else
    if [ ! -z "$services" ]
    then
      services_string=$(echo $services | tr ',' ' ')
      print "Docker ${docker_compose_sub_cmd} service(s): ${services_string}"
      call "$DOCKER_COMPOSE_CMD ${docker_compose_sub_cmd} ${docker_compose_flag} ${services_string}" $noop
    fi

    if [ ! -z "$package" ]
    then
      [[ -f "./packages/$package.sh" ]] || \
        bail_out "Package file: $package.sh specified do not exist"

      source ./packages/$package.sh
      print "Docker ${docker_compose_sub_cmd} package service(s): ${docker_package_services}"
      call "$DOCKER_COMPOSE_CMD ${docker_compose_sub_cmd} ${docker_compose_flag} ${docker_package_services}" $noop
    fi
  fi
}
