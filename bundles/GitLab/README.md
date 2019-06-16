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

To provide a GitLab bundle with CI/CD pipeline as code setup which executes CI/CD pipeline build steps in Docker containers.

Dependent Eiffel services will be loaded from the Eiffel bundle to provide capability to log/vizualize pipeline activities via Eiffel events.


### Included Features
CI:
 - 2 Java Microservices to be imported (ms-frontend & ms-backend) with .gitlab-ci.yml files
   - https://github.com/eiffelci/eiffel-ms-frontend-ci-test.git
   - https://github.com/eiffelci/eiffel-ms-backend-ci-test.git
 - GitLab CI engine with pipeline as code (ms-frontend & ms-backend)
 - Pre & post-merge pipelines
 - Eiffel event generated
 
CD:
 - CD Pipelines with kubectl deployment via HELM templates, helm charts included in ms-frontend & ms-backend
 - Pre-merge CD pipeline (merge request) deployement to dev
 - Post-merge CD pipeline (merge request) deployement to stage
 - Deployment to production is triggered via manually decision in GiLab GUI
 - Immutable Docker Images are used together with microservices config injection to configure microservices in the different K8S target environments


The GitLab bundle is only applicable for deployments in Kubernetes.


Bundle Name
-----------
GitLab

Components included in Cx bundle
--------------------------------
- GitLab

Dependent Components Included from Eiffel2 Bundle
- RabbitMQ (Message Bus)
- MongoDB  & Data Seeding 
- RemRem Generate
- RemRem Publish
- Nexus3
- Event Repository REST API
- Eiffel-Vici
- Eiffel Intelligence artifact

Usage
-----

Prerequisite local K8S cluster
------------------------------

If running in local K8S cluster, minikube or docker-for-windows (windows 10 Hyper-v). Local K8S cluster configuration is required.

- Local K8S cluster (windows 10 Hyper-v) do:
  $  ./easy2use configure-local-k8s-hyper-v GitLab -t Kubernetes

- Local K8S cluster (minikube) do:
  $  ./easy2use configure-local-k8s-minikube GitLab -t Kubernetes

Start GitLab Bundle
---------------

Gitlab can only be deployed once per cluster (one ingress used).

Note: the GitLab startup can take a few minutes, so be patient


    $ ./easy2use start GitLab -t Kubernetes -n <namespace> -d <basedomainname>

    basedomain name is the basedomainname for the K8S cluster, if using local k8s kluster use ex. mylocalkube.com

    OBS You need to answer Y twice, first for the Cx bundle installs and then the dependent services from the Eiffel2 bundle!

 
List Service URLs
-----------------
EasyUse list command will both list URLs (ingresses) to the deployed K8S services and user/psw for the services.


$ ./easy2use list GitLab -t Kubernetes -n <namespace>

   OBS For included Eiffel components do: 
        ./easy2use list Eiffel -t Kubernetes -n <namespace>


List HOSTS files entries for local K8S 
--------------------------------------

If you running the Cx bundle on a local K8S cluster, you need to update your ..etc/hosts file with ingresses. To print the ingresses to use do:

 - Local K8S cluster (windows 10 Hyper-v) do:

   $  ./easy2use generate-local-hosts-file-hyper-v GitLab -t Kubernetes

 - Local K8S cluster (minikube) do:

   $  ./easy2use generate-local-hosts-file-minikube GitLab -t Kubernetes


     Update your hosts file with the output from the printout!


      Linux:  /etc/hosts

      Windows: C:\Windows\System32\drivers\etc\hosts            (OBS you need to open cmd in Administrator mode!)


Remove GitLab Bundle
--------------------

     $ ./easy2use remove Cx -t Kubernetes -n <namespace> 

    OBS You need to answer Y twice, first for the Cx bundle removals and then the dependent services from the Eiffel2 bundle!




    