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
## Cx K8S environment variable settings
##
## Author: michael.frick@ericsson.com
##
##--------------------------------------------------------------------------------------



# ---- Do NOT Change --------------------------------

export K8S_Ingress_Enabled=true

# ---- Do NOT Change --------------------------------


# -- Domain name for K8S cluster & Namespace ------
# Domainname in K8S Cluster
verbose "Domainname to use: ${K8S_DOMAINNAME}"

# Namespace in K8S Cluster
K8S_NAMESPACE=cx
[[ ! -z ${K8S_NAMESPACE_OVERRIDE} ]] && K8S_NAMESPACE=${K8S_NAMESPACE_OVERRIDE}
verbose "Namespace to use: ${K8S_NAMESPACE}"


#---- K8S Release.fullnames
export K8S_RELEASE_CX_ARTIFACTORY=$CX_ARTIFACTORY-$K8S_NAMESPACE
export K8S_RELEASE_CX_JENKINS=$CX_JENKINS-$K8S_NAMESPACE
export K8S_RELEASE_CX_GERRIT=$CX_GERRIT-$K8S_NAMESPACE
# OBS Argo will be used per cluster do not add namespace in release name
# Minio secret needed in all namespaces for Argo-events are based on relasename-minio
export K8S_RELEASE_CX_ARGO=$CX_ARGO 
export K8S_RELEASE_CX_MINIO=$CX_MINIO-$K8S_NAMESPACE
export K8S_RELEASE_CX_GERRIT_POSTGRES_CONFIG=$CX_GERRIT_POSTGRES_CONFIG-$K8S_NAMESPACE
export K8S_RELEASE_CX_KEYCLOAK=$CX_KEYCLOAK-$K8S_NAMESPACE
export K8S_RELEASE_CX_POSTGRES=$CX_KEYCLOAK-$K8S_NAMESPACE-postgresql
export K8S_RELEASE_CX_ARGOCD=$CX_ARGOCD-$K8S_NAMESPACE
export K8S_RELEASE_CX_CHARTMUSEUM=$CX_CHARTMUSEUM-$K8S_NAMESPACE




# --- Ingress
export K8S_INGRESS_CX_ARTIFACTORY=$K8S_RELEASE_CX_ARTIFACTORY.$K8S_DOMAINNAME
export K8S_INGRESS_CX_JENKINS=$K8S_RELEASE_CX_JENKINS.$K8S_DOMAINNAME
export K8S_INGRESS_CX_GERRIT=$K8S_RELEASE_CX_GERRIT.$K8S_DOMAINNAME
export K8S_INGRESS_CX_ARGO=$K8S_RELEASE_CX_ARGO.$K8S_DOMAINNAME
export K8S_INGRESS_CX_MINIO=$K8S_RELEASE_CX_MINIO.$K8S_DOMAINNAME
export K8S_INGRESS_CX_KEYCLOAK=$K8S_RELEASE_CX_KEYCLOAK.$K8S_DOMAINNAME
export K8S_INGRESS_CX_ARGOCD=$K8S_RELEASE_CX_ARGOCD.$K8S_DOMAINNAME
export K8S_INGRESS_CX_CHARTMUSEUM=$K8S_RELEASE_CX_CHARTMUSEUM.$K8S_DOMAINNAME



### Common Easy2Use DNS Service names
# ----- Cx Servicenames, External Ports, External Ports
export CX_GERRIT_SERVERNAME=$CX_GERRIT                  # OBS needed for Gerrit trigger config in shared pipeline code "cx-gerrit"
export CX_ARTIFACTORY=$K8S_RELEASE_CX_ARTIFACTORY
export CX_JENKINS=$K8S_RELEASE_CX_JENKINS
export CX_GERRIT=$K8S_RELEASE_CX_GERRIT
export CX_ARGO=$K8S_RELEASE_CX_ARGO
export CX_MINIO=$K8S_RELEASE_CX_MINIO
export CX_GERRIT_POSTGRES_CONFIG=$K8S_RELEASE_CX_GERRIT_POSTGRES_CONFIG
export CX_KEYCLOAK=$K8S_RELEASE_CX_KEYCLOAK
export CX_POSTGRES=$K8S_RELEASE_CX_POSTGRES
export CX_ARGOCD=$K8S_RELEASE_CX_ARGOCD
export CX_CHARTMUSEUM=$K8S_RELEASE_CX_CHARTMUSEUM


