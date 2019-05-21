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

GENERAL INFORMATION
-------------------

To provide a Cx bundle with pipeline as code setup which executes CI pipeline build steps in Docker containers to minimize state on CI server (Cattle principle).

The execution flow and docker containers used for the build steps will be re-used in included build engines Jenkins & Argo. Eiffel 2.0 events will be generated in build steps to log Cx execution activities.

Dependent Eiffel 2.0 services will be loaded from the Eiffel2 bundle to provide capability to log/vizualize pipeline activities via Eiffel 2.0 events.

GitOPS

Argo CD uses git repositories as the source of truth for the desired state of applications and the target deployment environments. 
Kubernetes manifests can be specified as YAML files, Kustomize & jsonnet applications or Helm packages. 
Argo CD automates the synchronization of the desired application state with each of the specified target environments.

Included Features
CI:
 - 2 Java Microservices included (ms-frontend & ms-backend)
 - CI Engines included with pipeline as code: Jenkins Pipeline (ms-frontend) & Argo CI (ms-backend)
 - Eiffel 2.0 event generated & CI triggered
 
CD:
 - GITOPS With Argo CD (automatically sync configuration in GIT repo with deployment in Kubernetes for specific branches : dev/stage/prod)
 - Promotion between DEV/STAGE/PROD is done by merging deployment GIT repo branches dev/stage/prod
 - Immutable Docker Images are used together with microservices config injection to configure microservices in the different K8S target environments
 - Eiffel Intelligence subscription uploaded via Argo CI pipeline build step
 - Eiffel Intelligence subscription is used to trigger deployment repo updates for microservice builds in Jenkins, when 
   Docker Image artifact is created, published and when confidence level set to "readyforintegration" 


The Cx bundle is only applicable for deployments in Kubernetes.


Bundle Name
-----------
Cx

Components included in Cx bundle
--------------------------------
- KeyCloak
- Postgresql (KeyCloak)
- Gerrit Server & Git
- Seeding Gerrit & KeyCloak (Postgresql)
- Jenkins (with Gerrit Trigger, Pipeline & Blueocean)
- Argo
- Argo-Events
- Argo CD
- Minio (S3 compatible storage)
- Chartmuseum

Dependent Components Included from Eiffel2 Bundle
- RabbitMQ (Message Bus)
- MongoDB  & Data Seeding 
- RemRem Generate
- RemRem Publish
- Event Repository REST API
- Eiffel-Vici
- Eiffel Intelligence artifact

Usage
-----

Prerequisite local K8S cluster
------------------------------

If running in local K8S cluster, minikube or docker-for-windows (windows 10 Hyper-v). Local K8S cluster configuration is required.

- Local K8S cluster (windows 10 Hyper-v) do:
  $  ./easy2use configure-local-k8s-hyper-v Cx -t Kubernetes

- Local K8S cluster (minikube) do:
  $  ./easy2use configure-local-k8s-minikube Cx -t Kubernetes

Start Cx Bundle
---------------

Argo can only be deployed once per cluster, bur Argo-events can be deployed in multiple namespaces in the same cluster.


Alt1) Deploy CX bundle with all components including Argo 


    $ ./easy2use start Cx -t Kubernetes -n <namespace> -d <basedomainname>

    basedomain name is the basedomainname for the K8S cluster, if using local k8s kluster use ex. mylocalkube.com

    OBS You need to answer Y twice, first for the Cx bundle installs and then the dependent services from the Eiffel2 bundle!

    Argo already installed if error printput is generated →   Easy2Use: Warning: Could not install additional installs: kubectl create serviceaccount --namespace kube-system argo, See Alt2 below!


Alt2) Deploy CX bundle with all components including Argo-Events and excluding Argo  
If Argo already implemented in K8S cluster. With this deployement Argo GUI/Artifactory  will be avaliable in namespace where Argo is deployed.
  

    $ ./easy2use start Cx -t Kubernetes -n <namespace> -d <basedomainname> -p min

    basedomain name is the basedomainname for the K8S cluster, if using local k8s kluster use ex. mylocalkube.com

    OBS You need to answer Y twice, first for the Cx bundle installs and then the dependent services from the Eiffel2 bundle!


List Service URLs
-----------------
EasyUse list command will both list URLs (ingresses) to the deployed K8S services and user/psw for the services.


$ ./easy2use list Cx -t Kubernetes -n <namespace>

   OBS For included Eiffel2 components do: 
        ./easy2use list Eiffel2 -t Kubernetes -n <namespace>


List HOSTS files entries for local K8S 
--------------------------------------

If you running the Cx bundle on a local K8S cluster, you need to update your ..etc/hosts file with ingresses. To print the ingresses to use do:

 - Local K8S cluster (windows 10 Hyper-v) do:

   $  ./easy2use  generate-local-hosts-file-hyper-v Cx -t Kubernetes

 - Local K8S cluster (minikube) do:

   $  ./easy2use  generate-local-hosts-file-minikube Cx -t Kubernetes


     Update your hosts file with the output from the printout!


      Linux:  /etc/hosts

      Windows: C:\Windows\System32\drivers\etc\hosts            (OBS you need to open cmd in Administrator mode!)


Remove Cx Bundle
----------------

Alt1) Deploy CX bundle with all components including Argo 
OBS Argo are a cluster global release, so it will be removed even if it's deployed in other namespace than specified in the Easy2Use cmd!


    $ ./easy2use remove Cx -t Kubernetes -n <namespace> 

    OBS You need to answer Y twice, first for the Cx bundle removals and then the dependent services from the Eiffel2 bundle!

Alt2) Deploy CX bundle with all components including Argo-Events and excluding Argo  
  

    $ ./easy2use remove Cx -t Kubernetes -n <namespace> -p min


    OBS You need to answer Y twice, first for the Cx bundle removals and then the dependent services from the Eiffel2 bundle!


    