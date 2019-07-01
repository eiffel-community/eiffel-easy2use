
## Eiffel Configurations

JENKINS_EIFFEL_CONFIG="<?xml version='1.0' encoding='UTF-8'?>
<com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration-EiffelJenkinsGlobalConfigurationDescriptor plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
  <arms class=\"java.util.Collections$UnmodifiableMap\">
    <m class=\"linked-hash-map\">
      <entry>
        <string>0</string>
        <com.ericsson.eiffel.fem.config.JenkinsCryptographicArm>
          <id>0</id>
          <description>${EIFFEL_JENKINS_FEM_NEXUS_DESCRIPTION}</description>
          <httpString>${EIFFEL_NEXUS_URL}</httpString>
          <downloadRepoName>${EIFFEL_JENKINS_FEM_NEXUS_DOWNLOAD_REPO_NAME}</downloadRepoName>
          <uploadRepoName>${EIFFEL_JENKINS_FEM_NEXUS_UPLOAD_REPO_NAME}</uploadRepoName>
          <credentials>
            <name>${EIFFEL_NEXUS_USER}</name>
            <password>${EIFFEL_NEXUS_PASSWORD}</password>
          </credentials>
        </com.ericsson.eiffel.fem.config.JenkinsCryptographicArm>
      </entry>
    </m>
  </arms>
  <messageBus>
    <hostName>${EIFFEL_RABBITMQ}</hostName>
    <port>${EIFFEL_RABBITMQ_AMQP_APPLICATION_PORT}</port>
    <exchangeName>${EIFFEL_RABBITMQ_EXCHANGE}</exchangeName>
    <componentName>${EIFFEL_JENKINS_FEM_RABBITMQ_COMPONENT_NAME}</componentName>
    <protocol>${EIFFEL_JENKINS_FEM_RABBITMQ_PROTOCOL}</protocol>
    <createExchangeIfNotExisting>${EIFFEL_JENKINS_FEM_RABBITMQ_CREATE_EXCHANGE}</createExchangeIfNotExisting>
    <credentials>
      <name>${EIFFEL_RABBITMQ_USER}</name>
      <password>${EIFFEL_RABBITMQ_PASSWORD}</password>
    </credentials>
  </messageBus>
  <domainId>${EIFFEL_RABBITMQ_DOMAIN_ID}</domainId>
  <remremGenerateUrl>${EIFFEL_REMREM_GENERATE_URL}</remremGenerateUrl>
  <remremPublishUrl>${EIFFEL_REMREM_PUBLISH_URL}</remremPublishUrl>
  <remremLdapUserName>${EIFFEL_REMREM_USER}</remremLdapUserName>
  <remremLdapPassword>${EIFFEL_REMREM_PASSWORD}</remremLdapPassword>
  <erRestUrl>${EIFFEL_ER_REST_URL}</erRestUrl>
  <bypassIO>${EIFFEL_JENKINS_FEM_BYPASS_IO}</bypassIO>
</com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration-EiffelJenkinsGlobalConfigurationDescriptor>"

## Jenkins security configurations

JENKINS_SECURITY_CONFIG="#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(\"admin\", \"admin\")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()

Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)"


## Jenkins jobs configurations

EI_ARTIFACT_TRIG_JOB="<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <scriptEnabled>false</scriptEnabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty>
    <com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <flowContext></flowContext>
    </com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty>
    <com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
    </com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <implicitMessagingEnabled>true</implicitMessagingEnabled>
      <eiffelActivityFinishedEventDisabled>false</eiffelActivityFinishedEventDisabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty>
    <com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <userDomainSuffix></userDomainSuffix>
    </com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty>
  </properties>
  <scm class=\"hudson.scm.NullSCM\"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>echo &quot;Job Triggered via Eiffel Intelligence Artifact Subscription&quot;</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>
"

EI_ARTIFACT_PARAMETER_TRIG_JOB="<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <scriptEnabled>false</scriptEnabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty>
    <com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <flowContext></flowContext>
    </com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty>
    <com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
    </com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <implicitMessagingEnabled>true</implicitMessagingEnabled>
      <eiffelActivityFinishedEventDisabled>false</eiffelActivityFinishedEventDisabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty>
    <com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <userDomainSuffix></userDomainSuffix>
    </com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty>
  </properties>
  <scm class=\"hudson.scm.NullSCM\"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>echo &quot;Job Triggered via Eiffel Intelligence Artifact Subscription&quot;</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>"

