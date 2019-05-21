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
# Utilities for bash scripts

function verbose {
  if [ "$verbose" ]
  then
    echo -e "Easy2Use: $1"
  fi
}


function print {
  echo -e "Easy2Use: $1"
}


function debug {
  if [ "$debug" ]
  then
    echo -e "Easy2Use DEBUG: $1"
  fi
}


function bail_out {
  echo -e "Easy2Use ERROR: $@"
  exit 1
}


function ask_continue {
  if [ "$interactive" ]
  then
    echo -e "$@"
    echo -n "Do you want to continue (y/n)? "
    read response
    if [[ $response != [Yy] ]]
    then
      verbose "You decided to quit (you answered '$response')"
      exit 0
    fi
  fi
}


function get_bundle_configuration {
  local bundle="$1"
  local package="$2"
  local services="$3"
  local command="$4"

  echo -e "** Easy2Use Bundle Configuration **"

  echo "Bundle: $bundle"
  [[ -z "$package" ]] || echo "Package: $package"
  [[ -z "${services}" ]] || echo "Services: ${services}"

  if [ "$TARGET_TYPE" == "Docker" ]
  then
    echo "Network: $NETWORK"

  else
    if [ "$TARGET_TYPE" == "Kubernetes" ]
    then
      echo "Namespace: ${K8S_NAMESPACE}"
    fi
  fi

  echo "Command: $command"
}


function get_target_configuration {
  echo -e "** Easy2Use Target Configuration **"

  config="Target Type: ${TARGET_TYPE}"
  if [ "$TARGET_TYPE" == "Docker" ]
  then
    echo "${config}
Identified Docker Type: ${docker_type}
HOST: ${TARGET_HOST}"

  else
    if [ "$TARGET_TYPE" == "Kubernetes" ]
    then
      echo "${config}
Domainname: ${K8S_DOMAINNAME}
Cluster configfile: ${KUBECONFIG}
Cluster context: $(kubectl config current-context)"

    fi
  fi
}


#
# Call a command. If verbose mode used the command itself will be echoed first.
#
function call {
  local command=$1
  local noop=$2
  if [ $noop ]
  then
    print "Noop given. Should have executed '$command'"
  else
    verbose "\nExecuting '$@'..."
    $@
  fi
}


function check_docker {
  debug "Checking Docker environment"

  if [ $is_linux ] || [ $is_docker_for_windows ]
  then
    DOCKER_ACTIVE=$(docker info &> /dev/null && echo $?)
    if [ "$DOCKER_ACTIVE" != "0" ]
    then
      bail_out "No Docker daemon seems to be running. \
      Do 'service docker start' or equivalent."
    fi
  fi

  if [ $is_docker_toolbox ]
  then
    # Check that environment points out a Docker machine that is available
    debug "Checking for running Docker machines"
    docker_machine_ls=$(docker-machine ls)
    echo "${docker_machine_ls}" | awk '{ print $4 }' | egrep '^Running$' > /dev/null
    if [ $? -ne 0 ]
    then
      echo "${docker_machine_ls}"
      bail_out "No Docker machine seems to be running. \
      Do 'docker-machine start [<machine name>]' or equivalent."
    fi

    debug "Checking for active running Docker machine"
    echo "${docker_machine_ls}" | grep ' Running ' | awk '{ print $2 }' | egrep '^\*$' > /dev/null
    if [ $? -ne 0 ]
    then
      echo "${docker_machine_ls}"
      bail_out "No running Docker machine seems to be active.
Do 'docker-machine env [<machine name>]' and follow the instructions, \
or equivalent"
    fi
  fi
}


function check_kubernetes {
  debug "Checking Kubernetes environment"

  # Check that Kubernetes/Minikube is running and KUBECONFIG is ok
  kubectl_version_output=$(kubectl version 2>&1)
  [[ $? -eq 0 ]] || \
    bail_out "Could not verify version of Kubernetes client/server. \
Is the server running?\n\
Is KUBECONFIG correctly configured (${KUBECONFIG})?\n\n\
'kubectl version' output:\n${kubectl_version_output}"

  # Check that Helm is installed
  helm --help >/dev/null || bail_out "Helm seems not to be installed"

  # Check that Helm Tiller is initiated
  #helm version >/dev/null || bail_out "Helm is not initiated. Do 'helm init'"
  helm_version_output=$(helm version 2>&1)
  [[ $? -eq 0 ]] || \
    bail_out "Helm is not initiated. Do 'helm init'. \
'helm version' output:\n${helm_version_output}"

  # Check Helm client/server version match. Their compatilibity is only
  # guaranteed when their major.minor versions match
  sed_version_expression='s/^.*SemVer:\"v//g;s/\", Git.*$//g;s/\.[0-9]*$//g'
  helm_client_minor_version=$(echo "${helm_version_output}" | \
    grep Client | sed -e "${sed_version_expression}")
  helm_server_minor_version=$(echo "${helm_version_output}" | \
    grep Server | sed -e "${sed_version_expression}")
  [[ "${helm_client_minor_version}" == "${helm_server_minor_version}" ]] || \
    bail_out "Helm client and servier minor versions mismatch \
(${helm_client_minor_version} vs ${helm_server_minor_version}). \
Please upgrade one of them."
}


#-----------------------------
# verify_bundle_target_type
#
# This function will verify that the current bundle supports to set
# TARGET_TYPE.
#-----------------------------
function verify_bundle_target_type {
  if [ "$TARGET_TYPE" == "Docker" -a \
    "$docker_supported" == "Yes" ]
  then
    return 0
  elif [ "$TARGET_TYPE" == "Kubernetes" -a \
    "$kubernetes_supported" == "Yes" ]
  then
    return 0
  else
    print "Target type '$TARGET_TYPE' is not supported in the bundle '$bundle'"
    return 1
  fi
}


#
# Set some global variables depending on OS and Docker installation
#
if [ "$(uname -s)" == "Linux" ]
then
  is_linux="true"
  docker_type="Docker on Linux"
fi

if [ "$(uname -s)" != "Linux" ] && [ ! "${DOCKER_TOOLBOX_INSTALL_PATH}" ]
then
  is_docker_for_windows="true"
  docker_type="Docker for Windows"
fi

if [ "$(uname -s)" != "Linux" ] && [ "${DOCKER_TOOLBOX_INSTALL_PATH}" ]
then
  is_docker_toolbox="true"
  docker_type="Docker Toolbox"
fi