### Eiffel Bundle's REMREM URLs. so be seeded in Gerrit/GIT Projects Jenkisfile(s) 
export REMREM_PUBLISH_GEN_PUB_URL="http://eiffel-remrem-publish-${K8S_NAMESPACE}:8096/generateAndPublish?mp=eiffelsemantics&parseData=false&msgType="
export REMREM_GENERATE_URL="http://eiffel-remrem-generate-${K8S_NAMESPACE}:8095/eiffelsemantics?msgType="
export REMREM_PUBLISH_URL="http://eiffel-remrem-publish-${K8S_NAMESPACE}:8096/producer/msg?mp=eiffelsemantics"

export EI_FRONTEND_INGRESS="eiffel-frontend-${K8S_NAMESPACE}.$K8S_DOMAINNAME"
export EI_BACKEND_ARTIFACT_DNS="eiffel-backend-artifact-${K8S_NAMESPACE}"

### Eiffel Bundle's RABBITMQ 
export CX_RABBITMQ_URL="amqp://myuser:myuser@eiffel-rabbitmq-${K8S_NAMESPACE}.${K8S_NAMESPACE}:5672"
export CX_RABBITMQ_EXCHANGENAME=ei-poc-4

# Artifactory
export ARTIFACTORY_URL="${CX_ARTIFACTORY}-artifactory:${CX_ARTIFACTORY_EXTERNAL_PORT}"

# Image Registry 
export IMAGE_REGISTRY_PATH="${CX_IMAGE_REGISTRY}/${CX_IMAGE_REPOSITORY}"

### ---- set Environment variables for configurations
export K8S_ENV_CONFIG_CX_GERRIT="GERRIT_INIT_ARGS: '--install-plugin=download-commands'
WEBURL: 'http://${K8S_INGRESS_CX_GERRIT}'
DATABASE_TYPE: 'postgresql'
AUTH_TYPE: 'OAUTH'
DB_PORT_5432_TCP_ADDR: '${K8S_RELEASE_CX_POSTGRES}'
DB_PORT_5432_TCP_PORT: '${CX_POSTGRES_EXTERNAL_PORT}'
DB_ENV_POSTGRES_USER: '$CX_POSTGRES_USER'
DB_ENV_POSTGRES_PASSWORD: '$CX_POSTGRES_PSW'
DB_ENV_POSTGRES_DB: '$CX_POSTGRES_REVIEWDB'
K8S_RELEASE_CX_KEYCLOAK_URL: '${K8S_RELEASE_CX_KEYCLOAK}-http:${CX_KEYCLOAK_EXTERNAL_PORT}'
OAUTH_KEYCLOAK_CLIENT_ID: 'gerrit'
OAUTH_KEYCLOAK_CLIENT_SECRET: '650804e5-3fdd-424f-8316-a86466c357ab'
OAUTH_KEYCLOAK_REALM: 'easy2use'
OAUTH_KEYCLOAK_ROOT_URL: 'http://${K8S_INGRESS_CX_KEYCLOAK}'"


export K8S_ENV_CONFIG_CX_GERRIT_POSTGRES_SEED="PROXY_HOST: '${CX_GERRIT}'
CI_INIT_ADMIN: '${CX_GERRIT_CONFIG_CI_INIT_ADMIN}'
CI_INIT_PASSWORD: '${CX_GERRIT_CONFIG_CI_INIT_PASSWORD}'
CI_INIT_EMAIL: '${CX_GERRIT_CONFIG_CI_INIT_EMAIL}'
GERRIT_WEBURL: '${CX_GERRIT}:${CX_GERRIT_EXTERNAL_PORT}'
GERRIT_SERVERNAME_NO_PORT: '${CX_GERRIT_SERVERNAME}'
POSTGRES_URL: '${K8S_RELEASE_CX_POSTGRES}.${K8S_NAMESPACE}'
CX_POSTGRES_USER: '${CX_POSTGRES_USER}'
CX_POSTGRES_PSW: '${CX_POSTGRES_PSW}'
CX_POSTGRES_REVIEWDB: '${CX_POSTGRES_REVIEWDB}'
SSH_KEY_PATH: '${CX_GERRIT_CONFIG_SSH_KEY_PATH}'
GERRIT_SSH_PORT: '${CX_GERRIT_EXTERNAL_SSH_PORT}'
REMREM_PUBLISH_GEN_PUB_URL: '${REMREM_PUBLISH_GEN_PUB_URL}'
REMREM_GENERATE_URL: '${REMREM_GENERATE_URL}'
REMREM_PUBLISH_URL: '${REMREM_PUBLISH_URL}'
ARTIFACTORY_URL: '${CX_ARTIFACTORY}-artifactory:${CX_ARTIFACTORY_EXTERNAL_PORT}'
CX_IMAGE_REGISTRY: '${CX_IMAGE_REGISTRY}'
CX_IMAGE_REPOSITORY: '${CX_IMAGE_REPOSITORY}'
CX_NAMESPACE: '${K8S_NAMESPACE}'
GERRIT_INGRESS: '${K8S_INGRESS_CX_GERRIT}'
K8S_DOMAIN_NAME: '${K8S_DOMAINNAME}'"


