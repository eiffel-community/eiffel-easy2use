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
# GitLab Bundle

* [Bundle Concept]()
* [Prerequisites]()
* [Included Components]()
* [Usage]()
* [Tutorial]()

## Bundle Concept
To provide a GitLab bundle with CI/CD pipeline as code setup which executes CI/CD pipeline build steps in Docker containers.
Dependent Eiffel services will be loaded from the Eiffel bundle to provide capability to log/visualize pipeline activities via Eiffel events.

### Included Features
CI:
 - 2 Java Microservices to be imported (ms-frontend & ms-backend) with .gitlab-ci.yml files
   - https://github.com/eiffelci/eiffel-ms-frontend-ci-test.git
   - https://github.com/eiffelci/eiffel-ms-backend-ci-test.git
 - GitLab CI engine with pipeline as code (ms-frontend & ms-backend)
 - Pre & post-merge pipelines
 - Eiffel event generated

CD:
 - CD Pipelines with kubectl deployment via HELM templates, helm charts included in ms-frontend & ms-backend microservices
 - Pre-merge CD pipeline (merge request) deployment to dev
 - Post-merge CD pipeline (merge request) deployment to stage
 - Deployment to production is triggered via manually decision in GiLab GUI
 - Immutable Docker Images are used together with microservices config injection to configure microservices in the different K8S target environments


### Bundle Name
The following name is used to refer to this bundle in the easy2use CLI:

GitLab

### Dependencies
Eiffel bundle components

### Supported Target Environment
The Easy2Use GitLab bundle is only applicable for deployments in Kubernetes.

### Resource Requirements
OS | Minimum Requirements | Preferably | Comments
------------- | ------------ | -------- | ----
Windows 'Docker Toolbox' | ? | 24 GB RAM <br> 50 GB Disk? | This recommendation is valid when assigning 4 CPU cores to the Docker machine.<br>With less cores less memory would be consumed, but the performance will be worse. The assigned amount of RAM will be allocated to the Docker machine until it is stopped
Windows 'Docker for Windows' | ? |20 GB RAM? <br> 50 GB Disk? | The assigned amount of RAM is dynamically allocated and only used by the Docker machine when needed?
Linux | 8 GB RAM |16 GB RAM or more |	~11 GB of RAM will be use under the load. <br>When all containers is loaded, the memory usage is ~6 GB RAM. <br> Computer with 8 GB RAM works, but it will takes some more time to load <br>all containers due to swapping data between memory and hard drive.

#### Docker requirements
 - Docker 18.06 CE or newer
 - Docker-Compose 1.22 or newer

#### Kubernetes requirements
 - Kubernetes cluster (local or remote)
 - Kubectl
 - Helm

## Prerequisites

### Local K8S cluster
If running in local K8S cluster, minikube or docker-for-windows (windows 10 Hyper-v). Local K8S cluster configuration is required.

  - Local K8S cluster (windows 10 Hyper-v) do:
  ```
  ./easy2use configure-local-k8s-hyper-v GitLab -t Kubernetes
  ```
  - Local K8S cluster (minikube) do:
  ```
  ./easy2use configure-local-k8s-minikube GitLab -t Kubernetes
  ```

## Components included in Cx bundle
A detailed [view can be found here](./components.md).


## Usage

## Start GitLab Bundle
Gitlab can only be deployed once per cluster (one ingress used).
The GitLab startup can take a few minutes, so be patient!

Deploy GitLab bundle with all components including Argo:
  ```
  ./easy2use start GitLab -t Kubernetes -n <namespace> -d <basedomainname>
  ```
basedomain name is the basedomainname for the K8S cluster, if using local k8s kluster use ex. mylocalkube.com

NOTE: You need to answer "Y" twice, first for the GitLab bundle installs and then the dependent services from the Eiffel bundle!

## List Service URLs, UserName & Password
Easy2Use list command will both list URLs (ingresses) to the deployed K8S services and username/password for the services.
  ```
  ./easy2use list GitLab -t Kubernetes -n <namespace>
  ```
**NOTE:** For included Eiffel components do:
  ```
  ./easy2use list Eiffel -t Kubernetes -n <namespace>
  ```

## List HOSTS Files Entries for Local K8S
If running the GitLab bundle on a local K8S cluster, you need to update your ..etc/hosts file with ingresses. To print the ingresses to use do:

- Local K8S cluster (windows 10 Hyper-v) do:
  ```
  ./easy2use  generate-local-hosts-file-hyper-v GitLab -t Kubernetes
  ```
- Local K8S cluster (minikube) do:
  ```
  ./easy2use  generate-local-hosts-file-minikube GitLab -t Kubernetes
  ```

Update your hosts file with the output from the printout!
 - Linux:  /etc/hosts
 - Windows: C:\Windows\System32\drivers\etc\hosts            (OBS you need to open cmd in Administrator mode!)

## Remove GitLab Bundle
The deployed applications ms-frontend & ms-backend (GitLab CD pipelines) will not be removed via Easy2Use CLI.
  ```
  ./easy2use remove GitLab -t Kubernetes -n <namespace> 
  ```
NOTE: You need to answer "Y" twice, first for the GitLab bundle removals and then the dependent services from the Eiffel bundle!

## Tutorial for Bundle
When the bundle is started it is time to start playing around with the services.
A [step by step tutorial can be found here](./tutorial.md).
