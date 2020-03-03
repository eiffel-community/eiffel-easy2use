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
# Eiffel Bundle

* [Bundle Concept](#bundle-concept)
* [Prerequisites](#prerequisites)
* [Included Components](#included-components)
* [Usage](#usage)
* [Tutorial for Bundle](#tutorial-for-bundle)

## Bundle Concept
This bundle provides an environment in which all Eiffel components can be tested
together. It is mainly intended to be used to try out the services in the Eiffel
portfolio themselves. This bundle can be used as a base for any application bundle
depending on Eiffel. Not all services in this bundle would need to be included in
such an application bundle. The docker-compose file in this bundle will show the
dependencies between services in this bundle, so that relevant dependent services
can be included.

### Bundle Name
The following name is used to refer to this bundle in the easy2use CLI:

Eiffel

### Dependencies
N/A

### Supported Target Environment
The Easy2Use Eiffel bundle is applicable for deployments in both Docker and Kubernetes.

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
  ./easy2use configure-local-k8s-hyper-v Eiffel -t Kubernetes
  ```
  - Local K8S cluster (minikube) do:
  ```
  ./easy2use configure-local-k8s-minikube Eiffel -t Kubernetes
  ```

## Included Components
A detailed [view can be found here](./components.md).


## Usage

## Start Eiffel Bundle
```
./easy2use start Eiffel -t <target-type> -n <namespace> -d <basedomainname>
```

## List Service URLs, UserName & PSW
Easy2Use list command will both list URLs (ingresses) to the deployed K8S services and username/password for the services.
```
./easy2use list Eiffel -t <target-type> -n <namespace>
```

## List HOSTS Files Entries for Local K8S
If running the Eiffel bundle on a local K8S cluster, you need to update  
your ..etc/hosts file with ingresses. To print the ingresses to use do:

* Local K8S cluster (windows 10 Hyper-v) do:
    ```
    ./easy2use  generate-local-hosts-file-hyper-v Eiffel -t Kubernetes
    ```
* Local K8S cluster (minikube) do:
    ```
    ./easy2use  generate-local-hosts-file-minikube Eiffel -t Kubernetes
    ```

Update your hosts file with the output from the printout!
 - Linux:  /etc/hosts
 - Windows: C:\Windows\System32\drivers\etc\hosts            (NOTE: you need to open cmd in Administrator mode!)

## Remove Eiffel Bundle
```
./easy2use remove Eiffel -t <target-type> -n <namespace>
```

## Tutorial for Bundle
When the bundle is started it is time to start playing around with the services.
A [step by step tutorial can be found here](tutorial.md).