# Jenkins Configs
export K8S_CONFIG_CX_JENKINS_JOB_MS_FRONTEND="<?xml version='1.1' encoding='UTF-8'?>
      <flow-definition plugin=\"workflow-job@2.31\">
        <actions>
          <org.jenkinsci.plugins.workflow.multibranch.JobPropertyTrackerAction plugin=\"workflow-multibranch@2.20\">
            <jobPropertyDescriptors>
              <string>hudson.model.ParametersDefinitionProperty</string>
              <string>org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty</string>
            </jobPropertyDescriptors>
          </org.jenkinsci.plugins.workflow.multibranch.JobPropertyTrackerAction>
        </actions>
        <description></description>
        <keepDependencies>false</keepDependencies>
        <properties>
          <hudson.model.ParametersDefinitionProperty>
            <parameterDefinitions>
              <hudson.model.StringParameterDefinition>
                <name>GERRIT_BRANCH</name>
                <description></description>
                <defaultValue>master</defaultValue>
                <trim>false</trim>
              </hudson.model.StringParameterDefinition>
              <hudson.model.StringParameterDefinition>
                <name>GERRIT_REFSPEC</name>
                <description></description>
                <defaultValue>refs/heads/master</defaultValue>
                <trim>false</trim>
              </hudson.model.StringParameterDefinition>
              <hudson.model.StringParameterDefinition>
                <name>GERRIT_CHANGE_NUMBER</name>
                <description></description>
                <defaultValue></defaultValue>
                <trim>false</trim>
              </hudson.model.StringParameterDefinition>
              <hudson.model.StringParameterDefinition>
                <name>GERRIT_PATCHSET_NUMBER</name>
                <description></description>
                <defaultValue></defaultValue>
                <trim>false</trim>
              </hudson.model.StringParameterDefinition>
              <hudson.model.StringParameterDefinition>
                <name>GERRIT_PATCHSET_REVISION</name>
                <description></description>
                <defaultValue></defaultValue>
                <trim>false</trim>
              </hudson.model.StringParameterDefinition>
              <hudson.model.StringParameterDefinition>
                <name>GERRIT_EVENT_TYPE</name>
                <description></description>
                <defaultValue>change-merged</defaultValue>
                <trim>false</trim>
              </hudson.model.StringParameterDefinition>
            </parameterDefinitions>
          </hudson.model.ParametersDefinitionProperty>
          <org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
            <triggers>
              <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger plugin=\"gerrit-trigger@2.28.0\">
                <spec></spec>
                <gerritProjects>
                  <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.GerritProject>
                    <compareType>PLAIN</compareType>
                    <pattern>ms-frontend</pattern>
                    <branches>
                      <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.Branch>
                        <compareType>ANT</compareType>
                        <pattern>**</pattern>
                      </com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.Branch>
                    </branches>
                    <disableStrictForbiddenFileVerification>false</disableStrictForbiddenFileVerification>
                  </com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.GerritProject>
                </gerritProjects>
                <dynamicGerritProjects class=\"empty-list\"/>
                <skipVote>
                  <onSuccessful>false</onSuccessful>
                  <onFailed>false</onFailed>
                  <onUnstable>false</onUnstable>
                  <onNotBuilt>false</onNotBuilt>
                </skipVote>
                <silentMode>true</silentMode>
                <notificationLevel></notificationLevel>
                <silentStartMode>false</silentStartMode>
                <escapeQuotes>true</escapeQuotes>
                <nameAndEmailParameterMode>PLAIN</nameAndEmailParameterMode>
                <dependencyJobsNames></dependencyJobsNames>
                <commitMessageParameterMode>BASE64</commitMessageParameterMode>
                <changeSubjectParameterMode>PLAIN</changeSubjectParameterMode>
                <commentTextParameterMode>BASE64</commentTextParameterMode>
                <buildStartMessage></buildStartMessage>
                <buildFailureMessage></buildFailureMessage>
                <buildSuccessfulMessage></buildSuccessfulMessage>
                <buildUnstableMessage></buildUnstableMessage>
                <buildNotBuiltMessage></buildNotBuiltMessage>
                <buildUnsuccessfulFilepath></buildUnsuccessfulFilepath>
                <customUrl></customUrl>
                <serverName>cx-gerrit</serverName>
                <triggerOnEvents>
                  <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginPatchsetCreatedEvent>
                    <excludeDrafts>false</excludeDrafts>
                    <excludeTrivialRebase>false</excludeTrivialRebase>
                    <excludeNoCodeChange>false</excludeNoCodeChange>
                  </com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginPatchsetCreatedEvent>
                  <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginChangeMergedEvent/>
                </triggerOnEvents>
                <dynamicTriggerConfiguration>false</dynamicTriggerConfiguration>
                <triggerConfigURL></triggerConfigURL>
                <triggerInformationAction/>
              </com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger>
            </triggers>
          </org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
        </properties>
        <definition class=\"org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition\" plugin=\"workflow-cps@2.61\">
          <scm class=\"hudson.plugins.git.GitSCM\" plugin=\"git@3.9.1\">
            <configVersion>2</configVersion>
            <userRemoteConfigs>
              <hudson.plugins.git.UserRemoteConfig>
                <url>http://${K8S_RELEASE_CX_GERRIT}:${CX_GERRIT_INTERNAL_PORT}/ms-frontend</url>
                <credentialsId>GERRIT_CREDENTIALS</credentialsId>
              </hudson.plugins.git.UserRemoteConfig>
            </userRemoteConfigs>
            <branches>
              <hudson.plugins.git.BranchSpec>
                <name>*/master</name>
              </hudson.plugins.git.BranchSpec>
            </branches>
            <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
            <submoduleCfg class=\"list\"/>
            <extensions/>
          </scm>
          <scriptPath>Jenkinsfile</scriptPath>
          <lightweight>false</lightweight>
        </definition>
        <triggers/>
        <disabled>false</disabled>
      </flow-definition>"


