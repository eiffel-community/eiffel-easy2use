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
## GitLab K8S environment variable settings
##
## Author: michael.frick@ericsson.com
##
##--------------------------------------------------------------------------------------



# ---- Do NOT Change --------------------------------

export K8S_Ingress_Enabled=true

# ---- Do NOT Change --------------------------------


# -- Domain name for K8S cluster & Namespace ------
# Domainname in K8S Cluster
verbose "Domainname to use: ${K8S_DOMAINNAME}"

# Namespace in K8S Cluster
K8S_NAMESPACE=cx
[[ ! -z ${K8S_NAMESPACE_OVERRIDE} ]] && K8S_NAMESPACE=${K8S_NAMESPACE_OVERRIDE}
verbose "Namespace to use: ${K8S_NAMESPACE}"


#---- K8S Release.fullnames
export K8S_RELEASE_GITLAB_GITLAB=$GITLAB_GITLAB-$K8S_NAMESPACE


# --- Ingress

### Eiffel Bundle's REMREM URLs. so be seeded in Gerrit/GIT Projects Jenkisfile(s) 
export REMREM_PUBLISH_GEN_PUB_URL="http://eiffel-remrem-publish-${K8S_NAMESPACE}.${K8S_NAMESPACE}:8096/generateAndPublish?mp=eiffelsemantics&parseData=false&msgType="

# Cx bundle's - Artifactory URL
export ARTIFACTORY_URL="http://eiffel-nexus3-${K8S_NAMESPACE}.${K8S_NAMESPACE}:8081/repository/maven-releases"

###################################################################
## GitLab Bundle app context paths (added to apps Ingress URLs)
export app_url_context_path="
GitLab Bundle URLs contextPath:
--------------------------
ms-frontend contextPath: /api/greeting
ms-backend contextPath: /api/hellobackend"


## GitLab Bundle Passwords listings
export easy2use_bundle_psw="
GitLab Secret Variables to be configured in GitLab GUI for project (settings -> CI/CD -> Secret variables):
--------------------------
CI_REGISTRY : docker registry, ex dockerhub = registry.hub.docker.com
CI_PROJECT_PATH : docker registry path
CI_REGISTRY_USER : docker registry user
CI_REGISTRY_PASSWORD : docker registry psw
EIFFEL_REMREM_URL : $REMREM_PUBLISH_GEN_PUB_URL
EIFFEL_NEXUS_URL : $ARTIFACTORY_URL
CD_NAMESPACE : ${K8S_NAMESPACE}"

###################################################################