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
# Tutorial for GitLab Bundle

### 1. Change password
 - Login to GitLab  (gitlab.\<domainname\>)
 - Change password

### 2. Register User
 - Click Register tab
 - Fill-in required text fields
 - Click Register

### 3. Import Projects
#### 3.1 Import ms-frontend
 - Click Create a project
 - Click Import project tab
 - Click git Repo by URL, add Git Repo URL:
    - https://github.com/eiffelci/eiffel-ms-frontend-ci-test.git
 - Tick Public
 - Click Create project
 - Click Settings -> CI/CD -> Expand Secrets variables:
 - Print vars to add via:
    - ./easy2use list GitLab -t Kubernetes -n <namespace>
 - Click Save variables

#### 3.2 Import ms-backend
 - Click New project (plus sign on top bar)
 - Click Import project tab
 - Click git Repo by URL, add Git Repo URL:
   - https://github.com/eiffelci/eiffel-ms-backend-ci-test.git
 - Tick Public
 - Click Create project
 - Click Settings -> CI/CD -> Expand Secrets variables:
 - Print vars to add via:
   - ./easy2use list GitLab -t Kubernetes -n <namespace>
 - Click Save variables

### 4. Start builds
 For both ms-frontend and ms-backend do:

 - Click CI/CD -> Run Pipeline -> Create pipeline

   After initial pipelines are now executed, the pipelines will be started when changes are committed & pushed from now on!

### 5 Deployments (CD) - ms-frontend & ms-backend
  - dev (CD only executed for merge-requests)
    - ms-frontend-dev-\<namespace\>.\<domainname\>/api/greeting
    - ms-backend-dev-\<namespace\>.\<domainname\>/api/hellobackend
  - stage (CD only executed on master branch changes)
    - ms-frontend-stage-\<namespace\>.\<domainname\>/api/greeting
    - ms-backend-stage-\<namespace\>.\<domainname\>/api/hellobackend       Info: 2 replicas created<br>
  - prod (CD only executed when manually triggered in pipeline)
    - ms-frontend-prod-\<namespace\>.\<domainname\>/api/greeting
    - ms-backend-prod-\<namespace\>.\<domainname\>/api/hellobackend        Info: 3 replicas created<br>


Ingresses visible after deployment in cmd:
 - ./easy2use list GitLab -t Kubernetes -n <namespace>
