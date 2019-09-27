<!---
   Copyright 2019 Ericsson AB.
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
# Cx Bundle

## Idea
To provide a Cx bundle with pipeline as code setup which executes CI pipeline build steps in Docker containers to minimize state on CI server (Cattle principle).

The execution flow and docker containers used for the build steps will be re-used in included build engines Jenkins & Argo. Eiffel events will be generated in build steps to log Cx execution activities.

Dependent Eiffel services will be loaded from the Eiffel bundle to provide capability to log/vizualize pipeline activities via Eiffel events.

### GitOPS

Argo CD uses git repositories as the source of truth for the desired state of applications and the target deployment environments. 
Kubernetes manifests can be specified as YAML files, Kustomize & jsonnet applications or Helm packages. 
Argo CD automates the synchronization of the desired application state with each of the specified target environments.

### Included Features
CI:
 - 2 Java Microservices included (ms-frontend & ms-backend)
 - CI Engines included with pipeline as code: Jenkins Pipeline (ms-frontend) & Argo CI (ms-backend)
 - Jenkins pipeline shared pipeline code
 - Pre & post-merge pipelines
 - Eiffel event generated & CI triggered
 
CD:
 - GITOPS With Argo CD (automatically sync configuration in GIT repo with deployment in Kubernetes for specific branches : dev/stage/prod)
 - Promotion between DEV/STAGE/PROD is done by merging deployment GIT repo branches dev/stage/prod
 - Immutable Docker Images are used together with microservices config injection to configure microservices in the different K8S target environments
 - Eiffel Intelligence subscription uploaded via Argo CI pipeline build step
 - Eiffel Intelligence subscription is used to trigger deployment repo updates for microservice builds in Jenkins, when 
   Docker Image artifact is created, published and when confidence level set to "readyforintegration" 


The Cx bundle is only applicable for deployments in Kubernetes.

## Bundle Name
The following name is used to refer to this bundle in the easy2use CLI:

Cx

## Components included in Cx bundle
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
Eiffel Vici | vici | N/A | eiffel-vici-\<namespace\>.\<domainname\>	

## Resource Requirements
OS | Minimum Requirements | Preferably | Comments
------------- | ------------ | -------- | ----
Windows 'Docker Toolbox' | ? | 24 GB RAM <br> 50 GB Disk? | This recommendation is valid when assigning 4 CPU cores to the Docker machine.<br>With less cores less memory would be consumed, but the performance will be worse. The assigned amount of RAM will be allocated to the Docker machine until it is stopped
Windows 'Docker for Windows' | ? |20 GB RAM? <br> 50 GB Disk? | The assigned amount of RAM is dynamically allocated and only used by the Docker machine when needed?
Linux | 8 GB RAM |16 GB RAM or more |	~11 GB of RAM will be use under the load. <br>When all containers is loaded, the memory usage is ~6 GB RAM. <br> Computer with 8 GB RAM works, but it will takes some more time to load <br>all containers due to swapping data between memory and hard drive. 

## Docker requirements
 - Docker 18.06 CE or newer
 - Docker-Compose 1.22 or newer

## Kubernetes requirements
 - Kubernetes cluster (local or remote)
 - Kubectl
 - Helm

## Dependencies
Eiffel bundle components

## Quick getting started guide with Easy2Use
See the getting starting page: Getting Started
[**Bundles**](./Getting_Started.md)

## Layout
This is a schematic picture of the environment:

<img src="./images/cx-components.png" alt="Eiffel Easy2Use" width="750"/>

## Principles
<img src="./images/cx-gitops-principles.png" alt="Eiffel Easy2Use Cx GitOPS principles" width="750"/>
<br><br>
<img src="./images/cx-pipelineascode-principles.png" alt="Eiffel Easy2Use Cx pipeline as code principles" width="750"/>
<br><br>
<img src="./images/cx-jenkins-pre-post-merge-principles.png" alt="Eiffel Easy2Use Cx Jenkins pre post merge pipeline principles" width="750">
<br><br>
<img src="./images/cx-argo-pre-post-merge-principles.png" alt="Eiffel Easy2Use Cx Argo CI pre post merge pipeline principles" width="750">
<br><br>
<img src="./images/cx-pipeline-events.png" alt="Eiffel Easy2Use Cx Eiffel Events Generated in CI pipelines" width="750">

## Usage
### Bundle Information
Print bundle information from Easy2Use CLI:
```
./easy2use info Cx
```

## Prerequisite local K8S cluster
If running in local K8S cluster, minikube or docker-for-windows (windows 10 Hyper-v). Local K8S cluster configuration is required.

  - Local K8S cluster (windows 10 Hyper-v) do:
  ```
  ./easy2use configure-local-k8s-hyper-v Cx -t Kubernetes
  ```
  - Local K8S cluster (minikube) do:
  ```
  ./easy2use configure-local-k8s-minikube Cx -t Kubernetes
  ```