# Only build ms-backend in Argo Workflow engine included in Cx bundle
# export K8S_CONFIG_CX_JENKINS_JOB_MS_BACKEND="<?xml version='1.1' encoding='UTF-8'?>
#       <flow-definition plugin=\"workflow-job@2.31\">
#         <actions>
#           <org.jenkinsci.plugins.workflow.multibranch.JobPropertyTrackerAction plugin=\"workflow-multibranch@2.20\">
#             <jobPropertyDescriptors>
#               <string>hudson.model.ParametersDefinitionProperty</string>
#               <string>org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty</string>
#             </jobPropertyDescriptors>
#           </org.jenkinsci.plugins.workflow.multibranch.JobPropertyTrackerAction>
#         </actions>
#         <description></description>
#         <keepDependencies>false</keepDependencies>
#         <properties>
#           <hudson.model.ParametersDefinitionProperty>
#             <parameterDefinitions>
#               <hudson.model.StringParameterDefinition>
#                 <name>GERRIT_BRANCH</name>
#                 <description></description>
#                 <defaultValue>master</defaultValue>
#                 <trim>false</trim>
#               </hudson.model.StringParameterDefinition>
#               <hudson.model.StringParameterDefinition>
#                 <name>GERRIT_REFSPEC</name>
#                 <description></description>
#                 <defaultValue>refs/heads/master</defaultValue>
#                 <trim>false</trim>
#               </hudson.model.StringParameterDefinition>
#               <hudson.model.StringParameterDefinition>
#                 <name>GERRIT_CHANGE_NUMBER</name>
#                 <description></description>
#                 <defaultValue></defaultValue>
#                 <trim>false</trim>
#               </hudson.model.StringParameterDefinition>
#               <hudson.model.StringParameterDefinition>
#                 <name>GERRIT_PATCHSET_NUMBER</name>
#                 <description></description>
#                 <defaultValue></defaultValue>
#                 <trim>false</trim>
#               </hudson.model.StringParameterDefinition>
#               <hudson.model.StringParameterDefinition>
#                 <name>GERRIT_PATCHSET_REVISION</name>
#                 <description></description>
#                 <defaultValue></defaultValue>
#                 <trim>false</trim>
#               </hudson.model.StringParameterDefinition>
#               <hudson.model.StringParameterDefinition>
#                 <name>GERRIT_EVENT_TYPE</name>
#                 <description></description>
#                 <defaultValue>change-merged</defaultValue>
#                 <trim>false</trim>
#               </hudson.model.StringParameterDefinition>
#             </parameterDefinitions>
#           </hudson.model.ParametersDefinitionProperty>
#           <org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
#             <triggers>
#               <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger plugin=\"gerrit-trigger@2.28.0\">
#                 <spec></spec>
#                 <gerritProjects>
#                   <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.GerritProject>
#                     <compareType>PLAIN</compareType>
#                     <pattern>ms-backend</pattern>
#                     <branches>
#                       <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.Branch>
#                         <compareType>ANT</compareType>
#                         <pattern>**</pattern>
#                       </com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.Branch>
#                     </branches>
#                     <disableStrictForbiddenFileVerification>false</disableStrictForbiddenFileVerification>
#                   </com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.GerritProject>
#                 </gerritProjects>
#                 <dynamicGerritProjects class=\"empty-list\"/>
#                 <skipVote>
#                   <onSuccessful>false</onSuccessful>
#                   <onFailed>false</onFailed>
#                   <onUnstable>false</onUnstable>
#                   <onNotBuilt>false</onNotBuilt>
#                 </skipVote>
#                 <silentMode>true</silentMode>
#                 <notificationLevel></notificationLevel>
#                 <silentStartMode>false</silentStartMode>
#                 <escapeQuotes>true</escapeQuotes>
#                 <nameAndEmailParameterMode>PLAIN</nameAndEmailParameterMode>
#                 <dependencyJobsNames></dependencyJobsNames>
#                 <commitMessageParameterMode>BASE64</commitMessageParameterMode>
#                 <changeSubjectParameterMode>PLAIN</changeSubjectParameterMode>
#                 <commentTextParameterMode>BASE64</commentTextParameterMode>
#                 <buildStartMessage></buildStartMessage>
#                 <buildFailureMessage></buildFailureMessage>
#                 <buildSuccessfulMessage></buildSuccessfulMessage>
#                 <buildUnstableMessage></buildUnstableMessage>
#                 <buildNotBuiltMessage></buildNotBuiltMessage>
#                 <buildUnsuccessfulFilepath></buildUnsuccessfulFilepath>
#                 <customUrl></customUrl>
#                 <serverName>cx-gerrit</serverName>
#                 <triggerOnEvents>
#                   <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginPatchsetCreatedEvent>
#                     <excludeDrafts>false</excludeDrafts>
#                     <excludeTrivialRebase>false</excludeTrivialRebase>
#                     <excludeNoCodeChange>false</excludeNoCodeChange>
#                   </com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginPatchsetCreatedEvent>
#                   <com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginChangeMergedEvent/>
#                 </triggerOnEvents>
#                 <dynamicTriggerConfiguration>false</dynamicTriggerConfiguration>
#                 <triggerConfigURL></triggerConfigURL>
#                 <triggerInformationAction/>
#               </com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger>
#             </triggers>
#           </org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
#         </properties>
#         <definition class=\"org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition\" plugin=\"workflow-cps@2.61\">
#           <scm class=\"hudson.plugins.git.GitSCM\" plugin=\"git@3.9.1\">
#             <configVersion>2</configVersion>
#             <userRemoteConfigs>
#               <hudson.plugins.git.UserRemoteConfig>
#                 <url>http://${K8S_RELEASE_CX_GERRIT}:${CX_GERRIT_INTERNAL_PORT}/ms-backend</url>
#                 <credentialsId>GERRIT_CREDENTIALS</credentialsId>
#               </hudson.plugins.git.UserRemoteConfig>
#             </userRemoteConfigs>
#             <branches>
#               <hudson.plugins.git.BranchSpec>
#                 <name>*/master</name>
#               </hudson.plugins.git.BranchSpec>
#             </branches>
#             <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
#             <submoduleCfg class=\"list\"/>
#             <extensions/>
#           </scm>
#           <scriptPath>Jenkinsfile</scriptPath>
#           <lightweight>false</lightweight>
#         </definition>
#         <triggers/>
#         <disabled>false</disabled>
#       </flow-definition>"  



