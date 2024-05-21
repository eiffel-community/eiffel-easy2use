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
# Cx Bundle

* [Bundle Concept](#bundle-concept)
* [Prerequisites](#prerequisites)
* [Included Components](#included-components)
* [Usage](#usage)
* [Tutorial for Bundle](#tutorial-for-bundle)

## Bundle Concept

This bundle provides a Cx (_Continuous integration/delivery/deployment etc_)
environment with a "pipeline as code" setup. The build steps are executed in
Docker containers to minimize state on the CI server (Cattle principle).

The bundle contains two build engines: Jenkins and Argo. The pipelines, and
Docker containers used for the build steps, will be re-used in both Jenkins and Argo.
Eiffel events will be generated in build steps to log pipeline activities.

Dependent Eiffel services will be loaded from the Easy2Use Eiffel bundle to provide
capability to log/visualize pipeline activities via Eiffel events.

GitOPS

Argo CD uses git repositories as the source of truth for the desired state of
applications and the target deployment environments. Kubernetes manifests can be
specified as YAML files, Kustomize & jsonnet applications or Helm packages. Argo CD
automates the synchronization of the desired application state with each of the
specified target environments.

Included Features
CI:
 - 2 Java Microservices included (ms-frontend & ms-backend)
 - CI Engines included with pipeline as code: Jenkins Pipeline (ms-frontend) & Argo CI (ms-backend)
 - Eiffel events generated & CI triggered

CD:
 - GITOPS with Argo CD (automatically sync configuration in GIT repo with deployment in Kubernetes for specific branches : dev/stage/prod)
 - Promotion between DEV/STAGE/PROD is done by merging deployment GIT repo branches dev/stage/prod
 - Immutable Docker images are used together with microservices config injection to configure microservices in the different K8S target environments
 - Eiffel Intelligence subscription uploaded via Argo CI pipeline build step
 - Eiffel Intelligence subscription is used to trigger deployment repository updates for
   microservice builds in Jenkins, when Docker image artifact is created, published and it reaches confidence level: "readyforintegration"

### Bundle Name
The following name is used to refer to this bundle in the easy2use CLI:

Cx

### Dependencies
Eiffel bundle components (started automatically)

### Supported Target Environment
The Easy2Use Cx bundle is only applicable for deployments in Kubernetes.

### Resource Requirements
OS | Minimum Requirements | Preferably | Comments
------------- | ------------ | -------- | ----
Windows 'Docker Toolbox' | ? | 24 GB RAM <br> 50 GB Disk? | This recommendation is valid when assigning 4 CPU cores to the Docker machine.<br>With less cores less memory would be consumed, but the performance will be worse. The assigned amount of RAM will be allocated to the Docker machine until it is stopped
Windows 'Docker for Windows' | ? |20 GB RAM? <br> 50 GB Disk? | The assigned amount of RAM is dynamically allocated and only used by the Docker machine when needed?
Linux | 8 GB RAM |16 GB RAM or more |	~11 GB of RAM will be use under the load. <br>When all containers is loaded, the memory usage is ~6 GB RAM. <br> Computer with 8 GB RAM works, but it will takes some more time to load <br>all containers due to swapping data between memory and hard drive.

#### Docker Requirements
 - Docker 18.06 CE or newer
 - Docker-Compose 1.22 or newer

#### Kubernetes Requirements
 - Kubernetes cluster (local or remote)
 - Kubectl
 - Helm

## Prerequisites

### Local K8S Cluster
If running in local K8S cluster, minikube or docker-for-windows (windows 10 Hyper-v). Local K8S cluster configuration is required.

- Local K8S cluster (windows 10 Hyper-v) do:
    ```
    ./easy2use configure-local-k8s-hyper-v Cx -t Kubernetes
    ```
- Local K8S cluster (minikube) do:
    ```
    ./easy2use configure-local-k8s-minikube Cx -t Kubernetes
    ```

### Docker Registry Configuration
In the easy2use root, create file: **config-user.bash**
This file is included in .gitignore!

Add the following lines in the file:

    export CX_IMAGE_REGISTRY="\<imageregistry\>"       Example for Dockerhub add registry.hub.docker.com<br>
    export CX_IMAGE_REPOSITORY="\<repository\>"        Example in Dockerhub your username<br>

    export CX_IMAGE_REPOSITORY_ARGO_K8S_SECRET_USER="\<UserName\>"
    export CX_IMAGE_REPOSITORY_ARGO_K8S_SECRET_PSW="\<Password\>"


## Included Components
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

Dependent Components Included from Eiffel Bundle
- RabbitMQ (Message Bus)
- MongoDB  & Data Seeding
- RemRem Generate
- RemRem Publish
- Event Repository REST API
- Eiffel Intelligence (with artifact rules)

A more detailed [view of the components can be found here](components.md).

## Usage

### Start Cx Bundle

**Argo can only be deployed once per cluster**, but Argo-events can be deployed
in multiple namespaces in the same cluster.

**Option 1)** Deploy CX bundle with all components including Argo

    ./easy2use start Cx -t Kubernetes -n <namespace> -d <basedomainname>

basedomain name is the basedomainname for the K8S cluster, if using local k8s kluster use ex. mylocalkube.com

NOTE: You need to answer "Y" twice, first for the Cx bundle installation and then
the dependent services from the Eiffel bundle!

If Argo is already installed the following error printout is generated:

    Easy2Use: Warning: Could not install additional installs: kubectl create serviceaccount --namespace kube-system argo 


**Option 2)** Deploy CX bundle with all components including Argo-Events and
excluding Argo if it is already implemented in K8S cluster. With this deployment
Argo GUI/Artifactory will be available in the namespace where Argo is deployed.

    ./easy2use start Cx -t Kubernetes -n <namespace> -d <basedomainname> -p min

basedomain name is the basedomainname for the K8S cluster, if using local k8s kluster use eg. mylocalkube.com

NOTE: You need to answer "Y" twice, first for the Cx bundle installs and then the dependent services from the Eiffel bundle!


### List Service URLs, Username and Password
EasyUse list command will list both URLs (ingresses) to the deployed K8S services and the username/password for the services.

    ./easy2use list Cx -t Kubernetes -n <namespace>

**NOTE** For included Eiffel components do:

    ./easy2use list Eiffel -t Kubernetes -n <namespace>


#### List HOSTS Files Entries for Local K8S

If running the Cx bundle on a local K8S cluster, you need to update your
..etc/hosts file with ingresses. To print the ingresses to use do:

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
 - Windows: C:\Windows\System32\drivers\etc\hosts            (NOTE: you need to open cmd in Administrator mode!)

### Remove Cx Bundle

**Option 1)** Deploy CX bundle with all components including Argo
NOTE: Argo is a cluster global release, so it will be removed even if it is
deployed in another namespace than specified in the Easy2Use command!

    ./easy2use remove Cx -t Kubernetes -n <namespace> 

NOTE: You need to answer "Y" twice, first for the Cx bundle removals and then the dependent services from the Eiffel bundle!

**Option 2)** Deploy CX bundle with all components including Argo-Events and
excluding Argo.

    ./easy2use remove Cx -t Kubernetes -n <namespace> -p min

NOTE: You need to answer "Y" twice, first for the Cx bundle removals and then
the dependent services from the Eiffel bundle!

## Tutorial for Bundle
When the bundle is started it is time to start playing around with the services.
A [step by step tutorial can be found here](tutorial.md).
