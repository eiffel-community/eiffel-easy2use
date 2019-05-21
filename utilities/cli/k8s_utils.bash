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
## Kubernetes specific utilities
##
##--------------------------------------------------------------------------------------


#-----------------------------
# execute_k8s_command
#
# Execute the given command towards Kubernetes based on the provided package
# or service(s)
#
# Prerequisites:
#  The current directory should be a bundles K8S directory
#
# Parameters:
#  $1: Helm cmd for K8S
#  $2: Package to use
#  $3: Services to use
#-----------------------------
function execute_k8s_command {
  local k8s_command="$1"
  local package="$2"
  local services="$3"

  verbose "execute_k8s_command cmd: $k8s_command"
  verbose "execute_k8s_command pkg: $package"
  verbose "execute_k8s_command services: $services"

  if [ ! -z "$services" ]
  then
    print "Kubernetes $k8s_command service(s): $services"
    execute_k8s_command_on_services $k8s_command "$services" \
      || bail_out "Could not $k8s_command service(s): $services"
  fi

  if [ ! -z "$package" ]
  then
    [[ -f "./packages/$package.sh" ]] || \
      bail_out "Package file: ./packages/$package.sh specified do not exist"

    source ./packages/$package.sh
    print "Kubernetes $k8s_command package service(s): $k8s_package_services"
    execute_k8s_command_on_services $k8s_command "$k8s_package_services" \
      || bail_out "Could not $k8s_command service(s): $k8s_package_services"
  fi
}


#-----------------------------
# array_to_string
#
# Converts a bash array to a comma separated string
#
# Parameters:
#  $@: array to convert to a string
#-----------------------------
function array_to_string {
  declare -a array=("${!1}")

  local old_ifs=$IFS
  IFS=','
  local result=$(echo "${array[*]}")
  IFS=$old_ifs
  echo "$result"
}


#-----------------------------
# do_execute_k8s_command_on_service
#
# Execute Kubernetes Helm command on given service
#
# Parameters:
#  $1: Kubernetes (Helm) command
#  $2: Service name
#  $3: Array of helm settings
#  $4: Release name
#  $5: Yml file to use for helm chart values
#  $6: Chart file path
#-----------------------------
function do_execute_k8s_command_on_service {
  local k8s_command="$1"
  local servicename="$2"
  local releasename="$3"
  declare -a settings_array=("${!4}")
  local valuefile="$5"
  local chart="$6"

  if [ "$k8s_command" == "install" ]
  then

    local settings_string=$(array_to_string settings_array[@])
    verbose "Kubernetes do install, settings string: .${settings_string}."

    if [ "$verbose" ]
    then
      if [ "$additional_installs" ]  
      then
        for i in "${additional_installs[@]}"; do
          ${i} || print "Warning: Could not install additional installs: ${i}"
        done
      fi

      helm install \
        --namespace "$K8S_NAMESPACE" \
        --name "$releasename" \
        --set "$settings_string" \
        --replace \
        --debug \
        --values $valuefile \
        $chart \
        || ( print "Could not install $releasename" ; return 1 ) \
        && verbose "Service $servicename installed as $releasename"



    else
      if [ "$additional_installs" ]  
      then
        for i in "${additional_installs[@]}"; do
         ${i} >/dev/null || print "Warning: Could not install additional installs: ${i}"
        done
      fi 

      if [ "$chart" ]
      then
        helm install \
          --namespace "$K8S_NAMESPACE" \
          --name "$releasename" \
          --set "$settings_string" \
          --replace \
          --values $valuefile \
          $chart >/dev/null \
          || ( print "Could not install $releasename" ; return 1 ) \
          && verbose "Service $servicename installed as $releasename"
      fi 
    fi
    
  elif [ "$k8s_command" == "delete" ]
  then
    verbose "Kubernetes do install, settings string: .${settings_string}."

    if [ "$verbose" ]
    then
      if [ "$releasename" != "null" ]
      then
        helm delete "$releasename" --purge \
        || print "Warning: Could not delete $releasename"
      fi   
      if [ "$additional_removals" ]  
      then
        for i in "${additional_removals[@]}"; do
          ${i}  || print "Warning: Could not delete additional removals: ${i}"
        done
      fi
    else
      if [ "$releasename" != "null" ]
      then
        helm delete "$releasename" --purge >/dev/null \
        || print "Warning: Could not delete $releasename"
      fi  
      if [ "$additional_removals" ]  
      then
        for i in "${additional_removals[@]}"; do
          ${i} >/dev/null || print "Warning: Could not delete additional removals: ${i}"
        done
      fi  
    fi
  fi
}
