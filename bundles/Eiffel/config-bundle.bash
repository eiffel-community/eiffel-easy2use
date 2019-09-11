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
docker_supported="Yes"
kubernetes_supported="Yes"

# ---- Do NOT Change --------------------------------
export K8S_Ingress_Enabled=true

# Namespace in K8S Cluster
K8S_NAMESPACE=eiffel
[[ ! -z ${K8S_NAMESPACE_OVERRIDE} ]] && K8S_NAMESPACE=${K8S_NAMESPACE_OVERRIDE}

EIFFEL_CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
source $EIFFEL_CURRENT_DIR/component-versions.bash
source $EIFFEL_CURRENT_DIR/base-config.bash

if [ "$TARGET_TYPE" == "Kubernetes" ]
then
  source $EIFFEL_CURRENT_DIR/config-k8s.bash
  source $EIFFEL_CURRENT_DIR/k8s-base-config.bash
else
  source $EIFFEL_CURRENT_DIR/config-docker.bash
  source $EIFFEL_CURRENT_DIR/docker-base-config.bash
fi

source $EIFFEL_CURRENT_DIR/components-configuration.bash


###################################################################
## Eiffel Bundle app context paths (added to apps Ingress URLs)
export app_url_context_path="
Eiffel Bundle URLs contextPath:
--------------------------"

## Eiffel Bundle Passwords listings
export easy2use_bundle_psw="
Eiffel Bundle Users/Passwords:
--------------------------
eiffel_jenkins_fem: admin / admin
eiffel_jenkins: admin / admin
eiffel_rabbitmq: myuser / myuser
eiffel_nexus: admin / admin123"
