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


PROXY_HOST=${PROXY_HOST:-$1}
GERRIT_WEBURL=${GERRIT_WEBURL:-$2}
CI_INIT_ADMIN=${CI_INIT_ADMIN:-$3}
CI_INIT_PASSWORD=${CI_INIT_PASSWORD:-$4}
CI_INIT_EMAIL=${CI_INIT_EMAIL:-$5}
SSH_KEY_PATH=${SSH_KEY_PATH:-~/.ssh/id_rsa}
CHECKOUT_DIR=./git


#Remove appended '/' if existed.
GERRIT_WEBURL=${GERRIT_WEBURL%/}

cat "${SSH_KEY_PATH}.pub"

echo "${CI_INIT_ADMIN}:${CI_INIT_PASSWORD}"
echo "${WEBURL}/a/accounts/self/sshkeys"

# Add ssh-key
cat "${SSH_KEY_PATH}.pub" | curl --data @- --user "${CI_INIT_ADMIN}:${CI_INIT_PASSWORD}"  ${GERRIT_WEBURL}/a/accounts/self/sshkeys

#gather server rsa key
[ -f ~/.ssh/known_hosts ] && mv ~/.ssh/known_hosts ~/.ssh/known_hosts.bak
ssh-keyscan -p ${GERRIT_SSH_PORT} -t rsa ${PROXY_HOST} > ~/.ssh/known_hosts

#checkout project.config from All-Project.git
[ -d ${CHECKOUT_DIR} ] && mv ${CHECKOUT_DIR}  ${CHECKOUT_DIR}.$$
mkdir ${CHECKOUT_DIR}

git init ${CHECKOUT_DIR}
cd ${CHECKOUT_DIR}

#start ssh agent and add ssh key
eval $(ssh-agent)
ssh-add "${SSH_KEY_PATH}"

#git config
git config user.name  ${CI_INIT_ADMIN}
git config user.email ${CI_INIT_EMAIL}
git remote add origin ssh://${CI_INIT_ADMIN}@${PROXY_HOST}:${GERRIT_SSH_PORT}/All-Projects
#checkout project.config
git fetch -q origin refs/meta/config:refs/remotes/origin/meta/config
git checkout meta/config


# requireChangeId , turn of need for hooks
git config -f project.config --replace-all capability.accessDatabase  "group Administrators"
git config -f project.config --replace-all capability.accessDatabase  "group Anonymous Users"

# requireChangeId , turn of need for hooks
git config -f project.config --replace-all receive.requireChangeId "false"
git commit -a -m "Remove requireChangeId."

#add label.Verified
git config -f project.config label.Verified.function MaxWithBlock
git config -f project.config --add label.Verified.defaultValue  0
git config -f project.config --add label.Verified.value "-1 Fails"
git config -f project.config --add label.Verified.value "0 No score"
git config -f project.config --add label.Verified.value "+1 Verified"
##commit and push back
git commit -a -m "Added label - Verified"

#Change global access right
##Remove anonymous access right.
#git config -f project.config --unset access.refs/*.read "group Anonymous Users"
##add Jenkins access and verify right
git config -f project.config --add access.refs/heads/*.read "group Non-Interactive Users"
git config -f project.config --add access.refs/heads/*.read "group Anonymous Users"
git config -f project.config --add access.refs/tags/*.read "group Non-Interactive Users"
git config -f project.config --add access.refs/tags/*.read "group Anonymous Users"
git config -f project.config --add access.refs/heads/*.label-Code-Review "-1..+1 group Non-Interactive Users"
git config -f project.config --add access.refs/heads/*.label-Code-Review "-1..+1 group Anonymous Users"
git config -f project.config --add access.refs/heads/*.label-Verified "-1..+1 group Non-Interactive Users"
git config -f project.config --add access.refs/heads/*.label-Verified "-1..+1 group Anonymous Users"
git config -f project.config --add access.refs/heads/*.label-Verified "-1..+1 group Administrators"
##add project owners' right to add verify flag
git config -f project.config --add access.refs/heads/*.label-Verified "-1..+1 group Project Owners"
##commit and push back
git commit -a -m "Change access right." 
git push origin meta/config:meta/config

#stop ssh agent
kill ${SSH_AGENT_PID}

cd -
rm -rf ${CHECKOUT_DIR}
[ -d ${CHECKOUT_DIR}.$$ ] && mv ${CHECKOUT_DIR}.$$  ${CHECKOUT_DIR}

echo "finish gerrit setup"
