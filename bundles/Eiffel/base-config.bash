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
##-------------------------------------------------------------------------------------
## Eiffel environment variable settings
##
## Author: michael.frick@ericsson.com
##
##--------------------------------------------------------------------------------------

### DNS Service names
# ----- Eiffel 2.0 Servicenames, External Ports, Internal Ports
export EIFFEL2_MONGODB="eiffel-mongodb"
export EIFFEL2_RABBITMQ="eiffel-rabbitmq"
export EIFFEL2_DUMMY_ER="eiffel-dummy-er"
export EIFFEL2_ER="eiffel-er"
export EIFFEL2_JENKINS_FEM="eiffel-jenkins-fem"
export EIFFEL2_JENKINS="eiffel-jenkins"
export EIFFEL2_NEXUS3="eiffel-nexus3"
export EIFFEL2_REMREM_GENERATE="eiffel-remrem-generate"
export EIFFEL2_REMREM_PUBLISH="eiffel-remrem-publish"
export EIFFEL2_VICI="eiffel-vici"
export EIFFEL2_EI_BACKEND_ARTIFACT="eiffel-backend-artifact"
export EIFFEL2_EI_BACKEND_SOURCECHANGE="eiffel-backend-sourcechange"
export EIFFEL2_EI_BACKEND_TESTEXECUTION="eiffel-backend-testexecution"
export EIFFEL2_EI_BACKEND_ALLEVENTS="eiffel-backend-allevents"
export EIFFEL2_EI_FRONTEND="eiffel-frontend"
export EIFFEL2_MONGODB_SEED="eiffel-mongo-seed"

# ----- Eiffel 2.0 External Ports, Internal Ports
export EIFFEL2_MONGODB_EXTERNAL_PORT=27017
export EIFFEL2_MONGODB_INTERNAL_PORT=27017

export EIFFEL2_RABBITMQ_AMQP_EXTERNAL_PORT=5672
export EIFFEL2_RABBITMQ_WEB_EXTERNAL_PORT=15672
export EIFFEL2_RABBITMQ_AMQP_INTERNAL_PORT=5672
export EIFFEL2_RABBITMQ_WEB_INTERNAL_PORT=15672

export EIFFEL2_DUMMY_ER_EXTERNAL_PORT=8093
export EIFFEL2_DUMMY_ER_INTERNAL_PORT=8081

export EIFFEL2_ER_EXTERNAL_PORT=8084
export EIFFEL2_ER_INTERNAL_PORT=8080

export EIFFEL2_JENKINS_FEM_EXTERNAL_PORT=8052
export EIFFEL2_JENKINS_FEM_INTERNAL_PORT=8080

export EIFFEL2_JENKINS_EXTERNAL_PORT=8051
export EIFFEL2_JENKINS_INTERNAL_PORT=8080

export EIFFEL2_NEXUS_EXTERNAL_PORT=8081
export EIFFEL2_NEXUS_INTERNAL_PORT=8081

export EIFFEL2_REMREM_GENERATE_EXTERNAL_PORT=8095
export EIFFEL2_REMREM_GENERATE_INTERNAL_PORT=8080

export EIFFEL2_REMREM_PUBLISH_EXTERNAL_PORT=8096
export EIFFEL2_REMREM_PUBLISH_INTERNAL_PORT=8080

export EIFFEL2_VICI_EXTERNAL_PORT=8092
export EIFFEL2_VICI_INTERNAL_PORT=8080

export EIFFEL2_EI_BACKEND_ARTIFACT_EXTERNAL_PORT=8070
export EIFFEL2_EI_BACKEND_ARTIFACT_INTERNAL_PORT=8080

export EIFFEL2_EI_BACKEND_SOURCECHANGE_EXTERNAL_PORT=8072
export EIFFEL2_EI_BACKEND_SOURCECHANGE_INTERNAL_PORT=8080

export EIFFEL2_EI_BACKEND_TESTEXECUTION_EXTERNAL_PORT=8074
export EIFFEL2_EI_BACKEND_TESTEXECUTION_INTERNAL_PORT=8080

export EIFFEL2_EI_BACKEND_ALLEVENTS_EXTERNAL_PORT=8076
export EIFFEL2_EI_BACKEND_ALLEVENTS_INTERNAL_PORT=8080

export EIFFEL2_EI_FRONTEND_EXTERNAL_PORT=8077
export EIFFEL2_EI_FRONTEND_INTERNAL_PORT=8080
