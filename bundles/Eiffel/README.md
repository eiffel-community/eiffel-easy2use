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

The Eiffel bundle includes an environment in which all Eiffel components can be tested together. 
It is mainly intended to be used to try out the services in the Eiffel portfolio themselves. 
This bundle can be used as a base for any application bundle depending on Eiffel. 
Not all services in this bundle would need to be included in such an application bundle. 
The docker-compose file in this bundle will show the dependencies between services in this bundle, so that relevant 
dependent services can be included.

The Easy2Use Eiffel bundle is applicable both for Docker & Kubernetes.

Bundle Name
-----------
Eiffel

Components included in Eiffel bundle
--------------------------------
- Eiffel Message Bus (RabbitMQ)
- MongoDb  & Data Seeding 
- Eiffel Intelligence - Frontend
- Eiffel Intelligence - Artifact
- Eiffel Intelligence - SourceChange
- Eiffel Intelligence - TestExecution
- Eiffel Intelligence - All Events
- RemRem Generate
- RemRem Publish
- Eiffel Jenkins (with Fem Plugin)
- Jenkins
- Event Repository REST API
- Dummy Event Repository REST API
- Nexus3 


Usage
-----

Prerequisite local K8S cluster
------------------------------

If running in local K8S cluster, minikube or docker-for-windows (windows 10 Hyper-v). Local K8S cluster configuration is required.

 - Local K8S cluster (windows 10 Hyper-v) do:

   $  ./easy2use configure-local-k8s-hyper-v Eiffel -t Kubernetes

 - Local K8S cluster (minikube) do:

   $  ./easy2use configure-local-k8s-minikube Eiffel -t Kubernetes

Start Eiffel Bundle
--------------------

$ ./easy2use start Eiffel -t <target-type> -n <namespace> -d <basedomainname>


List Service URLs
-----------------
EasyUse list command will both list URLs (ingresses) to the deployed K8S services and user/psw for the services.


$ ./easy2use list Eiffel -t <target-type> -n <namespace>
   

List HOSTS files entries for local K8S
-------------------------------------- 
If you running the Eiffel bundle on a local K8S cluster, you need to update your ..etc/hosts file with ingresses. To print the ingresses to use do:

 - Local K8S cluster (windows 10 Hyper-v) do:

   $  ./easy2use  generate-local-hosts-file-hyper-v Eiffel -t Kubernetes

 - Local K8S cluster (minikube) do:
 
   $  ./easy2use  generate-local-hosts-file-minikube Eiffel -t Kubernetes

     Update your hosts file with the output from the printout!

      Linux:  /etc/hosts

      Windows: C:\Windows\System32\drivers\etc\hosts            (OBS you need to open cmd in Administrator mode!)


Remove Eiffel Bundle
----------------

$ ./easy2use remove Eiffel -t <target-type> -n <namespace> 