export K8S_CONFIG_CX_JENKINS_GERRIT_TRIGGER_CONFIG="<?xml version='1.1' encoding='UTF-8'?>
          <com.sonyericsson.hudson.plugins.gerrit.trigger.PluginImpl plugin=\"gerrit-trigger@2.28.0\">
            <servers class=\"java.util.concurrent.CopyOnWriteArrayList\">
              <com.sonyericsson.hudson.plugins.gerrit.trigger.GerritServer>
                <name>cx-gerrit</name>
                <noConnectionOnStartup>false</noConnectionOnStartup>
                <config class=\"com.sonyericsson.hudson.plugins.gerrit.trigger.config.Config\">
                  <gerritHostName>${K8S_RELEASE_CX_GERRIT}</gerritHostName>
                  <gerritSshPort>${CX_GERRIT_INTERNAL_SSH_PORT}</gerritSshPort>
                  <gerritProxy></gerritProxy>
                  <gerritUserName>easy2use</gerritUserName>
                  <gerritEMail></gerritEMail>
                  <gerritAuthKeyFile>/var/jenkins_home/gerrit-id-rsa</gerritAuthKeyFile>
                  <gerritAuthKeyFilePassword>{AQAAABAAAAAQouppJrsdJzwkRsz/dPywiUiRVB2FCFFDyvMRpQ6lOAU=}</gerritAuthKeyFilePassword>
                  <useRestApi>false</useRestApi>
                  <gerritHttpUserName>easy2use</gerritHttpUserName>
                  <gerritHttpPassword>{gX6aUy55fjSgJfldDItW2WiCpoiid+2tK9FyqayQlg}</gerritHttpPassword>
                  <restCodeReview>true</restCodeReview>
                  <restVerified>true</restVerified>
                  <gerritVerifiedCmdBuildSuccessful>gerrit review &lt;CHANGE&gt;\,&lt;PATCHSET&gt; --message &apos;Build Successful &lt;BUILDS_STATS&gt;&apos; --verified &lt;VERIFIED&gt; --code-review &lt;CODE_REVIEW&gt; --tag autogenerated:jenkins-gerrit-trigger</gerritVerifiedCmdBuildSuccessful>
                  <gerritVerifiedCmdBuildUnstable>gerrit review &lt;CHANGE&gt;\,&lt;PATCHSET&gt; --message &apos;Build Unstable &lt;BUILDS_STATS&gt;&apos; --verified &lt;VERIFIED&gt; --code-review &lt;CODE_REVIEW&gt; --tag autogenerated:jenkins-gerrit-trigger</gerritVerifiedCmdBuildUnstable>
                  <gerritVerifiedCmdBuildFailed>gerrit review &lt;CHANGE&gt;\,&lt;PATCHSET&gt; --message &apos;Build Failed &lt;BUILDS_STATS&gt;&apos; --verified &lt;VERIFIED&gt; --code-review &lt;CODE_REVIEW&gt; --tag autogenerated:jenkins-gerrit-trigger</gerritVerifiedCmdBuildFailed>
                  <gerritVerifiedCmdBuildStarted>gerrit review &lt;CHANGE&gt;\,&lt;PATCHSET&gt; --message &apos;Build Started &lt;BUILDURL&gt; &lt;STARTED_STATS&gt;&apos; --verified &lt;VERIFIED&gt; --code-review &lt;CODE_REVIEW&gt; --tag autogenerated:jenkins-gerrit-trigger</gerritVerifiedCmdBuildStarted>
                  <gerritVerifiedCmdBuildNotBuilt>gerrit review &lt;CHANGE&gt;\,&lt;PATCHSET&gt; --message &apos;No Builds Executed &lt;BUILDS_STATS&gt;&apos; --verified &lt;VERIFIED&gt; --code-review &lt;CODE_REVIEW&gt; --tag autogenerated:jenkins-gerrit-trigger</gerritVerifiedCmdBuildNotBuilt>
                  <gerritFrontEndUrl>http://${K8S_RELEASE_CX_GERRIT}:${CX_GERRIT_INTERNAL_PORT}/</gerritFrontEndUrl>
                  <gerritBuildStartedVerifiedValue>0</gerritBuildStartedVerifiedValue>
                  <gerritBuildSuccessfulVerifiedValue>1</gerritBuildSuccessfulVerifiedValue>
                  <gerritBuildFailedVerifiedValue>-1</gerritBuildFailedVerifiedValue>
                  <gerritBuildUnstableVerifiedValue>0</gerritBuildUnstableVerifiedValue>
                  <gerritBuildNotBuiltVerifiedValue>0</gerritBuildNotBuiltVerifiedValue>
                  <gerritBuildStartedCodeReviewValue>0</gerritBuildStartedCodeReviewValue>
                  <gerritBuildSuccessfulCodeReviewValue>0</gerritBuildSuccessfulCodeReviewValue>
                  <gerritBuildFailedCodeReviewValue>0</gerritBuildFailedCodeReviewValue>
                  <gerritBuildUnstableCodeReviewValue>-1</gerritBuildUnstableCodeReviewValue>
                  <gerritBuildNotBuiltCodeReviewValue>0</gerritBuildNotBuiltCodeReviewValue>
                  <enableManualTrigger>true</enableManualTrigger>
                  <enablePluginMessages>true</enablePluginMessages>
                  <triggerOnAllComments>false</triggerOnAllComments>
                  <buildScheduleDelay>3</buildScheduleDelay>
                  <dynamicConfigRefreshInterval>30</dynamicConfigRefreshInterval>
                  <enableProjectAutoCompletion>true</enableProjectAutoCompletion>
                  <projectListRefreshInterval>3600</projectListRefreshInterval>
                  <projectListFetchDelay>0</projectListFetchDelay>
                  <categories class=\"linked-list\">
                    <com.sonyericsson.hudson.plugins.gerrit.trigger.VerdictCategory>
                      <verdictValue>Code-Review</verdictValue>
                      <verdictDescription>Code Review</verdictDescription>
                    </com.sonyericsson.hudson.plugins.gerrit.trigger.VerdictCategory>
                    <com.sonyericsson.hudson.plugins.gerrit.trigger.VerdictCategory>
                      <verdictValue>Verified</verdictValue>
                      <verdictDescription>Verified</verdictDescription>
                    </com.sonyericsson.hudson.plugins.gerrit.trigger.VerdictCategory>
                  </categories>
                  <replicationConfig>
                    <enableReplication>false</enableReplication>
                    <slaves class=\"linked-list\"/>
                    <enableSlaveSelectionInJobs>false</enableSlaveSelectionInJobs>
                  </replicationConfig>
                  <watchdogTimeoutMinutes>0</watchdogTimeoutMinutes>
                  <watchTimeExceptionData>
                    <daysOfWeek/>
                    <timesOfDay class=\"linked-list\"/>
                  </watchTimeExceptionData>
                  <notificationLevel>ALL</notificationLevel>
                  <buildCurrentPatchesOnly>
                    <enabled>false</enabled>
                    <abortNewPatchsets>false</abortNewPatchsets>
                    <abortManualPatchsets>false</abortManualPatchsets>
                    <abortSameTopic>false</abortSameTopic>
                  </buildCurrentPatchesOnly>
                </config>
              </com.sonyericsson.hudson.plugins.gerrit.trigger.GerritServer>
            </servers>
            <pluginConfig>
              <numberOfReceivingWorkerThreads>3</numberOfReceivingWorkerThreads>
              <numberOfSendingWorkerThreads>1</numberOfSendingWorkerThreads>
              <replicationCacheExpirationInMinutes>360</replicationCacheExpirationInMinutes>
            </pluginConfig>
          </com.sonyericsson.hudson.plugins.gerrit.trigger.PluginImpl>"