## Prerequisite Docker Registry Configuration
In the easy2use root, create file:  <b>config-user.bash</b>

Info: this file is included in .gitignore!

Add the following lines in the file:

export CX_IMAGE_REGISTRY="\<imageregistry\>"       Example for Dockerhub add registry.hub.docker.com<br>
export CX_IMAGE_REPOSITORY="\<repository\>"        Example in Dockerhub your username<br>   
 
export CX_IMAGE_REPOSITORY_ARGO_K8S_SECRET_USER="\<UserName\>"       
export CX_IMAGE_REPOSITORY_ARGO_K8S_SECRET_PSW="\<Password\>"


## Start Cx Bundle
Argo can only be deployed once per cluster, but Argo-events can be deployed in multiple namespaces in the same cluster.

Note: the Gerrit server startup can take a few minutes (seeding etc), so be patient!

### Alt1) Deploy CX bundle with all components including Argo 

  ```
  ./easy2use start Cx -t Kubernetes -n <namespace> -d <basedomainname>
  ```
   basedomain name is the basedomainname for the K8S cluster, if using local k8s kluster use ex. mylocalkube.com

   OBS You need to answer "Y" twice, first for the Cx bundle installs and then the dependent services from the Eiffel bundle!

   Argo already installed if error printput is generated →   Easy2Use: Warning: Could not install additional installs: kubectl create serviceaccount --namespace kube-system argo, See Alt2 below!

### Alt2) Deploy CX bundle with all components including Argo-Events and excluding Argo  
If Argo already implemented in K8S cluster. With this deployment Argo GUI/Artifactory  will be avaliable in namespace where Argo is deployed.
  
  ```
  ./easy2use start Cx -t Kubernetes -n <namespace> -d <basedomainname> -p min
  ```
  basedomain name is the basedomainname for the K8S cluster, if using local k8s kluster use ex. mylocalkube.com

  OBS You need to answer "Y" twice, first for the Cx bundle installs and then the dependent services from the Eiffel bundle!

## List Service URLs, UserName & PSW
Easy2Use list command will both list URLs (ingresses) to the deployed K8S services and user/psw for the services.
  
  ```
  ./easy2use list Cx -t Kubernetes -n <namespace>
  ```


  OBS For included Eiffel components do: 
  ```
  ./easy2use list Eiffel -t Kubernetes -n <namespace>
  ```

## List HOSTS files entries for local K8S 
If you running the Cx bundle on a local K8S cluster, you need to update your ..etc/hosts file with ingresses. To print the ingresses to use do:


- Local K8S cluster (windows 10 Hyper-v) do:
  ```
  ./easy2use  generate-local-hosts-file-hyper-v Cx -t Kubernetes
  ```

- Local K8S cluster (minikube) do:
  ```
  ./easy2use  generate-local-hosts-file-minikube Cx -t Kubernetes
  ```

 Update your hosts file with the output from the printout!

 - Linux:  /etc/hosts
 - Windows: C:\Windows\System32\drivers\etc\hosts            (OBS you need to open cmd in Administrator mode!)

## Remove Cx Bundle

The deployed applications ms-frontend & ms-backend (Argo-CD) will not be removed via Easy2Use CLI.
Remove the applications in the Argo-CD GUI before executing the Easy2Use remove cmd!

### Alt1) Remove CX bundle with all components including Argo 
OBS Argo are a cluster global release, so it will be removed even if it's deployed in other namespace than specified in the Easy2Use cmd!

  ```
  ./easy2use remove Cx -t Kubernetes -n <namespace> 
  ```

  OBS You need to answer "Y" twice, first for the Cx bundle removals and then the dependent services from the Eiffel bundle!

### Alt2) Remove CX bundle with all components including Argo-Events and excluding Argo  
  
  ```
  ./easy2use remove Cx -t Kubernetes -n <namespace> -p min
  ```

  OBS You need to answer "Y" twice, first for the Cx bundle removals and then the dependent services from the Eiffel bundle!

### Additional removals
Sometimes the Argo CRD is not removed successfully, to remove it execute: 
  ```
  kubectl patch crd/applications.argoproj.io -p '{"metadata":{"finalizers":[]}}' --type=merge
  kubectl delete crd applications.argoproj.io
  ```

## Jenkins
Included microservice "ms-frontend" in the Gerrit Git repo will be handled Jenkins pre & post-merge pipelines

The source code repo includes the Jenkinsfile describing the pipelines which will use the shared Jenkins pipeline code in Gerrit/Git