EI_SOURCECHANGE_TRIG_JOB="<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <scriptEnabled>false</scriptEnabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty>
    <com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <flowContext></flowContext>
    </com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty>
    <com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
    </com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <implicitMessagingEnabled>true</implicitMessagingEnabled>
      <eiffelActivityFinishedEventDisabled>false</eiffelActivityFinishedEventDisabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty>
    <com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <userDomainSuffix></userDomainSuffix>
    </com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty>
  </properties>
  <scm class=\"hudson.scm.NullSCM\"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>echo &quot;Job Triggered via Eiffel Intelligence SourceChange Subscription&quot;</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>"

EI_TESTEXECUTION_TRIG_JOB="<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <scriptEnabled>false</scriptEnabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty>
    <com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <flowContext></flowContext>
    </com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty>
    <com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>true</enabled>
    </com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <implicitMessagingEnabled>false</implicitMessagingEnabled>
      <eiffelActivityFinishedEventDisabled>false</eiffelActivityFinishedEventDisabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty>
    <com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <userDomainSuffix></userDomainSuffix>
    </com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty>
  </properties>
  <scm class=\"hudson.scm.NullSCM\"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>echo &quot;Job Triggered via Eiffel Intelligence TestExecution Subscription&quot;</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>"

EVENT_TRIGGRED_JOB="<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <scriptEnabled>false</scriptEnabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty>
    <com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <flowContext></flowContext>
    </com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty>
    <com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>true</enabled>
    </com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <implicitMessagingEnabled>true</implicitMessagingEnabled>
      <eiffelActivityFinishedEventDisabled>false</eiffelActivityFinishedEventDisabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty>
    <com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <userDomainSuffix></userDomainSuffix>
    </com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty>
  </properties>
  <scm class=\"hudson.scm.NullSCM\"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers>
    <com.ericsson.eiffel.fem.triggering.GroovyTriggerFacade plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <spec></spec>
      <bindingKey>#</bindingKey>
      <keepQueue>false</keepQueue>
      <file></file>
      <script>if (message.get(&quot;meta&quot;).get(&quot;type&quot;).equals(&quot;EiffelArtifactCreatedEvent&quot;)) {
        log.info(&quot;Received a JFE from Trigger&quot;);
    queue.unique(message);
    }</script>
      <maxQueueLength>0</maxQueueLength>
    </com.ericsson.eiffel.fem.triggering.GroovyTriggerFacade>
  </triggers>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>echo &quot;Job Triggered via Event&quot;</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>"

SEND_EIFFEL_EVENT_JOB="<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description>Sends EiffelArtifactCreatedEvent &amp; Activity events</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <scriptEnabled>false</scriptEnabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty>
    <com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <flowContext></flowContext>
    </com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty>
    <com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
    </com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <implicitMessagingEnabled>true</implicitMessagingEnabled>
      <eiffelActivityFinishedEventDisabled>false</eiffelActivityFinishedEventDisabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty>
    <com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <userDomainSuffix></userDomainSuffix>
    </com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty>
  </properties>
  <scm class=\"hudson.scm.NullSCM\"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <com.ericsson.eiffel.fem.messaging.EiffelMessageDispatcherBuildStep plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <inputJson>{
  &quot;msgParams&quot;: {
    &quot;meta&quot;: {
      &quot;type&quot;: &quot;EiffelArtifactCreatedEvent&quot;,
      &quot;version&quot;: &quot;3.0.0&quot;,
      &quot;tags&quot;: [],
      &quot;source&quot;: {
        &quot;domainId&quot;: &quot;example.domain&quot;
      },
      &quot;security&quot;: {
        &quot;authorIdentity&quot;: &quot;required if sdm present&quot;
      }

    }
  },
  &quot;eventParams&quot;: {
    &quot;data&quot;: {
      &quot;identity&quot;: &quot;pkg:maven/com.othercompany.library/required@required&quot;,
      &quot;fileInformation&quot;: [
        {
          &quot;name&quot;: &quot;required&quot;,
          &quot;classifier&quot;: &quot;exec&quot;,
          &quot;extension&quot;: &quot;jar&quot;
        }
      ],
      &quot;buildCommand&quot;: &quot;&quot;,
      &quot;requiresImplementation&quot;: &quot;&quot;,
      &quot;name&quot;: &quot;&quot;,
      &quot;dependsOn&quot;: [],
      &quot;implements&quot;: [],
      &quot;customData&quot;: []
    },
    &quot;links&quot;: []
  }
}</inputJson>
      <customGenerateURL></customGenerateURL>
      <customPublishURL></customPublishURL>
      <eiffelMessageGenerator class=\"com.ericsson.eiffel.fem.messaging.EiffelMessageGeneratorImpl\"/>
      <eventType>EiffelArtifactCreatedEvent</eventType>
    </com.ericsson.eiffel.fem.messaging.EiffelMessageDispatcherBuildStep>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>"

