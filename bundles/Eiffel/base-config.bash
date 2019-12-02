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
export EIFFEL_MONGODB="eiffel-mongodb"
export EIFFEL_RABBITMQ="eiffel-rabbitmq"
export EIFFEL_DUMMY_ER="dummy-er"
export EIFFEL_ER="eiffel-er"
export EIFFEL_JENKINS_FEM="eiffel-jenkins-fem"
export EIFFEL_JENKINS="eiffel-jenkins"
export EIFFEL_NEXUS3="eiffel-nexus3"
export EIFFEL_REMREM_GENERATE="eiffel-remrem-generate"
export EIFFEL_REMREM_PUBLISH="eiffel-remrem-publish"
export EIFFEL_VICI="eiffel-vici"
export EIFFEL_EI_BACKEND_ARTIFACT="eiffel-backend-artifact"
export EIFFEL_EI_BACKEND_SOURCECHANGE="eiffel-backend-sourcechange"
export EIFFEL_EI_BACKEND_TESTEXECUTION="eiffel-backend-testexecution"
export EIFFEL_EI_BACKEND_ALLEVENTS="eiffel-backend-allevents"
export EIFFEL_EI_FRONTEND="eiffel-frontend"
export EIFFEL_MONGODB_SEED="eiffel-mongo-seed"

# ----- Eiffel 2.0 External Ports, Internal Ports
export EIFFEL_MONGODB_EXTERNAL_PORT=27017
export EIFFEL_MONGODB_INTERNAL_PORT=27017

export EIFFEL_RABBITMQ_AMQP_EXTERNAL_PORT=5672
export EIFFEL_RABBITMQ_WEB_EXTERNAL_PORT=15672
export EIFFEL_RABBITMQ_AMQP_INTERNAL_PORT=5672
export EIFFEL_RABBITMQ_WEB_INTERNAL_PORT=15672

export EIFFEL_DUMMY_ER_EXTERNAL_PORT=8093
export EIFFEL_DUMMY_ER_INTERNAL_PORT=8081

export EIFFEL_ER_EXTERNAL_PORT=8084
export EIFFEL_ER_INTERNAL_PORT=8080

export EIFFEL_JENKINS_FEM_EXTERNAL_PORT=8052
export EIFFEL_JENKINS_FEM_INTERNAL_PORT=8080

export EIFFEL_JENKINS_EXTERNAL_PORT=8051
export EIFFEL_JENKINS_INTERNAL_PORT=8080

export EIFFEL_NEXUS_EXTERNAL_PORT=8081
export EIFFEL_NEXUS_INTERNAL_PORT=8081

export EIFFEL_REMREM_GENERATE_EXTERNAL_PORT=8095
export EIFFEL_REMREM_GENERATE_INTERNAL_PORT=8080

export EIFFEL_REMREM_PUBLISH_EXTERNAL_PORT=8096
export EIFFEL_REMREM_PUBLISH_INTERNAL_PORT=8080

export EIFFEL_VICI_EXTERNAL_PORT=8092
export EIFFEL_VICI_INTERNAL_PORT=8080

export EIFFEL_EI_BACKEND_ARTIFACT_EXTERNAL_PORT=8070
export EIFFEL_EI_BACKEND_ARTIFACT_INTERNAL_PORT=8080

export EIFFEL_EI_BACKEND_SOURCECHANGE_EXTERNAL_PORT=8072
export EIFFEL_EI_BACKEND_SOURCECHANGE_INTERNAL_PORT=8080

export EIFFEL_EI_BACKEND_TESTEXECUTION_EXTERNAL_PORT=8074
export EIFFEL_EI_BACKEND_TESTEXECUTION_INTERNAL_PORT=8080

export EIFFEL_EI_BACKEND_ALLEVENTS_EXTERNAL_PORT=8076
export EIFFEL_EI_BACKEND_ALLEVENTS_INTERNAL_PORT=8080

export EIFFEL_EI_FRONTEND_EXTERNAL_PORT=8077
export EIFFEL_EI_FRONTEND_INTERNAL_PORT=8080
