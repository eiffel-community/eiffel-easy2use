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


      cx_argo)      
          # Additional Argo install
          additional_installs+=( "kubectl create serviceaccount --namespace kube-system argo" )
          additional_installs+=( "kubectl create clusterrolebinding argo-cluster-rule-${K8S_NAMESPACE} --clusterrole=cluster-admin --serviceaccount=${K8S_NAMESPACE}:argo" )                
          #################################################################################################
          ####################  REMOVALS ################################################################## 
          # Only execute if Argo UI installed in namespace, only one per K8S cluster is recommended!
          if [ "$k8s_command" == "delete" ] && [ $(kubectl get svc -n $K8S_NAMESPACE $K8S_RELEASE_CX_ARGO-ui | awk '{if (NR!=1) {print $1}}') ]
          then
            # Additional Argo delete            
            additional_removals+=( "kubectl delete clusterrolebinding argo-cluster-rule-${K8S_NAMESPACE}" )
            
            ## OBS When removing serviceaccount argo from kube-system, any Argo deployments in other namespaces will stop working  
            additional_removals+=( "kubectl delete serviceaccount --namespace kube-system argo" )        

            ## OBS When removing CRD  workflows.argoproj.io, any Argo deployments in other namespaces will stop working  
            additional_removals+=( "kubectl delete crd workflows.argoproj.io -n ${K8S_NAMESPACE}" )
          fi         
          
          
          local releasename="$K8S_RELEASE_CX_ARGO"
          local settings=(
            #image.repository="$CX_MINIO_IMAGE_REPOSITORY"
            images.tag="$CX_ARGO_IMAGE_VERSION"
            #mcImage.repository="$CX_MINIO_MC_IMAGE_REPOSITORY"
            #mcImage.tag="$CX_MINIO_MC_IMAGE_REPOSITORY"
            ui.ingress.hosts={"$K8S_INGRESS_CX_ARGO"}
            ui.ingress.enabled="$K8S_Ingress_Enabled"
            ui.servicePort="$CX_ARGO_EXTERNAL_PORT"
            artifactRepository.s3.accessKeySecret.name="cx-argo-minio"
            artifactRepository.s3.secretKeySecret.name="cx-argo-minio"
            artifactRepository.s3.endpoint="$CX_MINIO.${K8S_NAMESPACE}:$CX_MINIO_EXTERNAL_PORT"
            artifactRepository.s3.bucket="$CX_ARGO_MINIO_BUCKET"
            minio.install="false"          
          )
          local valuefile="charts/charts_values/cx-argo-values.yaml"
          local chart="charts/argo-0.3.1.tgz"       
          
        ;;


      cx_argo_events)
        # Gerrit User Credentials (used in workflows to set gerrit review "Verified +1/-1")
        additional_installs+=("kubectl create secret generic easy2use-gerrit-credentials --from-literal=username=${CX_GERRIT_CONFIG_CI_INIT_ADMIN} --from-literal=password=${CX_GERRIT_CONFIG_CI_INIT_PASSWORD} -n ${K8S_NAMESPACE}")
        # SED Argo-Events files
        cp -rf charts/charts_values/argo_flows/deploy/gateway-controller-deployment-org.yaml charts/charts_values/argo_flows/deploy/gateway-controller-deployment.yaml
        sed -i -e "s%IMAGE_REPOSITORY_SED%${CX_ARGO_EVENTS_GATEWAY_CONTROLLER_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/deploy/gateway-controller-deployment.yaml         
        sed -i -e "s%IMAGE_VERSION_TAG_SED%${CX_ARGO_EVENTS_GATEWAY_CONTROLLER_VERSION//&/\\&}%g" charts/charts_values/argo_flows/deploy/gateway-controller-deployment.yaml         
        cp -rf charts/charts_values/argo_flows/deploy/sensor-controller-deployment-org.yaml charts/charts_values/argo_flows/deploy/sensor-controller-deployment.yaml        
        sed -i -e "s%IMAGE_REPOSITORY_SED%${CX_ARGO_EVENTS_SENSOR_CONTROLLER_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/deploy/sensor-controller-deployment.yaml         
        sed -i -e "s%IMAGE_VERSION_TAG_SED%${CX_ARGO_EVENTS_SENSOR_CONTROLLER_VERSION//&/\\&}%g" charts/charts_values/argo_flows/deploy/sensor-controller-deployment.yaml         
        cp -rf charts/charts_values/argo_flows/deploy/sensor-controller-configmap-org.yaml charts/charts_values/argo_flows/deploy/sensor-controller-configmap.yaml
        sed -i -e "s%NAMESPACE_SED%${K8S_NAMESPACE//&/\\&}%g" charts/charts_values/argo_flows/deploy/sensor-controller-configmap.yaml         
        cp -rf charts/charts_values/argo_flows/deploy/gateway-controller-configmap-org.yaml charts/charts_values/argo_flows/deploy/gateway-controller-configmap.yaml    
        sed -i -e "s%NAMESPACE_SED%${K8S_NAMESPACE//&/\\&}%g" charts/charts_values/argo_flows/deploy/gateway-controller-configmap.yaml                                          
        cp -rf charts/charts_values/argo_flows/argo-events/sensors/sensor-generate-eiffel-event-ms-backend-org.yaml charts/charts_values/argo_flows/argo-events/sensors/sensor-generate-eiffel-event-ms-backend.yaml 
        sed -i -e "s%REMREM_PUB_SED%${REMREM_PUBLISH_GEN_PUB_URL//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-generate-eiffel-event-ms-backend.yaml   
        sed -i -e "s%GERRIT_INGRESS_SED%${K8S_INGRESS_CX_GERRIT//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-generate-eiffel-event-ms-backend.yaml                   
        sed -i -e "s%IMAGE_REPOSITORY_TAG_SED%${CX_ARGO_EVENTS_SENSOR_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-generate-eiffel-event-ms-backend.yaml            
        sed -i -e "s%IMAGE_VERSION_TAG_SED%${CX_ARGO_EVENTS_SENSOR_VERSION//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-generate-eiffel-event-ms-backend.yaml    
        cp -rf charts/charts_values/argo_flows/argo-events/sensors/sensor-webhook-deployment-update-ms-frontend-org.yaml charts/charts_values/argo_flows/argo-events/sensors/sensor-webhook-deployment-update-ms-frontend.yaml 
        sed -i -e "s%REMREM_PUB_SED%${REMREM_PUBLISH_GEN_PUB_URL//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-webhook-deployment-update-ms-frontend.yaml   
        sed -i -e "s%GERRIT_INGRESS_SED%${K8S_INGRESS_CX_GERRIT//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-webhook-deployment-update-ms-frontend.yaml                   
        sed -i -e "s%IMAGE_REPOSITORY_TAG_SED%${CX_ARGO_EVENTS_SENSOR_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-webhook-deployment-update-ms-frontend.yaml             
        sed -i -e "s%IMAGE_VERSION_TAG_SED%${CX_ARGO_EVENTS_SENSOR_VERSION//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-webhook-deployment-update-ms-frontend.yaml          
        cp -rf charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend-org.yaml charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend.yaml
        sed -i -e "s%GERRIT_INGRESS_SED%${K8S_INGRESS_CX_GERRIT//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend.yaml   
        sed -i -e "s%ARTIFACTORY_SED%${ARTIFACTORY_URL//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend.yaml   
        sed -i -e "s%REMREM_PUB_SED%${REMREM_PUBLISH_GEN_PUB_URL//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend.yaml   
        sed -i -e "s%IMAGE_REPOSITORY_TAG_SED%${CX_ARGO_EVENTS_SENSOR_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend.yaml
        sed -i -e "s%IMAGE_VERSION_TAG_SED%${CX_ARGO_EVENTS_SENSOR_VERSION//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend.yaml
        sed -i -e "s%IMAGE_REGISTRY_SED%${CX_IMAGE_REGISTRY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend.yaml   
        sed -i -e "s%IMAGE_REPOSITORY_SED%${CX_IMAGE_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend.yaml                        
        cp -rf charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ei-subscription-ms-frontend-org.yaml charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ei-subscription-ms-frontend.yaml
        sed -i -e "s%IMAGE_REPOSITORY_TAG_SED%${CX_ARGO_EVENTS_SENSOR_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ei-subscription-ms-frontend.yaml
        sed -i -e "s%IMAGE_VERSION_TAG_SED%${CX_ARGO_EVENTS_SENSOR_VERSION//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ei-subscription-ms-frontend.yaml        
        sed -i -e "s%EI_FRONTEND_INGRESS_SED%${EI_FRONTEND_INGRESS//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ei-subscription-ms-frontend.yaml   
        sed -i -e "s%EI_BACKEND_ARTIFACT_DNS_SED%${EI_BACKEND_ARTIFACT_DNS//&/\\&}%g" charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ei-subscription-ms-frontend.yaml                 
        cp -rf charts/charts_values/argo_flows/argo-events/gateways/amqp-gateway-configmap-org.yaml charts/charts_values/argo_flows/argo-events/gateways/amqp-gateway-configmap.yaml        
        sed -i -e "s%RABBITMQ_URL_SED%${CX_RABBITMQ_URL//&/\\&}%g" charts/charts_values/argo_flows/argo-events/gateways/amqp-gateway-configmap.yaml   
        sed -i -e "s%RABBITMQ_EXCHANGENAME_SED%${CX_RABBITMQ_EXCHANGENAME//&/\\&}%g" charts/charts_values/argo_flows/argo-events/gateways/amqp-gateway-configmap.yaml     
        cp -rf charts/charts_values/argo_flows/argo-events/gateways/amqp-org.yaml charts/charts_values/argo_flows/argo-events/gateways/amqp.yaml        
        sed -i -e "s%CLIENT_IMAGE_REPOSITORY_TAG_SED%${CX_ARGO_EVENTS_CLIENT_GATEWAY_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/gateways/amqp.yaml
        sed -i -e "s%GATEWAY_AMQP_IMAGE_REPOSITORY_TAG_SED%${CX_ARGO_EVENTS_GATEWAY_AMQP_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/gateways/amqp.yaml
        sed -i -e "s%IMAGE_VERSION_TAG_SED%${CX_ARGO_EVENTS_GATEWAY_VERSION//&/\\&}%g" charts/charts_values/argo_flows/argo-events/gateways/amqp.yaml
        cp -rf charts/charts_values/argo_flows/argo-events/gateways/webhook-http-org.yaml charts/charts_values/argo_flows/argo-events/gateways/webhook-http.yaml                
        sed -i -e "s%CLIENT_IMAGE_REPOSITORY_TAG_SED%${CX_ARGO_EVENTS_CLIENT_GATEWAY_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/gateways/webhook-http.yaml 
        sed -i -e "s%GATEWAY_WEBHOOK_IMAGE_REPOSITORY_TAG_SED%${CX_ARGO_EVENTS_GATEWAY_WEBHOOK_REPOSITORY//&/\\&}%g" charts/charts_values/argo_flows/argo-events/gateways/webhook-http.yaml         
        sed -i -e "s%IMAGE_VERSION_TAG_SED%${CX_ARGO_EVENTS_GATEWAY_VERSION//&/\\&}%g" charts/charts_values/argo_flows/argo-events/gateways/webhook-http.yaml 
        # Argo minio secret (minio resides in namespace for Argo deployment)        
        additional_installs+=( "kubectl create secret generic cx-argo-minio --from-literal=accesskey=${CX_MINIO_CONFIG_CI_INIT_ADMIN} --from-literal=secretkey=${CX_MINIO_CONFIG_CI_INIT_PASSWORD} -n ${K8S_NAMESPACE}" )
        additional_installs+=( "kubectl create secret generic cx-artifactory-credentials --from-literal=username=admin --from-literal=password=password -n ${K8S_NAMESPACE}" )
        additional_installs+=( "kubectl create secret generic cx-image-registry-credentials-argo --from-literal=username=${CX_IMAGE_REPOSITORY_ARGO_K8S_SECRET_USER} --from-literal=password=${CX_IMAGE_REPOSITORY_ARGO_K8S_SECRET_PSW} -n ${K8S_NAMESPACE}" )       
        # Argo-Events install
        additional_installs+=( "kubectl create serviceaccount --namespace ${K8S_NAMESPACE} argo-events-sa" )
        additional_installs+=( "kubectl create clusterrolebinding argo-events-binding-${K8S_NAMESPACE} --clusterrole=argo-events-role --serviceaccount=${K8S_NAMESPACE}:argo-events-sa" )   
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/deploy/argo-events-cluster-roles.yaml" )        
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/deploy/sensor-crd.yaml" )
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/deploy/gateway-crd.yaml" )
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/deploy/sensor-controller-configmap.yaml" )
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/deploy/sensor-controller-deployment.yaml" )
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/deploy/gateway-controller-configmap.yaml" )
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/deploy/gateway-controller-deployment.yaml" )              
        # Argo-Events Install Sensors & Gateways
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/argo-events/gateways/amqp-gateway-configmap.yaml" )
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/argo-events/gateways/amqp.yaml" )       
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/argo-events/gateways/webhook-gateway-configmap.yaml" )
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/argo-events/gateways/webhook-http.yaml" )
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ei-subscription-ms-frontend.yaml" )   
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/argo-events/sensors/sensor-ci-flow-amqp-triggered-ms-backend.yaml" )
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/argo-events/sensors/sensor-generate-eiffel-event-ms-backend.yaml" ) 
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/argo-events/sensors/sensor-webhook-deployment-update-ms-frontend.yaml" )     
        #################################################################################################
        ####################  REMOVALS ################################################################## 
        # Removal Argo minio secret (minio resides in namespace for Argo deployment)        
        additional_removals+=( "kubectl delete secret cx-argo-minio -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete secret cx-artifactory-credentials -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete secret cx-image-registry-credentials-argo -n ${K8S_NAMESPACE}" )       
        # Gerrit User Credentials (used in workflows to set gerrit review "Verified +1/-1")
        additional_removals+=( "kubectl delete secret easy2use-gerrit-credentials -n ${K8S_NAMESPACE}" )      
        # Delete Argo-Events Gateways, Sensors & configMaps               
        additional_removals+=( "kubectl delete Sensor -n ${K8S_NAMESPACE} sensor-ci-flow-amqp-upload-ei-subscription-ms-frontend" )
        additional_removals+=( "kubectl delete Sensor -n ${K8S_NAMESPACE} sensor-ci-flow-amqp-triggered-ms-backend" )
        additional_removals+=( "kubectl delete Sensor -n ${K8S_NAMESPACE} webhook-sensor-http-gen-eiffelevent-ms-backend" )
        additional_removals+=( "kubectl delete Sensor -n ${K8S_NAMESPACE} webhook-sensor-http-deployment-update-ms-frontend" )      
        additional_removals+=( "kubectl delete ConfigMap -n ${K8S_NAMESPACE} amqp-gateway-configmap" )
        additional_removals+=( "kubectl delete ConfigMap -n ${K8S_NAMESPACE} webhook-gateway-configmap" )    
        additional_removals+=( "kubectl delete Gateway -n ${K8S_NAMESPACE} amqp-gateway" ) 
        additional_removals+=( "kubectl delete Gateway -n ${K8S_NAMESPACE} webhook-gateway-http" )    
        # Delete Argo-Events delete        
        additional_removals+=( "kubectl delete ServiceAccount argo-events-sa -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete ClusterRoleBinding argo-events-binding-${K8S_NAMESPACE} -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete ConfigMap sensor-controller-configmap -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete Deployment sensor-controller -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete ConfigMap gateway-controller-configmap -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete Deployment gateway-controller -n ${K8S_NAMESPACE}" )
         ## OBS Do not remove CRD sensors.argoproj.io & gateways.argoproj.io, any Argo-events deployments in other namespaces will stop working
             ##  additional_removals+=( "kubectl delete CustomResourceDefinition sensors.argoproj.io -n ${K8S_NAMESPACE}" )
             ##  additional_removals+=( "kubectl delete CustomResourceDefinition gateways.argoproj.io -n ${K8S_NAMESPACE}" )

        local releasename="null"
        local settings=""
        local valuefile=""
        local chart="" 
        ;; 



      cx_argocd)  

        # Additional removals     
        additional_removals+=( "kubectl delete Application ms-backend-dev -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete Application ms-backend-stage -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete Application ms-backend-prod -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete Application ms-frontend-dev -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete Application ms-frontend-stage -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete Application ms-frontend-prod -n ${K8S_NAMESPACE}" )
        #kubectl patch crd/applications.argoproj.io -p '{"metadata":{"finalizers":[]}}' --type=merge
        #kubectl delete crd applications.argoproj.io
        #additional_removals+=( "kubectl patch crd/applications.argoproj.io -p '{\"metadata\":{\"finalizers\":[]}}' --type=merge" )
        additional_removals+=( "kubectl delete customresourcedefinitions applications.argoproj.io" )
        additional_removals+=( "kubectl delete customresourcedefinitions applications.argoproj.io -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete customresourcedefinitions appprojects.argoproj.io -n ${K8S_NAMESPACE}" )   
        
        local releasename="$K8S_RELEASE_CX_ARGOCD"
        local settings=(
          applicationController.image.repository="$CX_ARGOCD_APPLICATIONCONTROLLER_IMAGE_REPOSITORY"
          applicationController.image.tag="$CX_ARGOCD_APPLICATIONCONTROLLER_IMAGE_VERSION"          
          server.image.repository="$CX_ARGOCD_SERVER_IMAGE_REPOSITORY"
          server.image.tag="$CX_ARGOCD_SERVER_IMAGE_VERSION"
          server.uiInitImage.repository="$CX_ARGOCD_UIINIT_IMAGE_REPOSITORY"          
          server.uiInitImage.tag="$CX_ARGOCD_UIINIT_IMAGE_VERSION"          
          repoServer.image.repository="$CX_ARGOCD_REPOSERVER_IMAGE_REPOSITORY"
          repoServer.image.tag="$CX_ARGOCD_REPOSERVER_IMAGE_VERSION"
          dexServer.image.repository="$CX_ARGOCD_DEXSERVER_IMAGE_REPOSITORY"
          dexServer.image.tag="$CX_ARGOCD_DEXSERVER_IMAGE_VERSION"
          dexServer.initImage.repository="$CX_ARGOCD_DEXSERVERINIT_IMAGE_REPOSITORY"
          dexServer.initImage.tag="$CX_ARGOCD_DEXSERVERINIT_IMAGE_VERSION"
          ingress.enabled="true"
          ingress.hosts={"$K8S_INGRESS_CX_ARGOCD"}
          config.url="https://${K8S_INGRESS_CX_ARGOCD}"         
        )
        local valuefile="charts/charts_values/cx-argo-cd-values.yaml"
        local chart="charts/argo-cd-0.2.1.tgz"       
        ;;


      cx_argo_rollout)  
        # Argo rollout Installs   
        additional_installs+=( "kubectl apply -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/deploy/argo-rollout.yaml" )        

        # Argo rollout Removals     
        additional_removals+=( "kubectl delete -n ${K8S_NAMESPACE} -f charts/charts_values/argo_flows/deploy/argo-rollout.yaml" )
        
        local releasename="null"
        local settings=""
        local valuefile=""
        local chart="" 
        ;;  



      cx_minio)
        
        local releasename="$K8S_RELEASE_CX_MINIO"
        local settings=(              
          image.repository="$CX_MINIO_IMAGE_REPOSITORY"
          image.tag="$CX_MINIO_IMAGE_VERSION"
          mcImage.repository="$CX_MINIO_MC_IMAGE_REPOSITORY"         
          mcImage.tag="$CX_MINIO_MC_IMAGE_VERSION"
          accessKey="$CX_MINIO_CONFIG_CI_INIT_ADMIN"
          secretKey="$CX_MINIO_CONFIG_CI_INIT_PASSWORD"
          buckets[0].name="$CX_ARGO_MINIO_BUCKET"
          buckets[0].policy="none"
          buckets[0].purge="false"
          buckets[1].name="$CX_HELM_CHARTS_MINIO_BUCKET"
          buckets[1].policy="none"
          buckets[1].purge="false"
          ingress.enabled="true"
          ingress.hosts={"$K8S_INGRESS_CX_MINIO"}         
        )
        local valuefile="charts/charts_values/cx-minio-values.yaml"
        local chart="charts/minio-2.4.12.tgz"       
        ;;



      cx_chartmuseum)
        
        local releasename="$K8S_RELEASE_CX_CHARTMUSEUM"
        local settings=(         
          image.repository="$CX_CHARTMUSEUM_IMAGE_REPOSITORY"
          image.tag="$CX_CHARTMUSEUM_IMAGE_VERSION"
          env.open.STORAGE="amazon"
          env.open.STORAGE_AMAZON_BUCKET="charts"
          env.open.STORAGE_AMAZON_ENDPOINT="http://${CX_MINIO}.${K8S_NAMESPACE}:${CX_MINIO_EXTERNAL_PORT}"
          env.open.DISABLE_API="false"
          env.open.DEBUG="false"
          ingress.enabled="true"
          ingress.hosts[0].name="$K8S_INGRESS_CX_CHARTMUSEUM"
          ingress.hosts[0].path="/"
          ingress.hosts[0].tls="false"
          env.secret.AWS_ACCESS_KEY_ID="$CX_MINIO_CONFIG_CI_INIT_ADMIN"
          env.secret.AWS_SECRET_ACCESS_KEY="$CX_MINIO_CONFIG_CI_INIT_PASSWORD"                    
        )
        local valuefile="charts/charts_values/cx-chartmuseum-values.yaml"        
        local chart="charts/chartmuseum-2.2.0.tgz"    
        ;;     



      cx_gerrit)
        local releasename="$K8S_RELEASE_CX_GERRIT"
        local settings=(
          image.registry="$CX_GERRIT_IMAGE_REGISTRY"
          image.repository="$CX_GERRIT_IMAGE_REPOSITORY"
          image.tag="$CX_GERRIT_VERSION"
          eiffel2.configurationEnvironmentVars="$K8S_ENV_CONFIG_CX_GERRIT"
          ingress.hostName="$K8S_INGRESS_CX_GERRIT"
          ingress.enabled="$K8S_Ingress_Enabled"
          fullnameOverride="$K8S_RELEASE_CX_GERRIT"
          eiffel2.servicePort="$CX_GERRIT_EXTERNAL_PORT"
          eiffel2.containerPort="$CX_GERRIT_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/cx-gerrit-values.yaml"
        local chart="charts/eiffel2.tgz"
        ;;



      cx_artifactory)      
        additional_installs+=("kubectl create secret generic my-artifactory-credentials --from-literal=username=admin --from-literal=password=password -n ${K8S_NAMESPACE}")
        additional_removals+=("kubectl delete secret my-artifactory-credentials -n ${K8S_NAMESPACE}" )
        local releasename="$K8S_RELEASE_CX_ARTIFACTORY"
        local settings=(
          ingress.hosts={"$K8S_INGRESS_CX_ARTIFACTORY"}
          ingress.enabled="$K8S_Ingress_Enabled"
          artifactory.externalPort="$CX_ARTIFACTORY_EXTERNAL_PORT"
          artifactory.internalPort="$CX_ARTIFACTORY_INTERNAL_PORT"
        )
        local valuefile="charts/charts_values/cx-artifactory-values.yaml"
        local chart="charts/artifactory-7.8.4.tgz"
        ;;


      cx_jenkins)
        additional_installs+=( "kubectl create secret generic jenkins-credentials -n ${K8S_NAMESPACE} --from-file=credentials.xml=${CX_JENKINS_CONFIG_SECRETS_PATH}credentials.xml" )
        additional_installs+=( "kubectl create secret generic jenkins-secrets -n ${K8S_NAMESPACE} --from-file=hudson.util.Secret=${CX_JENKINS_CONFIG_SECRETS_PATH}hudson.util.Secret --from-file=master.key=${CX_JENKINS_CONFIG_SECRETS_PATH}master.key" )
        additional_removals+=( "kubectl delete secret jenkins-credentials -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete secret jenkins-secrets -n ${K8S_NAMESPACE}" )       
        local releasename="$K8S_RELEASE_CX_JENKINS"
        local settings=(
          Master.Image="$CX_JENKINS_IMAGE_REPOSITORY"
          Master.ImageTag="$CX_JENKINS_IMAGE_BUILD_VERSION"
          Master.HostName="$K8S_INGRESS_CX_JENKINS"          
          Master.AdminUser="$CX_JENKINS_CONFIG_CI_INIT_ADMIN"
          Master.AdminPassword="$CX_JENKINS_CONFIG_CI_INIT_PASSWORD"
          fullnameOverride="$K8S_RELEASE_CX_JENKINS"
          Master.ServicePort="$CX_JENKINS_EXTERNAL_PORT"
          Master.Jobs.ms-frontend="$K8S_CONFIG_CX_JENKINS_JOB_MS_FRONTEND"
          "Master.AdditionalConfig.gerrit-trigger\.xml"="$K8S_CONFIG_CX_JENKINS_GERRIT_TRIGGER_CONFIG"
          Master.AdditionalConfig.gerrit-id-rsa="$K8S_CONFIG_CX_JENKINS_GERRIT_ID_RSA"
        )
        local valuefile="charts/charts_values/cx-jenkins-values.yaml"
        local chart="charts/jenkins-0.25.0.tgz"        
        ;;
   
     
      cx_gerrit_postgres_configurations)
        local releasename="$K8S_RELEASE_CX_GERRIT_POSTGRES_CONFIG"
        local settings=(
          image.repository="$CX_GERRIT_POSTGRES_CONFIGURATIONS_IMAGE_REPOSITORY"
          image.tag="$CX_GERRIT_POSTGRES_CONFIGURATIONS_IMAGE_VERSION"
          configmap.configurationEnvironmentVars="$K8S_ENV_CONFIG_CX_GERRIT_POSTGRES_SEED"
          fullnameOverride="$K8S_RELEASE_CX_GERRIT_POSTGRES_CONFIG"
        )
        local valuefile="charts/charts_values/cx-gerrit-seed-values.yaml"
        local chart="charts/gerrit-seed.tgz"        
        ;;



      cx_keycloak)
        cp -rf charts/charts_values/keycloak_secrets/easy2use-all-org.json charts/charts_values/keycloak_secrets/easy2use-all.json
        sed -i -e "s%GERRIT_URL_SED%${K8S_INGRESS_CX_GERRIT//&/\\&}%g" charts/charts_values/keycloak_secrets/easy2use-all.json    
        additional_installs+=( "kubectl create secret generic realm-secret --from-file=charts/charts_values/keycloak_secrets/easy2use-all.json -n ${K8S_NAMESPACE}" )
        additional_removals+=( "kubectl delete secret realm-secret -n ${K8S_NAMESPACE}" )
        local releasename="$K8S_RELEASE_CX_KEYCLOAK"
        local settings=(
          keycloak.image.repository="$CX_KEYCLOAK_IMAGE_REPOSITORY"
          keycloak.image.tag="$CX_KEYCLOAK_VERSION"
          keycloak.ingress.hosts={"$K8S_INGRESS_CX_KEYCLOAK"}
          keycloak.ingress.enabled="$K8S_Ingress_Enabled"        
          keycloak.username="$CX_KEYCLOAK_CONFIG_CI_INIT_ADMIN"
          keycloak.password="$CX_KEYCLOAK_CONFIG_CI_INIT_PASSWORD"
          fullnameOverride="$K8S_RELEASE_CX_KEYCLOAK"
          postgresql.postgresUser="$CX_POSTGRES_USER"
          postgresql.postgresPassword="$CX_POSTGRES_PSW"
          postgresql.postgresDatabase="$CX_POSTGRES_REVIEWDB"
        )
        local valuefile="charts/charts_values/cx-keycloak-values.yaml"
        local chart="charts/keycloak-4.0.4.tgz"       
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
