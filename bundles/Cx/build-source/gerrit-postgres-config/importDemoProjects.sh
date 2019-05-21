#!/bin/bash
#
#   Copyright 2019 Ericsson AB.
#   For a full list of individual contributors, please see the commit history.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
set -e

#########################################################################
#########################################################################
# Create demo project ms-frontend on Gerrit.
curl --request PUT --user "${CI_INIT_ADMIN}:${CI_INIT_PASSWORD}" -d@- --header "Content-Type: application/json;charset=UTF-8" ${GERRIT_WEBURL}/a/projects/ms-frontend < ./demoProject.json

# Setup local git.
rm -rf ./ms-frontend
cp -R ./projects/ms-frontend .
git init ./ms-frontend
cd ./ms-frontend

#start ssh agent and add ssh key
eval $(ssh-agent)
ssh-add "${SSH_KEY_PATH}"

git config core.filemode false
git config user.name  ${CI_INIT_ADMIN}
git config user.email ${CI_INIT_EMAIL}
git config push.default simple
git remote add origin ssh://${CI_INIT_ADMIN}@${PROXY_HOST}:${GERRIT_SSH_PORT}/ms-frontend
git fetch -q origin

# Setup project access right.
## Registered users can change everything since it's just a demo project.
#git fetch -q origin refs/meta/config:refs/remotes/origin/meta/config
#git checkout meta/config
#cp ../groups .
#git config -f project.config --add access.refs/*.owner "group Registered Users"
#git config -f project.config --add access.refs/*.read "group Registered Users"
#git add groups project.config
#git commit -m "Add access right to Registered Users."
#git push origin meta/config:meta/config

# Import demoProject - ms-frontend
git checkout master
git add .
git commit -m "Init project"
git push origin


# Remove local git repository.
cd -
rm -rf ./ms-frontend

#########################################################################
#########################################################################
# Create demo project ms-backend on Gerrit.
curl --request PUT --user "${CI_INIT_ADMIN}:${CI_INIT_PASSWORD}" -d@- --header "Content-Type: application/json;charset=UTF-8" ${GERRIT_WEBURL}/a/projects/ms-backend < ./demoProject.json

# Setup local git.
rm -rf ./ms-backend
cp -R ./projects/ms-backend .
git init ./ms-backend
cd ./ms-backend

git config core.filemode false
git config user.name  ${CI_INIT_ADMIN}
git config user.email ${CI_INIT_EMAIL}
git config push.default simple
git remote add origin ssh://${CI_INIT_ADMIN}@${PROXY_HOST}:${GERRIT_SSH_PORT}/ms-backend
git fetch -q origin

# Setup project access right.
## Registered users can change everything since it's just a demo project.
#git fetch -q origin refs/meta/config:refs/remotes/origin/meta/config
#git checkout meta/config
#cp ../groups .
#git config -f project.config --add access.refs/*.owner "group Registered Users"
#git config -f project.config --add access.refs/*.read "group Registered Users"
#git add groups project.config
#git commit -m "Add access right to Registered Users."
#git push origin meta/config:meta/config

# Import demoProject - ms-backend
git checkout master
git add .
git commit -m "Init project"
git push origin


# Gerrit webhook plugin config for ms-backend repo
git fetch origin refs/meta/config:refs/remotes/origin/meta/config
git checkout meta/config

cat <<EOF > webhooks.config
[remote "msbackendgenerateeiffelevent"]
  url = http://webhook-gateway-svc:12000/msbackendgenerateeiffelevent
  maxTries = 5
  sslVerify = false
  event = patchset-created
  event = change-merged
EOF

git add .
git commit -m "webhooks.config added"
git push origin meta/config:meta/config


# Remove local git repository.
cd -
rm -rf ./ms-backend

#########################################################################
#########################################################################
# Create demo project eiffel-jenkins-pipeline-shared on Gerrit.
curl --request PUT --user "${CI_INIT_ADMIN}:${CI_INIT_PASSWORD}" -d@- --header "Content-Type: application/json;charset=UTF-8" ${GERRIT_WEBURL}/a/projects/eiffel-jenkins-pipeline-shared < ./demoProject.json

# Setup local git.
rm -rf ./eiffel-jenkins-pipeline-shared
cp -R ./projects/eiffel-jenkins-pipeline-shared .
git init ./eiffel-jenkins-pipeline-shared
cd ./eiffel-jenkins-pipeline-shared


git config core.filemode false
git config user.name  ${CI_INIT_ADMIN}
git config user.email ${CI_INIT_EMAIL}
git config push.default simple
git remote add origin ssh://${CI_INIT_ADMIN}@${PROXY_HOST}:${GERRIT_SSH_PORT}/eiffel-jenkins-pipeline-shared
git fetch -q origin


# Setup project access right.
## Registered users can change everything since it's just a demo project.
#git fetch -q origin refs/meta/config:refs/remotes/origin/meta/config
#git checkout meta/config
#cp ../groups .
#git config -f project.config --add access.refs/*.owner "group Registered Users"
#git config -f project.config --add access.refs/*.read "group Registered Users"
#git add groups project.config
#git commit -m "Add access right to Registered Users."
#git push origin meta/config:meta/config

# Import demoProject - eiffel-jenkins-pipeline-shared
git checkout master
git add .
git commit -m "Init project"
git push origin

# Remove local git repository.
cd -
rm -rf ./eiffel-jenkins-pipeline-shared

#########################################################################
#########################################################################
# Create demo project deployments on Gerrit.
curl --request PUT --user "${CI_INIT_ADMIN}:${CI_INIT_PASSWORD}" -d@- --header "Content-Type: application/json;charset=UTF-8" ${GERRIT_WEBURL}/a/projects/deployments < ./demoProject.json

# Setup local git.
rm -rf ./deployments
cp -R ./projects/deployments .
git init ./deployments
cd ./deployments


git config core.filemode false
git config user.name  ${CI_INIT_ADMIN}
git config user.email ${CI_INIT_EMAIL}
git config push.default simple
git remote add origin ssh://${CI_INIT_ADMIN}@${PROXY_HOST}:${GERRIT_SSH_PORT}/deployments
git fetch -q origin


# Setup project access right.
## Registered users can change everything since it's just a demo project.
#git fetch -q origin refs/meta/config:refs/remotes/origin/meta/config
#git checkout meta/config
#cp ../groups .
#git config -f project.config --add access.refs/*.owner "group Registered Users"
#git config -f project.config --add access.refs/*.read "group Registered Users"
#git add groups project.config
#git commit -m "Add access right to Registered Users."
#git push origin meta/config:meta/config

# Import demoProject - deployments
git checkout master
git add .
git commit -m "Init project"
git push origin

# Create dev branch copy from master
git checkout -b dev master
git push origin dev

# Create stage branch copy from master
git checkout -b stage master
git push origin stage

# Remove local git repository.
cd -
rm -rf ./deployments

#########################################################################
#########################################################################
# Create job in Jenkins
#DEMO_CONFIG_XML=$(source ./jenkins.demo.config.xml.sh)
#curl --request POST --user "${CI_INIT_ADMIN}:${CI_INIT_PASSWORD}" --data-raw "${DEMO_CONFIG_XML}" --header "Content-Type: application/xml;charset=UTF-8" ${JENKINS_WEBURL}/createItem?name=demo

#stop ssh agent
kill ${SSH_AGENT_PID}