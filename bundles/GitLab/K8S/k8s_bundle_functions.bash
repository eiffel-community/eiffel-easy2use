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
## Bundle specific Kubernetes functions
##
##--------------------------------------------------------------------------------------

function execute_k8s_command_on_services {
  local k8s_command="$1"
  local services="$2"

  local failed=0
  local additional_installs=()
  local additional_removals=()

  for i in $services
  do
      additional_installs=()
      additional_removals=()

    case $i in


      gitlab_gitlab)      
          # Additional GitLab install
          additional_installs+=( "kubectl create clusterrolebinding gitlab-cluster-admin --clusterrole=cluster-admin --group=system:serviceaccounts --namespace=${K8S_NAMESPACE}" )
          
          ####################  REMOVALS ################################################################## 
          # Additional GitLab Removal
          #additional_removals+=( "kubectl delete crd workflows.argoproj.io -n ${K8S_NAMESPACE}" )
          additional_removals+=( "kubectl delete clusterrolebinding gitlab-cluster-admin --namespace=${K8S_NAMESPACE}" )
          
          local releasename="$K8S_RELEASE_GITLAB_GITLAB"
          local settings=(
            nameOverride="gitlab"
            baseDomain="$K8S_DOMAINNAME"
            legoEmail="me@example.com"
          )
          local valuefile="charts/charts_values/gitlab-omnibus-gitlab-values.yaml"
          local chart="charts/gitlab-omnibus-0.1.37.tgz"       
          
        ;;


      *)
        print "Unknown service: $i"
        return 1
    esac

    do_execute_k8s_command_on_service "$k8s_command" "$i" \
      $releasename \
      settings[@] \
      $valuefile \
      $chart || failed=1

    [[ "$failed" == "1" ]] && break
    
  done

  [[ "$failed" == "0" ]] || return 1
}
