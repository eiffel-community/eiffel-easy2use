<!---
   Copyright 2020 Ericsson AB.
   For a full list of individual contributors, please see the commit history.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

# Components Included in Cx Bundle

Component | Service name | User/PSW | Ingress | Info
------------- | ------------ | -------- | ------- | ------------
KeyCloak | cx_keycloak | admin/admin | cx-keycloak-\<namespace\>.\<domainname\> | KeyCloak is used for Gerrit authentication
Postgresql (KeyCloak) | N/A | keycloak/password | N/A | Deployed in KeyCloak HELM chart |
Gerrit Server & Git | cx_gerrit | easy2use/password123<br><br>OBS when pushing changes to Gerrit use:<br> PSW: gX6aUy55fjSgJfldDItW2WiCpoiid+2tK9FyqayQlg | cx-gerrit-\<namespace\>.\<domainname\> | Git repos included at startup:<br><br>- eiffel-jenkins-pipeline-shared (Jenkins shared pipeline code)<br>- ms-frontend (Java proj.)<br>- ms-backend (Java proj.)<br><br>GitOPS Argo CD config repo:<br>- deployment with 3 branches dev/stage/prod (master) |
Seeding Gerrit & KeyCloak (Postgresql) | cx_gerrit_postgres_configurations | N/A | N/A | Seed service configuring:<br>- Gerrit Trigger plugin added<br>- Gerrit webhook plugin  added<br>- Gerrit admin user SSH key<br>- Gerrit admin user in KeyCloak (Postgresql)<br><br>Gerrit Git repos:<br>- eiffel-jenkins-pipeline-shared<br>- ms-frontend (Java proj.)<br>- ms-backend (Java proj.) Config for Gerrit webhook added
Jenkins (with Gerrit Trigger, Pipeline & Blueocean) | cx_jenkins | admin / admin | cx-jenkins-\<namespace\>.\<domainname\> | 1 Pipeline as code job included at startup<br> - ms-frontend<br><br>Seeding:<br>Gerrit Trigger plugin config:<br>- Gerrit admin user SSH private key
Argo | cx_argo | N/A |cx-argo.\<domainname\><br><br>OBS cluster global release name.<br>Meaning that it can be removed via Easy2Use remove in any namespaces with Easy2Use CLI remove command! | Obs Argo is deployed per cluster.<br>So all Argo-events in other namespaces will use Argo UI and Artifactory in the Argo namespace.<br>If Argo already exist in your cluster, and you want to run Argo-event workflows fom another namespace use package "min" when deploying.
Argo-Events | cx_argo_events | N/A | N/A | 2 Argo Gateways & 2 Sensors included at startup<br><br><b>Gateways:</b><br>- webhook-gateway-http<br>- amqp-gateway<br><br><b>Sensors (CI workflows and triggers):</b><br>- sensor-ci-flow-amqp-upload-ei-subscription-ms-frontend<br>- sensor-ci-flow-amqp-triggered-ms-backend<br>- webhook-sensor-http-gen-eiffelevent-ms-backend<br>- webhook-sensor-http-deployment-update-ms-frontend
Argo CD | cx_argocd | user: admin<br> psw: Argo-CD pod name, use:<br>./easy2use list Cx -n \<namespace\> |cx-argocd-\<namespace\>.\<domainname\> | GitOPS<br> Check for updates in Gerrit GIT repo deployment for branches dev/stage/master, and will automatically sync deployments in K8S.<br><br> Deployments are performed in the choosen namespace but the ms-frontend and ms-backend will exist for each environment -> stage/dev/prod (master)
Minio (S3 compatible storage) | N/A | AccessKey:<br>AKIAIOSFODNN7EXAMPLE<br>SecretKey:<br>wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY | cx-minio-\<namespace\>.\<domainname\> | Minio is used for sharing Artifacts between build steps in Argo workflows and also storing Helm charts via chartmuseum<br><br>Minio is a high performance distributed object storage server, designed for<br>large-scale private cloud infrastructure.
Artifactory (JFrog) | cx_artifactory | admin/password | cx-artifactory-\<namespace\>.\<domainname\> | Artifactory is used for storing compiled artifacts (war files for Java projs. in Gerrit)
<b>Services Loaded from Eiffel Bundle*</b> | | |
RabbitMQ (Message Bus) | rabbitmq | myuser / myuser | eiffel-rabbitmq-\<namespace\>.\<domainname\>
MongoDB & Data Seeding | mongodb<br> mongo_seed | N/A | N/A | The seed-data folder in Easy2Use contains data that can be seeded into the MongoDB instance.
RemRem Generate | remrem_generate | N/A | eiffel-remrem-generate-\<namespace\>.\<domainname\>
RemRem Publish | remrem_publish | N/A | eiffel-remrem-publish-\<namespace\>.\<domainname\>
Event Repository REST API | er | N/A | eiffel-er-\<namespace\>.\<domainname\>