UPLOAD_ARTIFACT_TO_ARM_CURL_JOB="<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description>Uploading artifact to Nexus3 and send EiffelArtifactCreatedEvent</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <scriptEnabled>false</scriptEnabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingContributorProperty>
    <com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <flowContext></flowContext>
    </com.ericsson.eiffel.fem.messaging.EiffelMessageFlowContextJobProperty>
    <com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
    </com.ericsson.eiffel.fem.injection.EiffelVariableInjectionJobProperty>
    <com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <implicitMessagingEnabled>false</implicitMessagingEnabled>
      <eiffelActivityFinishedEventDisabled>false</eiffelActivityFinishedEventDisabled>
    </com.ericsson.eiffel.fem.messaging.ImplicitEiffelMessagingJobProperty>
    <com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <enabled>false</enabled>
      <userDomainSuffix></userDomainSuffix>
    </com.ericsson.eiffel.fem.messaging.UserDomainSuffixJobProperty>
  </properties>
  <scm class=\"hudson.scm.NullSCM\"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>curl -O https://jitpack.io/com/github/Ericsson/eiffel-remrem-generate/generate-service/0.9.8/generate-service-0.9.8.war
                ls</command>
    </hudson.tasks.Shell>
    <hudson.tasks.Shell>
<command>curl -v -u ${EIFFEL_NEXUS_USER}:${EIFFEL_NEXUS_PASSWORD} --upload-file ./generate-service-0.9.8.war ${EIFFEL_NEXUS_URL}/repository/maven-releases/com/ericsson/eiffel/generate-service/0.9.8/generate-service-0.9.8.war            </command>
    </hudson.tasks.Shell>
    <com.ericsson.eiffel.fem.messaging.EiffelMessageDispatcherBuildStep plugin=\"eiffel-fem-${EIFFEL_JENKINS_PLUGIN_VERSION}\">
      <inputJson>{
  &quot;msgParams&quot;: {
    &quot;meta&quot;: {
      &quot;type&quot;: &quot;EiffelArtifactCreatedEvent&quot;,
      &quot;version&quot;: &quot;3.0.0&quot;,
      &quot;tags&quot;: [],
      &quot;source&quot;: {
        &quot;domainId&quot;: &quot;&quot;,
        &quot;host&quot;: &quot;&quot;,
        &quot;name&quot;: &quot;&quot;,
        &quot;uri&quot;: &quot;&quot;
      },
      &quot;security&quot;: {
        &quot;authorIdentity&quot;: &quot;required if sdm present&quot;
      }
    }
  },
  &quot;eventParams&quot;: {
    &quot;data&quot;: {
      &quot;identity&quot;: &quot;pkg:maven/com.ericsson.eiffel/generate-service@0.9.8 &quot;,
      &quot;fileInformation&quot;: [
        { 
          &quot;name&quot;: &quot;RemRem-Generate&quot;,
          &quot;classifier&quot;: &quot;exec&quot;,
          &quot;extension&quot;: &quot;war&quot;
        }
      ],
      &quot;buildCommand&quot;: &quot;&quot;,
      &quot;requiresImplementation&quot;: &quot;&quot;,
      &quot;name&quot;: &quot;&quot;,
      &quot;dependsOn&quot;: [],
      &quot;implements&quot;: [],
      &quot;customData&quot;: []
    },
    &quot;links&quot;: []
  }
}</inputJson>
      <customGenerateURL></customGenerateURL>
      <customPublishURL></customPublishURL>
      <eiffelMessageGenerator class=\"com.ericsson.eiffel.fem.messaging.EiffelMessageGeneratorImpl\"/>
      <eventType>EiffelArtifactCreatedEvent</eventType>
    </com.ericsson.eiffel.fem.messaging.EiffelMessageDispatcherBuildStep>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>"