### 1. Update Image registry Credentials

 - Login to Jenkins  (admin/admin)
 - Click Credentials
 - For credentials id =  IMAGE_REGISTRY_CREDENTIALS, click Name column
 - Click Update
 - Enter Username/Password for your image registry (i.e same as defined in file config-user.bash)

### 2. Trigger Predefined Jenkins jobs
Pipeline Execution: pre-merge Jenkins pipeline

Clone gerrit repo: ms-frontend:

 - Logon to Gerrit server: cx-gerrit-\<namespace\>.\<domainname\>
 - Click Sign In
 - User/Psw: easy2use/password123
 - Choose Projects/List
 - Click ms-frontend
 - Click General tab
 - Click http & copy clone address 
   - git clone http://easy2use@cx-gerrit-<namespace\>.\<yourdomainname\>/a/ms-frontend.git
 - Open terminal (ex git bash or similar)
 - Parse git clone cmd

#### 2.1. Update local git repo & push patchset for review
 - cd ms-frontend
 - Do some changes do your local ms-frontend git repo
 - commit and push changes
 - git add .
 - git commit -m "msfrontendchanges"
 - git push origin HEAD:refs/for/master

If user/psw dialog pops up, then enter: 
- User: easy2use
- Psw: gX6aUy55fjSgJfldDItW2WiCpoiid+2tK9FyqayQlg

Check your pushed patchset
- Open Gerrit cx-gerrit-\<namespace\>.\<domainname\>
  - Click Sign In
  - User/Psw: easy2use/password123
- Chose My/Changes
- Click "msfrontendchanges"

#### 2.2. Check started Jenkins ms-frontend job, pre-merge triggered via git push to Gerri (Gerrit Trigger)
- Logon to Jenkins: cx-jenkins-\<namespace\>.\<domainname\>
  - User/Psw: admin/admin
- Click "Blueocean"
- Click ms-frontend to see pre-merge pipeline execution
- After successful execution, the pipeline will update Gerrit "Verified" to +1 (else -1 if error in pipeline)


#### 2.3. Pipeline Execution: post-merge Jenkins pipeline
- Logon to Gerrit server: cx-gerrit-\<namespace\>.\<domainname\>
  - Click Sign In
  - User/Psw: easy2use/password123
- Chose My/Changes
- Click "msfrontendchanges"
- Check that "Verified" is set to +1
- Set Review to +2
- Click submit button


#### 2.4. Check started Jenkins ms-frontend job, post-merge triggered via Gerrit merge (Gerrit Trigger)
- Logon to Jenkins: cx-jenkins-\<namespace\>.\<domainname\>
  - User/Psw: admin/admin
- Click "Blueocean"
- Click ms-frontend to see post-merge pipeline execution

### 3. Eiffel Events Generated in Jenkins Pipelines
- Eiffel Vici: eiffel-vici-\<namespace\>.\<domainname\>
- Instruction TBD XXXXX


### 4. Check deployed ms-frontend Microservice in Argo-CD
 - Goto: cx-argocd-\<namespace\>.\<domainname\>
 - Username: admin
 - Password: get psw with -> ./easy2use list Cx -n \<namespace\>


### 5. Communicate with ms-frontend microservice in dev/stage/prod

Deployed microservices will be visible in printout from cmd:
```
./easy2use list Cx -n <namespace>
```

#### 5.1 ms-frontend & ms-backend
  - dev
    - ms-frontend-dev-\<namespace\>.\<domainname\>/api/greeting
    - ms-backend-dev-\<namespace\>.\<domainname\>/api/hellobackend
  - stage
    - ms-frontend-stage-\<namespace\>.\<domainname\>/api/greeting
    - ms-backend-stage-\<namespace\>.\<domainname\>/api/hellobackend       Info: 2 replicas created<br>
  - prod (master)
    - ms-frontend-prod-\<namespace\>.\<domainname\>/api/greeting
    - ms-backend-prod-\<namespace\>.\<domainname\>/api/hellobackend        Info: 3 replicas created<br>

### 6. Promotion
After the initial patchset merge (submit) in Gerrit all Branches dev/stage/prod (master) will have the same versions
which Argo-CD synced to K8S.

Now promotion can be performed by merging dev -> stage -> master (prod)

Perform another update in ms-frontend and push patchset it for review, follow steps 2.1-2.3 again.

Now the new patchset is merged (submitted) to dev branch, and synced via Argo-CD in K8S.

#### 6.1 Promote ms-fontend dev to stage
Deploy to stage, merge dev to stage.

```
 git pull origin dev
 git checkout stage
 git pull origin stage
 git merge dev
 git push origin stage
```
Now Argo-CD will sync the new changes in the stage branch. Also check steps 4-5.


#### 6.2 Promote ms-fontend stage to prod (master)
Deploy to Prod, merge stage to master prod.