export K8S_CONFIG_CX_JENKINS_GERRIT_ID_RSA="-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAt+8O89E7lclx6hROia4/5rsdtvWi9cmkulCwvytFqN2GQGuZ
puL2wCGDLPGwwVxNiwBEsh7M5rxJRUsfvJqTGi8T8ygAGcjtBZjprGbXHrf5aRt1
Y9QEe346VZXpp1nZeXqf062EXMDr9ntZcSaAGAwfAUI+rq3g84FbflVHsSLbri3t
pCfpfm38PTHtJfPav6THXQyvfuDI4e8X1KC6WVe7GRN17g60sOoMR/WOu49tJLwC
YvFUNuTxIe4mHeWbL+hNXMr1XSWDU4u8cI/Wf7EHs4kzMUtmMJRKHiZTTCsSZt+n
2G46edncDArut39RkiW6C03r7FzryK52zzYgAwIDAQABAoIBAFEoTSuttaHY2ceU
IDdFyHJRO8I/ziCvUVzYP7SKLlldLWB9WbW2TXPnFY8eMYSP6rMbcjQ5vOVOTPIj
PKSme6PBBAd1Ld4ytsqSdwCX+/FU8dq7v+dFZJjs0GZ1GDy8O2YLgjwPQuj+Qt9l
+8geWcTCjGesyCWhGTG4cRtkG5b/b5GPUb2D4SMzkned5675+nSYKyIujRwoJTqy
E6zmLUYu/uf/TLI2BQixAoU79DKdOCVBx9axqJTsqFuIE3XxMXxlZJyUfTSduE29
svgclRRzNsMp0qsS3QMpknyhnTfEnbs7mSpIMhfU/Uj9vJTQTZad0qRhyN/cC31k
+RX4AqkCgYEA562bS+gk3OUaxYFo6F7AUOwY6oLRqyEZikdZvPP8XWXckCpbq+8U
qwAMyDH0vZOfPiCV4lM4XBa/Kabg6X4AG6E3K6W9bwWdY5qFrh0x4dnuyqKSIAQN
H8fcEjCioLkvdkdSvVG0aiZkHgGu9TRHVq2OUiDRaZd51Wypxho6mX0CgYEAyz5Q
ZoA/ys2juahimvpWu9liPRkteDET3z3WZOYz9v9lD6gdMXJeRLvMG2wcg5TnuO6D
Vjpu+Vwde0XlGQSZ/yrFIWD+H2Go/ttLFbOqC3qZH6mREGykqIjeRX0ZYBID0imv
I1Pjn3Ce6EuvT56+UdIMvYNYlOh+GVSEC07s138CgYEAgCSVJgoUAZ4zDZVDimuG
IfxE18ld4TKgpsxKRWoKZzqFIbRcGiBWJTMU3tJK1WTGip2JabKwFLd8KrSj6GIJ
+z5Tfq/gtHy9ji8Uy7ZYNdzN6IS9IDo9bBumjOUbvpxPNTPD/vUnPiNX8wTpWbT9
1GKQurpuOeJPwA2nZexyBx0CgYBXrvCc6COdaQ6DoIO5/NrCfEyHs38MZY//Nfxy
12X/37tH/+1oUcEdwi+SfRfoJKu7+xqqbtdFuVn2vvbRzkxp65fUiLXZ8BYqrY09
NZ/dB+1b3Zn6DgUTuMi8DfaOnfcMCnPGuABx3vKPoWdm4EOXpRleAXaL96m/X9j/
z/MaHQKBgBjatnldzQFxv1/29ImJWdSdRhCE0sLcWZK9aVVYc8AUS9WDh9WVTrmp
P55ZSVVBgyw5M1fZ3G0wkqKGJQm3D4h8h3r8ATDkSFS5TvIxCcQXbwkUlIT3KVeY
srkJhe+yrkINseLDEtrJB/3z/ozOjgSBM5CAasEIR2Hl+bhLC0R2
-----END RSA PRIVATE KEY-----"



