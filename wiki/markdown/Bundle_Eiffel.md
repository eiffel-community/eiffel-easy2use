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
# Eiffel Bundle

## Idea
To provide an environment in which all Eiffel components can be tested together. It is mainly intended to be used to try out the services in the Eiffel portfolio themselves.<br>
This bundle can be used as a base for any application bundle depending on Eiffel. Not all services in this bundle would need to be included in such an application bundle.<br>
The docker-compose file in this bundle will show the dependencies between services in this bundle, so that relevant dependent services can be included.<br>

The Easy2Use Eiffel bundle is applicable both for Docker & Kubernetes.

## Bundle Name
Eiffel

## Components included in Eiffel bundle
Component | Service name | User/PSW | Info
------------- | ------------ | -------- | ----
Dummy Event Repository REST API | dummy_er | N/A | Needed for Vici for now
Eiffel Intelligence  (Frontend) | ei_frontend | N/A
Eiffel Intelligence (All Events) | ei_allevents | N/A
Eiffel Intelligence (Artifact) | ei_artifact | N/A | Subscription included (seeded) to trigger predefined Jenkins Job ei-artifact-triggered-job via native Jenkins Rest API
Eiffel Intelligence (SourceChange) | ei_sourcechange | N/A | Subscription included (seeded) to trigger predefined Jenkins Job ei-sourcechange-triggered-job via native Jenkins Rest API
Eiffel Intelligence (TestExecution) | ei_testexecution | N/A | Subscription included (seeded) to trigger predefined Jenkins Job ei-testexecution-triggered-job via native Jenkins Rest API
Eiffel Jenkins (with Eiffel Jenkins Plugin) | eiffel_jenkins | admin / admin | With predefined jobs showing some Eiffel service interactions with use of FEM plugin
Eiffel Message Bus (RabbitMQ) | rabbitmq | myuser / myuser | Same for both WebUI and AMQP connection	
Event Repository REST API | eiffel_er | N/A	 
Jenkins	| jenkins | admin/admin | With predefined jobs showing some Eiffel service interactions using RemRem and Nexus via curl command.
MongoDb & Data Seeding | mongodb & mongo_seed | N/A | The seed-data folder in Easy2Use contains data that can be seeded into the MongoDB instance.
Nexus3 | nexus | admin / admin123 |
RemRem Generate | remrem_generate | N/A |	 
RemRem Publish | remrem_publish | N/A |	 
Vici | eiffel_vici | N/A

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
N/A

## Quick getting started guide with Easy2Use
See the getting starting page: Getting Started
[**Bundles**](./Getting_Started.md)


## Layout
This is a schematic picture of the environment:

<img src="./images/eiffel-components.png" alt="Eiffel Easy2Use" width="750"/>


## Usage
### Bundle Information
Print bundle information from Easy2Use CLI:
```
./easy2use info Eiffel
```

## Prerequisite local K8S cluster
If running in local K8S cluster, minikube or docker-for-windows (windows 10 Hyper-v). Local K8S cluster configuration is required.

  - Local K8S cluster (windows 10 Hyper-v) do:
  ```
  ./easy2use configure-local-k8s-hyper-v Eiffel -t Kubernetes
  ```
  - Local K8S cluster (minikube) do:
  ```
  ./easy2use configure-local-k8s-minikube Eiffel -t Kubernetes
  ```

## Start Eiffel Bundle
```
./easy2use start Eiffel -t <target-type> -n <namespace> -d <basedomainname>
```

## List Service URLs, UserName & PSW
Easy2Use list command will both list URLs (ingresses) to the deployed K8S services and user/psw for the services.
```
./easy2use list Eiffel -t <target-type> -n <namespace>
```

## List HOSTS files entries for local K8S

If you running the Eiffel bundle on a local K8S cluster, you need to update your ..etc/hosts file with ingresses. To print the ingresses to use do:

### Local K8S cluster (windows 10 Hyper-v) do:
```
./easy2use  generate-local-hosts-file-hyper-v Eiffel -t Kubernetes
```

### Local K8S cluster (minikube) do:
```
./easy2use  generate-local-hosts-file-minikube Eiffel -t Kubernetes
```

Update your hosts file with the output from the printout!


 Linux:  /etc/hosts

 Windows: C:\Windows\System32\drivers\etc\hosts            (OBS you need to open cmd in Administrator mode!)

## Remove Eiffel Bundle
```
./easy2use remove Eiffel -t <target-type> -n <namespace>
```

## Known Issues
[**Easy2Use Issues**](https://github.com/eiffel-community/eiffel-easy2use/issues)