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

  for i in $services
  do
    case $i in

      mongodb)
        local releasename="$K8S_RELEASE_EIFFEL_MONGODB"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_MONGODB_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_MONGODB_VERSION"
          fullnameOverride="$K8S_SERVICE_EIFFEL_MONGODB"
          service.port="$EIFFEL_MONGODB_EXTERNAL_PORT"
        )
        local valuefile="charts/charts_values/mongodb-values.yaml"
        local chart="charts/mongodb-3.0.1.tgz"
        ;;

      mongo_seed)
        local releasename="$K8S_RELEASE_EIFFEL_MONGODB_SEED"
        local settings=(
          fullnameOverride="$K8S_RELEASE_EIFFEL_MONGODB_SEED"
          configmap.runsh="$K8S_CONFIG_EIFFEL_MONGODB_SEED_RUNSH"
          configmap.injectenvvaluestofilessh="$K8S_CONFIG_EIFFEL_MONGODB_SEED_INJECTENVVALUESTOFILESSH"
          service.port="$EIFFEL_MONGODB_EXTERNAL_PORT"
        )
        local valuefile="charts/charts_values/mongodb-seed-values.yaml"
        local chart="charts/mongodb-seed.tgz"
        ;;

      rabbitmq)
        local releasename="$K8S_RELEASE_EIFFEL_RABBITMQ"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_RABBITMQ_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_RABBITMQ_VERSION"
          ingress.hostName="$K8S_INGRESS_EIFFEL_RABBITMQ"
          fullnameOverride="$K8S_SERVICE_EIFFEL_RABBITMQ"
          rabbitmq.nodePort="$EIFFEL_RABBITMQ_AMQP_EXTERNAL_PORT"
          rabbitmq.managerPort="$EIFFEL_RABBITMQ_WEB_EXTERNAL_PORT"
        )
        local valuefile="charts/charts_values/rabbitmq-values.yaml"
        local chart="charts/rabbitmq-2.2.0.tgz"
        ;;

      ei_backend_artifact)
        local releasename="$K8S_RELEASE_EIFFEL_EI_BACKEND_ARTIFACT"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_EI_BACKEND_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_EI_BACKEND_VERSION"
          eiffel.configuration="$K8S_CONFIG_EIFFEL_EI_BACKEND_ARTIFACT"
          eiffel.configurationEnvironmentVars="$K8S_ENV_CONFIG_EIFFEL_EI_BACKEND_ARTIFACT"
          ingress.hostName="$K8S_INGRESS_EIFFEL_EI_BACKEND_ARTIFACT"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_EI_BACKEND_ARTIFACT"
          eiffel.servicePort="$EIFFEL_EI_BACKEND_ARTIFACT_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_EI_BACKEND_ARTIFACT_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-ei-backend-artifact-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      ei_backend_sourcechange)
        local releasename="$K8S_RELEASE_EIFFEL_EI_BACKEND_SOURCECHANGE"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_EI_BACKEND_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_EI_BACKEND_VERSION"
          eiffel.configuration="$K8S_CONFIG_EIFFEL_EI_BACKEND_SOURCECHANGE"
          eiffel.configurationEnvironmentVars="$K8S_ENV_CONFIG_EIFFEL_EI_BACKEND_SOURCECHANGE"
          ingress.hostName="$K8S_INGRESS_EIFFEL_EI_BACKEND_SOURCECHANGE"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_EI_BACKEND_SOURCECHANGE"
          eiffel.servicePort="$EIFFEL_EI_BACKEND_SOURCECHANGE_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_EI_BACKEND_SOURCECHANGE_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-ei-backend-sourcechange-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      ei_backend_testexecution)
        local releasename="$K8S_RELEASE_EIFFEL_EI_BACKEND_TESTEXECUTION"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_EI_BACKEND_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_EI_BACKEND_VERSION"
          eiffel.configuration="$K8S_CONFIG_EIFFEL_EI_BACKEND_TESTEXECUTION"
          eiffel.configurationEnvironmentVars="$K8S_ENV_CONFIG_EIFFEL_EI_BACKEND_TESTEXECUTION"
          ingress.hostName="$K8S_INGRESS_EIFFEL_EI_BACKEND_TESTEXECUTION"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_EI_BACKEND_TESTEXECUTION"
          eiffel.servicePort="$EIFFEL_EI_BACKEND_TESTEXECUTION_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_EI_BACKEND_TESTEXECUTION_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-ei-backend-testexecution-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      ei_backend_allevents)
        local releasename="$K8S_RELEASE_EIFFEL_EI_BACKEND_ALLEVENTS"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_EI_BACKEND_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_EI_BACKEND_VERSION"
          eiffel.configuration="$K8S_CONFIG_EIFFEL_EI_BACKEND_ALLEVENTS"
          eiffel.configurationEnvironmentVars="$K8S_ENV_CONFIG_EIFFEL_EI_BACKEND_ALLEVENTS"
          ingress.hostName="$K8S_INGRESS_EIFFEL_EI_BACKEND_ALLEVENTS"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_EI_BACKEND_ALLEVENTS"
          eiffel.servicePort="$EIFFEL_EI_BACKEND_ALLEVENTS_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_EI_BACKEND_ALLEVENTS_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-ei-backend-allevents-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      ei_frontend)
        local releasename="$K8S_RELEASE_EIFFEL_EI_FRONTEND"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_EI_FRONTEND_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_EI_FRONTEND_VERSION"
          eiffel.configuration="$K8S_CONFIG_EIFFEL_EI_FRONTEND"
          eiffel.configurationEnvironmentVars="$K8S_ENV_CONFIG_EIFFEL_EI_FRONTEND"
          ingress.hostName="$K8S_INGRESS_EIFFEL_EI_FRONTEND"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_EI_FRONTEND"
          eiffel.servicePort="$EIFFEL_EI_FRONTEND_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_EI_FRONTEND_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-ei-frontend-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      dummy_er)
        local releasename="$K8S_RELEASE_EIFFEL_DUMMY_ER"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_DUMMY_ER_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_DUMMY_ER_VERSION"
          eiffel.configuration="$K8S_CONFIG_EIFFEL_DUMMY_ER"
          ingress.hostName="$K8S_INGRESS_EIFFEL_DUMMY_ER"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_DUMMY_ER"
          eiffel.servicePort="$EIFFEL_DUMMY_ER_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_DUMMY_ER_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-dummy-er-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      vici)
        local releasename="$K8S_RELEASE_EIFFEL_VICI"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_VICI_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_VICI_VERSION"
          ingress.hostName="$K8S_INGRESS_EIFFEL_VICI"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_VICI"
          eiffel.servicePort="$EIFFEL_VICI_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_VICI_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-vici-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      remrem_publish)
        local releasename="$K8S_RELEASE_EIFFEL_REMREM_PUBLISH"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_REMREM_PUBLISH_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_REMREM_PUBLISH_VERSION"
          eiffel.configuration="$K8S_CONFIG_EIFFEL_REMREM_PUBLISH"
          eiffel.configurationEnvironmentVars="$K8S_ENV_CONFIG_EIFFEL_REMREM_PUBLISH"
          ingress.hostName="$K8S_INGRESS_EIFFEL_REMREM_PUBLISH"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_REMREM_PUBLISH"
          eiffel.servicePort="$EIFFEL_REMREM_PUBLISH_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_REMREM_PUBLISH_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-remrem-publish-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      remrem_generate)
        local releasename="$K8S_RELEASE_EIFFEL_REMREM_GENERATE"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_REMREM_GENERATE_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_REMREM_GENERATE_VERSION"
          eiffel.configuration="$K8S_CONFIG_EIFFEL_REMREM_GENERATE"
          eiffel.configurationEnvironmentVars="$K8S_ENV_CONFIG_EIFFEL_REMREM_GENERATE"
          ingress.hostName="$K8S_INGRESS_EIFFEL_REMREM_GENERATE"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_REMREM_GENERATE"
          eiffel.servicePort="$EIFFEL_REMREM_GENERATE_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_REMREM_GENERATE_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-remrem-generate-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      er)
        local releasename="$K8S_RELEASE_EIFFEL_ER"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_ER_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_ER_VERSION"
          eiffel.configuration="$K8S_CONFIG_EIFFEL_ER"
          eiffel.configurationEnvironmentVars="$K8S_ENV_CONFIG_EIFFEL_ER"
          ingress.hostName="$K8S_INGRESS_EIFFEL_ER"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_ER"
          eiffel.servicePort="$EIFFEL_ER_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_ER_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-er-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      jenkins)
        local releasename="$K8S_RELEASE_EIFFEL_JENKINS"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_JENKINS_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_JENKINS_IMAGE_BUILD_VERSION"
          ingress.hostName="$K8S_INGRESS_EIFFEL_JENKINS"
          eiffel.configurationEnvironmentVars="$K8S_CONFIG_EIFFEL_JENKINS"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_JENKINS"
          eiffel.servicePort="$EIFFEL_JENKINS_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_JENKINS_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-jenkins-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      jenkins_fem)
        local releasename="$K8S_RELEASE_EIFFEL_JENKINS_FEM"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_JENKINS_FEM_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_JENKINS_PLUGIN_VERSION"
          ingress.hostName="$K8S_INGRESS_EIFFEL_JENKINS_FEM"
          eiffel.configurationEnvironmentVars="$K8S_CONFIG_EIFFEL_JENKINS_FEM"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_JENKINS_FEM"
          eiffel.servicePort="$EIFFEL_JENKINS_FEM_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_JENKINS_FEM_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-jenkins-fem-values.yaml"
        local chart="charts/eiffel.tgz"
        ;;

      nexus)
        local releasename="$K8S_RELEASE_EIFFEL_NEXUS3"
        local settings=(
                image.registry="$EXTERNAL_DOCKER_REGISTRY"
                image.repository="$EIFFEL_PLUGIN_NEXUS_IMAGE_TAG_NAME"
          image.tag="$EIFFEL_PLUGIN_NEXUS_VERSION"
          ingress.hostName="$K8S_INGRESS_EIFFEL_NEXUS3"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_EIFFEL_NEXUS3"
          eiffel.servicePort="$EIFFEL_NEXUS_EXTERNAL_PORT"
          eiffel.containerPort="$EIFFEL_NEXUS_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/eiffel-nexus3-values.yaml"
        local chart="charts/eiffel.tgz"
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