###################################################################
## Cx Bundle app context paths (added to apps Ingress URLs)
export app_url_context_path="
Cx Bundle URLs contextPath:
--------------------------
ms-frontend contextPath: /api/greeting
ms-backend contextPath: /api/hellobackend"


## Cx Bundle Passwords listings
export easy2use_bundle_psw="
Cx Bundle Users/Passwords:
--------------------------
cx_jenkins: ${CX_JENKINS_CONFIG_CI_INIT_ADMIN} / ${CX_JENKINS_CONFIG_CI_INIT_PASSWORD} 
cx_gerrit: ${CX_GERRIT_CONFIG_CI_INIT_ADMIN} / ${CX_GERRIT_CONFIG_CI_INIT_PASSWORD_CLEAR} 
Git 'push' to Gerrit: ${CX_GERRIT_CONFIG_CI_INIT_ADMIN} / ${CX_GERRIT_CONFIG_CI_INIT_PASSWORD} 
cx_artifactory: admin / password 
cx_jenkins: ${CX_JENKINS_CONFIG_CI_INIT_ADMIN}/${CX_JENKINS_CONFIG_CI_INIT_PASSWORD} 
cx_minio: AKIAIOSFODNN7EXAMPLE / wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY 
cx_keycloak: ${CX_KEYCLOAK_CONFIG_CI_INIT_ADMIN} / ${CX_KEYCLOAK_CONFIG_CI_INIT_PASSWORD} 
cx_postgresql: ${CX_POSTGRES_USER} / ${CX_POSTGRES_PSW} 
eiffel_rabbitmq: myuser / myuser
gitops_minio: ${CX_MINIO_CONFIG_CI_INIT_ADMIN} / ${CX_MINIO_CONFIG_CI_INIT_PASSWORD}
gitops_argocd: ${CX_ARGOCD_USERNAME} / $(kubectl get pod -n ${K8S_NAMESPACE} -l app.kubernetes.io/name=argo-cd-server -o name | cut -d'/' -f 2)"

###################################################################