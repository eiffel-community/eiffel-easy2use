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
#!/bin/bash

echo Injecting environment variables values into seed data files.

echo EIFFEL_JENKINS_FEM DNS: ${EIFFEL_JENKINS_FEM}
echo EIFFEL_JENKINS_FEM PORT: ${EIFFEL_JENKINS_FEM_PORT}

echo EIFFEL_JENKINS DNS: ${EIFFEL_JENKINS}
echo EIFFEL_JENKINS PORT: ${EIFFEL_JENKINS_PORT}


EI_ALLEVENTS_SUB_FILE1=/seed-data/ei_allevents/subscription.json
EI_ALLEVENTS_SUB_FILE2=/seed-data/ei_allevents/subscription2.json

EI_ARTIFACT_SUB_FILE1=/seed-data/ei_artifact/subscription.json
EI_ARTIFACT_SUB_FILE2=/seed-data/ei_artifact/subscription2.json

EI_SOURCECHANGE_SUB_FILE1=/seed-data/ei_sourcechange/subscription.json
EI_SOURCECHANGE_SUB_FILE2=/seed-data/ei_sourcechange/subscription2.json

EI_TESTEXECUTION_SUB_FILE1=/seed-data/ei_testexecution/subscription.json
EI_TESTEXECUTION_SUB_FILE2=/seed-data/ei_testexecution/subscription2.json


sed -i "s/EIFFEL_JENKINS_FEM/${EIFFEL_JENKINS_FEM}\:${EIFFEL_JENKINS_FEM_PORT}/g" $EI_ALLEVENTS_SUB_FILE1
sed -i "s/EIFFEL_JENKINS_FEM/${EIFFEL_JENKINS_FEM}\:${EIFFEL_JENKINS_FEM_PORT}/g" $EI_ARTIFACT_SUB_FILE1
sed -i "s/EIFFEL_JENKINS_FEM/${EIFFEL_JENKINS_FEM}\:${EIFFEL_JENKINS_FEM_PORT}/g" $EI_SOURCECHANGE_SUB_FILE1
sed -i "s/EIFFEL_JENKINS_FEM/${EIFFEL_JENKINS_FEM}\:${EIFFEL_JENKINS_FEM_PORT}/g" $EI_TESTEXECUTION_SUB_FILE1

sed -i "s/EIFFEL_JENKINS/${EIFFEL_JENKINS}\:${EIFFEL_JENKINS_PORT}/g" $EI_ALLEVENTS_SUB_FILE2
sed -i "s/EIFFEL_JENKINS/${EIFFEL_JENKINS}\:${EIFFEL_JENKINS_PORT}/g" $EI_ARTIFACT_SUB_FILE2
sed -i "s/EIFFEL_JENKINS/${EIFFEL_JENKINS}\:${EIFFEL_JENKINS_PORT}/g" $EI_SOURCECHANGE_SUB_FILE2
sed -i "s/EIFFEL_JENKINS/${EIFFEL_JENKINS}\:${EIFFEL_JENKINS_PORT}/g" $EI_TESTEXECUTION_SUB_FILE2


echo Injected environment variables values into seed data files successfully.
cat $EI_ALLEVENTS_SUB_FILE1
cat $EI_ALLEVENTS_SUB_FILE2
cat $EI_ARTIFACT_SUB_FILE2
cat $EI_ARTIFACT_SUB_FILE2
cat $EI_SOURCECHANGE_SUB_FILE1
cat $EI_SOURCECHANGE_SUB_FILE2
cat $EI_TESTEXECUTION_SUB_FILE1
cat $EI_TESTEXECUTION_SUB_FILE2
