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
# Configure if this bundle could be deployed in a pure Docker context
# and/or a Kubernetes context
# GitLab Bundle only supports K8S deployements.
docker_supported="No"
kubernetes_supported="Yes"

##-------------------------------------------------------------------------------------
## GitLab environment variable settings
##
## Author: michael.frick@ericsson.com
##
##--------------------------------------------------------------------------------------

### DNS Service names
# ----- GitLab Servicenames, External Ports, Internal Ports
export GITLAB_GITLAB="gitlab-gitlab"



###################################################################
## Dependencies : Other Easy2Use Bundle's service(s) to be loaded
#  CONF_$thisbundlename_DEPENDENCIES_BUNDLES[x]="OtherBundlename,service1,service2...etc"
#
# Variable naming convention: CONF_$thisbundlename_DEPENDENCIES_BUNDLES[x]  
#  - OBS $thisbundlename is casesensitive, same as the bundle folder name
# Value naming convention: "OtherBundlename,service1,service2...etc"  
#  - OBS no spaces allowed!!
# 

CONF_GitLab_DEPENDENCIES_BUNDLES[0]="Eiffel,rabbitmq,mongodb,mongo_seed,remrem_generate,remrem_publish,er,vici,dummy_er,nexus"

# ------------------------------

