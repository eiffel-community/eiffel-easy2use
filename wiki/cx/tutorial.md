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
# Tutorial for Cx Bundle
This bundle contains two CI engines. Two microservices (ms-frontend and ms-backend)
are imported and have their own pipeline defined.
The ms-frontend microservice has a pipeline defined to execute with the help
of Jenkins as the build engine. The ms-backend microservice has a pipeline definition
which Argo executes. This tutorial includes walk-through guides for both:

 * [Jenkins pipeline with ms-frontend](#run-jenkins-pipeline-for-ms-frontend)
 * [Argo workflow with ms-backend](#run-argo-workflow-for-ms-backend)

## Run Jenkins pipeline for ms-frontend
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

### Run Argo workflow for ms-backend
Included microservice "ms-backend" in the Gerrit Git repo will be handled in Argo pre & post-merge pipelines

### 1. Trigger Argo pipeline (Workflow)
Clone Gerrit repo: ms-backend:

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
