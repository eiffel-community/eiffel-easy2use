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
# Cx Bundle only supports K8S deployements.
docker_supported="No"
kubernetes_supported="Yes"

##-------------------------------------------------------------------------------------
## Cx environment variable settings
##
## Author: michael.frick@ericsson.com
##
##--------------------------------------------------------------------------------------

### DNS Service names
# ----- Cx Servicenames, External Ports, Internal Ports
export CX_ARTIFACTORY="cx-artifactory"
export CX_JENKINS="cx-jenkins"
export CX_GERRIT="cx-gerrit"
export CX_ARGO="cx-argo"
export CX_MINIO="cx-minio"
export CX_GERRIT_POSTGRES_CONFIG="cx-gerrit-postgres-config"
export CX_KEYCLOAK="cx-keycloak"
export CX_ARGOCD="cx-argocd"
export CX_CHARTMUSEUM="cx-chartmuseum"

# ----- Cx External Ports, Internal Ports

export CX_ARTIFACTORY_EXTERNAL_PORT=8081
export CX_ARTIFACTORY_INTERNAL_PORT=8081

export CX_JENKINS_EXTERNAL_PORT=8051
export CX_JENKINS_INTERNAL_PORT=8080

export CX_GERRIT_EXTERNAL_PORT=8080
export CX_GERRIT_INTERNAL_PORT=8080
export CX_GERRIT_EXTERNAL_SSH_PORT=29418
export CX_GERRIT_INTERNAL_SSH_PORT=29418

export CX_KEYCLOAK_EXTERNAL_PORT=80
export CX_POSTGRES_EXTERNAL_PORT=5432
export CX_ARGO_EXTERNAL_PORT=8081
export CX_MINIO_EXTERNAL_PORT=9000


#---------------------------------------

## Specific configuration
## Jenkins
export CX_JENKINS_CONFIG_CI_INIT_ADMIN=admin
export CX_JENKINS_CONFIG_CI_INIT_PASSWORD=admin

## Keycloak
export CX_KEYCLOAK_CONFIG_CI_INIT_ADMIN=admin
export CX_KEYCLOAK_CONFIG_CI_INIT_PASSWORD=admin


## Specific configuration
## Minio
export CX_MINIO_CONFIG_CI_INIT_ADMIN=AKIAIOSFODNN7EXAMPLE
export CX_MINIO_CONFIG_CI_INIT_PASSWORD=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export CX_HELM_CHARTS_MINIO_BUCKET="charts"  
export CX_ARGO_MINIO_BUCKET="argo-artifacts"
export CX_ARGOCD_USERNAME="admin"

## Cx Gerrit Configurations specific settings
# WARNING: OBS Do NOT change CX_GERRIT_CONFIG_CI_INIT_ADMIN, CX_GERRIT_CONFIG_CI_INIT_PASSWORD or CX_GERRIT_CONFIG_CI_INIT_EMAIL, 
# if so then the K8S/charts/chart_values/jenkins_secrets/credentials.xml needs be updated with master.key & hudson.util.Secret.
# And also keycloak config & postgres seed for user needs to be updated.
#
# User & PSW used: easy2use/password123 (psw encrypted to gX6aUy55fjSgJfldDItW2WiCpoiid+2tK9FyqayQlg in postgresql for KeyCloak)
#
export CX_GERRIT_CONFIG_CI_INIT_ADMIN=easy2use
export CX_GERRIT_CONFIG_CI_INIT_PASSWORD=gX6aUy55fjSgJfldDItW2WiCpoiid+2tK9FyqayQlg
export CX_GERRIT_CONFIG_CI_INIT_PASSWORD_CLEAR=password123
export CX_GERRIT_CONFIG_CI_INIT_EMAIL=admin@example.com


## Postgres envvars for Gerrit
export CX_POSTGRES_USER=keycloak
export CX_POSTGRES_PSW=password
export CX_POSTGRES_REVIEWDB=reviewdb


## Jenkins secrets path (relative to bundle "K8S" folder )
export CX_JENKINS_CONFIG_SECRETS_PATH=charts/charts_values/jenkins_secrets/


###################################################################
## Dependencies : Other Easy2Use Bundle's service(s) to be loaded
#  CONF_$thisbundlename_DEPENDENCIES_BUNDLES[x]="OtherBundlename,service1,service2...etc"
#
# Variable naming convention: CONF_$thisbundlename_DEPENDENCIES_BUNDLES[x]  
#  - OBS $thisbundlename is casesensitive, same as the bundle folder name
# Value naming convention: "OtherBundlename,service1,service2...etc"  
#  - OBS no spaces allowed!!
# 

CONF_Cx_DEPENDENCIES_BUNDLES[0]="Eiffel,rabbitmq,mongodb,mongo_seed,remrem_generate,remrem_publish,er,ei_backend_artifact,ei_frontend,dummy_er"

# ------------------------------