PREPARE_CONFIG_FILES_SCRIPT="#!/bin/bash
mkdir -p /var/jenkins_tmp
cp /var/jenkins_tmp/com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration.xml /var/jenkins_home/com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration.xml
mkdir -p /usr/share/jenkins/ref/init.groovy.d
cp /var/jenkins_tmp/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
mkdir -p /var/jenkins_home/jobs/ei-artifact-triggered-job
cp /var/jenkins_tmp/ei-artifact-triggered-job-config.xml /var/jenkins_home/jobs/ei-artifact-triggered-job/config.xml
mkdir -p /var/jenkins_home/jobs/ei-artifact-triggered-parameterized-job
cp /var/jenkins_tmp/ei-artifact-triggered-parameterized-job-config.xml /var/jenkins_home/jobs/ei-artifact-triggered-parameterized-job/config.xml
mkdir -p /var/jenkins_home/jobs/ei-sourcechange-triggered-job
cp /var/jenkins_tmp/ei-sourcechange-triggered-job-config.xml /var/jenkins_home/jobs/ei-sourcechange-triggered-job/config.xml
mkdir -p /var/jenkins_home/jobs/ei-testexecution-triggered-job
cp /var/jenkins_tmp/ei-testexecution-triggered-job-config.xml /var/jenkins_home/jobs/ei-testexecution-triggered-job/config.xml
mkdir -p /var/jenkins_home/jobs/event-triggered-job
cp /var/jenkins_tmp/event-triggered-job-config.xml /var/jenkins_home/jobs/event-triggered-job/config.xml
mkdir -p /var/jenkins_home/jobs/send_eiffel_event
cp /var/jenkins_tmp/send_eiffel_event-config.xml /var/jenkins_home/jobs/send_eiffel_event/config.xml
mkdir -p /var/jenkins_home/jobs/upload_artifact_to_arm_curl
cp /var/jenkins_tmp/upload_artifact_to_arm_curl-config.xml /var/jenkins_home/jobs/upload_artifact_to_arm_curl/config.xml
/eiffel/start-service.sh
"


##### Generating Eiffel Jenkins configurations files that will be inject to Eiffel-Jenkins container in both Docker and Kubernetes. 

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

mkdir -p $CURRENT_DIR/jenkins-config-files

echo -e "$JENKINS_EIFFEL_CONFIG" > $CURRENT_DIR/jenkins-config-files/com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration.xml
echo -e "$JENKINS_SECURITY_CONFIG" > $CURRENT_DIR/jenkins-config-files/security.groovy
echo -e "$EI_ARTIFACT_TRIG_JOB" > $CURRENT_DIR/jenkins-config-files/ei-artifact-triggered-job.xml
echo -e "$EI_ARTIFACT_PARAMETER_TRIG_JOB" > $CURRENT_DIR/jenkins-config-files/ei-artifact-triggered-parameterized-job.xml
echo -e "$EI_SOURCECHANGE_TRIG_JOB" > $CURRENT_DIR/jenkins-config-files/ei-sourcechange-triggered-job.xml
echo -e "$EI_TESTEXECUTION_TRIG_JOB" > $CURRENT_DIR/jenkins-config-files/ei-testexecution-triggered-job.xml
echo -e "$EVENT_TRIGGRED_JOB" > $CURRENT_DIR/jenkins-config-files/event-triggered-job.xml
echo -e "$SEND_EIFFEL_EVENT_JOB" > $CURRENT_DIR/jenkins-config-files/send_eiffel_event.xml
echo -e "$UPLOAD_ARTIFACT_TO_ARM_CURL_JOB" > $CURRENT_DIR/jenkins-config-files/upload_artifact_to_arm_curl.xml
echo -e "$PREPARE_CONFIG_FILES_SCRIPT" > $CURRENT_DIR/jenkins-config-files/prepare-config-files.bash

# Chmod read permission for all users
chmod go+w -R $CURRENT_DIR/jenkins-config-files
chmod ugo+x $CURRENT_DIR/jenkins-config-files/prepare-config-files.bash
