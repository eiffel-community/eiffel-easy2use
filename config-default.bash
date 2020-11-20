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
# This is the main config file for Easy2Use

# You can copy this file to config-user.bash and modify it without having it
# overwritten by a git merge/pull command, since it is excluded in .gitignore
# The contents of config-user.bash will override the settings in this file.

# Default target type in which Easy2Use will be deployed
# Values: Docker or Kubernetes
#TARGET_TYPE="Docker"
TARGET_TYPE="Kubernetes"


# ----------- Docker specific global configurations
# ------------------------------------------------------------------------------

# Docker specific config
if [ ! -z ${HOST} ]
then
  TARGET_HOST=${HOST}
else
  if [ $(uname -s) == Linux ]
  then
    TARGET_HOST=$(hostname -I | tr " " "\n"| head -1)
  else
    if [ $is_docker_for_windows ]
    then
      TARGET_HOST=localhost
    else
      if [ $is_docker_toolbox ]
      then
        TARGET_HOST=$(docker-machine ip ${DOCKER_MACHINE_NAME} 2>/dev/null)
      fi
    fi
  fi
  export HOST=${TARGET_HOST}
fi


# ----------- Docker specific bundle override configurations
# Configurations defined here will override the parameters defined in the bundle
# specific Docker config file
# ------------------------------------------------------------------------------

# DOCKER_NETWORK_OVERRIDE will override docker network settings in bundle
# config-docker.bash file. Which means that you can start multiple bundles in
# the same docker network. Leave commented out if not used.
# DOCKER_NETWORK_OVERRIDE="mynetwork"


# ----------- Kubernetes specific global configurations
# ------------------------------------------------------------------------------

# K8S config file path. Needed by external tools and must therefore be exported
if [ -z ${KUBECONFIG} ]
then
    KUBECONFIG=$HOME/.kube/config
fi

# Domain name for the K8S NGINX Ingress
# If using local K8S cluster set via localhost_k8s_config.sh set
# K8S_DOMAINNAME="mylocalkube"
# If using remote K8S cluster set cluster domain name
# ex K8S_DOMAINNAME="remotek8s.company.com"
K8S_DOMAINNAME="mylocalkube"


# ----------- Kubernetes specific bundle override configurations
# Configurations defined here will override the parameters defined in the bundle
# specific Kubernetes config file
# ------------------------------------------------------------------------------

# K8S_NAMESPACE_OVERRIDE will override K8S namespace settings in bundle
# config-k8s file. Which means that you can start multiple bundles in then
# same K8S namespace. Leave commented out if not used.
# K8S_NAMESPACE_OVERRIDE="mynamespace"

# ----------- Helm Version
# For Helm V3 use value V3  WARNING: ONLY THE EIFFEL BUNDLE IS WORKING WITH BOTH V2 & V3!
#     Helm V2 use value V2
#     Default: Helm V3
# ------------------------------------------------------------------------------
HELM_VERSION=V3

# ----------- Services Security configurations -------------------------------------
# Some Kubernetes setup requires external connections to services to use secure HTTPS
#
# Set these configuration variables to configure secure HTTP connections:
# K8S_INGRESS_TLS_ENABLE=false  , for using HTTP connections
# K8S_INGRESS_TLS_ENABLE=true   , for using secure HTTPS connections
# K8S_INGRESS_CERT_SECRET_NAME , If K8S_INGRESS_TLS_ENABLE is set to true, then
#                                 a K8S Certifacate Secret is required,
#                                 set this variable to the K8S Certificate Secret name
# ------------------------------------------------------------------------------
K8S_INGRESS_TLS_ENABLE=false
K8S_INGRESS_CERT_SECRET_NAME=""


# ----------- Services Persistence Storage (PVC) configurations -------------------------------------
# Some components support persitent storage in Kubernetes, e.g. MongoDb and RabbitMq in Eiffel bundle.
# When persistence storage (PVC - PersistenceVolumeClaim) is enabled, data is not lossed in case of restart of pod/container.
# There is two configuration
# K8S_PVC_ENABLE : if set to true, then persistence storage will be used for components that support that.
# K8S_PVC_SIZE : sets the size that need to be allocated per components that support the persistent storage.
# K8S_PVC_STORAGE_CLASS : If defined, storageClassName: <storageClass>
#                         If set to "-", storageClassName: "", which disables dynamic provisioning
#                         If undefined (the default) or set to null, no storageClassName spec is
#                         set, choosing the default provisioner.  (gp2 on AWS, standard on
#                         GKE, AWS & OpenStack)
#                         storageClass: "-"
#                       
# ------------------------------------------------------------------------------
K8S_PVC_ENABLE=false
K8S_PVC_SIZE=8Gi
K8S_PVC_STORAGE_CLASS="null"