```
 git pull origin stage
 git checkout master
 git pull origin master
 git merge stage
 git push origin master
```
Now Argo-CD will sync the new changes in the master (prod) branch. Also check steps 4-5.


## Argo CI

### Argo pipeline
Included microservice "ms-backend" in the Gerrit Git repo will be handled in Argo pre & post-merge pipelines

### 1. Trigger Argo pipeline (Workflow)
Clone gerrit repo: ms-backend:

 - Logon to Gerrit server: cx-argo-\<namespace\>.\<domainname\>
 - Click Sign In
 - User/Psw: easy2use/password123
 - Choose Projects/List
 - Click ms-backend
 - Click General tab
 - Click http & copy clone address 
   - git clone http://easy2use@cx-gerrit-\<namespace\>.\<yourdomainname\>/a/ms-backend.git
 - Open terminal (ex git bash or similar)
 - Parse git clone cmd


#### 1.1. Update local git repo & push patchset for review
 - cd ms-frontend
 - Do some changes do your local ms-backend git repo
 - commit and push changes
 - git add .
 - git commit -m "msbackendchanges"
 - git push origin HEAD:refs/for/master

If user/psw dialog pops up, then enter: 
- User: easy2use
- Psw: gX6aUy55fjSgJfldDItW2WiCpoiid+2tK9FyqayQlg

Check your pushed patchset
- Open Gerrit cx-gerrit-\<namespace\>.\<domainname\>
  - Click Sign In
  - User/Psw: easy2use/password123
- Chose My/Changes
- Click "msbackendchanges"

#### 1.2. Check Workflows Execution (Triggered via Eiffel event SCC)
- cx-argo-<namespace>.<domainname>
- Click on workflows icon on the left manu
- After successful execution, the pipeline will update Gerrit "Verified" to +1 (else -1 if error in pipeline)


#### 1.3. Pipeline Execution: post-merge Argo pipeline 
- Logon to Gerrit server: cx-gerrit-\<namespace\>.\<domainname\>
   - Click Sign In
   - User/Psw: easy2use/password123
- Chose My/Changes
- Click "msbackendchanges"
- Check that "Verified" is set to +1
- Set Review to +2
- Click submit button

#### 1.4. Check Workflows Execution (Triggered via Eiffel event SCC)
- cx-argo-\<namespace\>.\<domainname\>
- Click on workflows icon on the left manu

### 2. Eiffel Events Generated in Jenkins Pipelines
- Eiffel Vici: eiffel-vici-\<namespace\>.\<domainname\>
- Instruction TBD XXXXX


### 3. Check deployed ms-frontend Microservice in Argo-CD
 - Goto: cx-argocd-\<namespace\>.\<domainname\>
 - Username: admin
 - Password: get psw with -> ./easy2use list Cx -n \<namespace\>


### 4. Communicate with ms-frontend microservice in dev/stage/prod

Deployed microservices will be visible in printout from cmd:
```
./easy2use list Cx -n <namespace>
```

#### 4.1 ms-frontend & ms-backend
  - dev
    - ms-frontend-dev-\<namespace\>.\<domainname\>/api/greeting
    - ms-backend-dev-\<namespace\>.\<domainname\>/api/hellobackend
  - stage
    - ms-frontend-stage-\<namespace\>.\<domainname\>/api/greeting
    - ms-backend-stage-\<namespace\>.\<domainname\>/api/hellobackend       Info: 2 replicas created<br>
  - prod (master)
    - ms-frontend-prod-\<namespace\>.\<domainname\>/api/greeting
    - ms-backend-prod-\<namespace\>.\<domainname\>/api/hellobackend        Info: 3 replicas created<br>

### 5. Promotion
After the initial patchset merge (submit) in Gerrit all Branches dev/stage/prod (master) will have the same versions
which Argo-CD synced to K8S.

Now promotion can be performed by merging dev -> stage -> master (prod)

Perform another update in ms-frontend and push patchset it for review, follow steps 1.1-1.3 again.

Now the new patchset is merged (submitted) to dev branch, and synced via Argo-CD in K8S.

#### 5.1. Promote ms-fontend dev to stage
Deploy to stage, merge dev to stage.

```
 git pull origin dev
 git checkout stage
 git pull origin stage
 git merge dev
 git push origin stage
```
Now Argo-CD will sync the new changes in the stage branch. Also check steps 3-4.


#### 5.2. Promote ms-fontend stage to prod (master)
Deploy to Prod, merge stage to master prod.

```
 git pull origin stage
 git checkout master
 git pull origin master
 git merge stage
 git push origin master
```
Now Argo-CD will sync the new changes in the master (prod) branch. Also check steps 3-4.


## Known Issues
[**Easy2Use Issues**](https://github.com/eiffel-community/eiffel-easy2use/issues)
