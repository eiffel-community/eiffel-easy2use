#!/bin/bash

echo Preparing Fem and Jenkins job directories
mkdir -p /var/jenkins_home/jobs/event-triggered-job
mkdir -p /var/jenkins_home/jobs/ei-artifact-triggered-job
mkdir -p /var/jenkins_home/jobs/ei-sourcechange-triggered-job
mkdir -p /var/jenkins_home/jobs/ei-testexecution-triggered-job
mkdir -p /var/jenkins_home/jobs/upload_artifact_to_arm_curl
mkdir -p /var/jenkins_home/jobs/send_eiffel2_event
mkdir -p /var/jenkins_home/jobs/ei-artifact-triggered-parameterized-job


echo Copy setting template files to correct path and with correct file names.
cp /var/jenkins_home/com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration.xml.template /var/jenkins_home/com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration.xml
cp /var/jenkins_home/jobs/ei-artifact-triggered-job/config.xml.template /var/jenkins_home/jobs/ei-artifact-triggered-job/config.xml
cp /var/jenkins_home/jobs/ei-artifact-triggered-parameterized-job/config.xml.template /var/jenkins_home/jobs/ei-artifact-triggered-parameterized-job/config.xml
cp /var/jenkins_home/jobs/ei-sourcechange-triggered-job/config.xml.template /var/jenkins_home/jobs/ei-sourcechange-triggered-job/config.xml
cp /var/jenkins_home/jobs/ei-testexecution-triggered-job/config.xml.template /var/jenkins_home/jobs/ei-testexecution-triggered-job/config.xml
cp /var/jenkins_home/jobs/event-triggered-job/config.xml.template /var/jenkins_home/jobs/event-triggered-job/config.xml
cp /var/jenkins_home/jobs/send_eiffel2_event/config.xml.template /var/jenkins_home/jobs/send_eiffel2_event/config.xml
cp /var/jenkins_home/jobs/upload_artifact_to_arm_curl/config.xml.template /var/jenkins_home/jobs/upload_artifact_to_arm_curl/config.xml

echo Generating FEM Setting file based on Eiffel Environment variables.

FEM_SETTING_FILE=/var/jenkins_home/com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration.xml

sed -i -e "s%FEM_VERSION%${FEM_VERSION}%g" $FEM_SETTING_FILE
sed -i -e "s%NEXUS_DESCRIPTION%${NEXUS_DESCRIPTION}%g" $FEM_SETTING_FILE
sed -i -e "s%NEXUS_URL%${NEXUS_URL}%g" $FEM_SETTING_FILE
sed -i -e "s%NEXUS_DOWNLOAD_REPO_NAME%${NEXUS_DOWNLOAD_REPO_NAME}%g" $FEM_SETTING_FILE
sed -i -e "s%NEXUS_UPLOAD_REPO_NAME%${NEXUS_UPLOAD_REPO_NAME}%g" $FEM_SETTING_FILE
sed -i -e "s%NEXUS_USER%${NEXUS_USER}%g" $FEM_SETTING_FILE
sed -i -e "s%NEXUS_PASSWORD%${NEXUS_PASSWORD}%g" $FEM_SETTING_FILE
sed -i -e "s%RABBITMQ_HOST%${RABBITMQ_HOST}%g" $FEM_SETTING_FILE
sed -i -e "s%RABBITMQ_PORT%${RABBITMQ_PORT}%g" $FEM_SETTING_FILE
sed -i -e "s%RABBITMQ_EXCHANGE_NAME%${RABBITMQ_EXCHANGE_NAME}%g" $FEM_SETTING_FILE
sed -i -e "s%RABBITMQ_COMPONENT_NAME%${RABBITMQ_COMPONENT_NAME}%g" $FEM_SETTING_FILE
sed -i -e "s%RABBITMQ_PROTOCOL%${RABBITMQ_PROTOCOL}%g" $FEM_SETTING_FILE
sed -i -e "s%RABBITMQ_CREATE_EXCHANGE%${RABBITMQ_CREATE_EXCHANGE}%g" $FEM_SETTING_FILE
sed -i -e "s%RABBITMQ_USER%${RABBITMQ_USER}%g" $FEM_SETTING_FILE
sed -i -e "s%RABBITMQ_PASSWORD%${RABBITMQ_PASSWORD}%g" $FEM_SETTING_FILE
sed -i -e "s%RABBITMQ_DOMAIN_ID%${RABBITMQ_DOMAIN_ID}%g" $FEM_SETTING_FILE
sed -i -e "s%REMREM_GENERATE_URL%${REMREM_GENERATE_URL}%g" $FEM_SETTING_FILE
sed -i -e "s%REMREM_PUBLISH_URL%${REMREM_PUBLISH_URL}%g" $FEM_SETTING_FILE
sed -i -e "s%REMREM_USER%${REMREM_USER}%g" $FEM_SETTING_FILE
sed -i -e "s%REMREM_PASSWORD%${REMREM_PASSWORD}%g" $FEM_SETTING_FILE
sed -i -e "s%ER_REST_URL%${ER_REST_URL}%g" $FEM_SETTING_FILE
sed -i -e "s%BYPASS_IO%${BYPASS_IO}%g" $FEM_SETTING_FILE

echo Generating xml config file based on provided Jenkins job cofigurations.

EI_ARTIFACT_TRIGGERED_JOB_FILE=/var/jenkins_home/jobs/ei-artifact-triggered-job/config.xml
sed -i -e "s%FEM_VERSION%${FEM_VERSION}%g" $EI_ARTIFACT_TRIGGERED_JOB_FILE

EI_ARTIFACT_TRIGGERED_PARAMETERIZED_JOB_FILE=/var/jenkins_home/jobs/ei-artifact-triggered-parameterized-job/config.xml
sed -i -e "s%FEM_VERSION%${FEM_VERSION}%g" $EI_ARTIFACT_TRIGGERED_PARAMETERIZED_JOB_FILE

EI_SOURCECHANGE_TRIGGERED_JOB_FILE=/var/jenkins_home/jobs/ei-sourcechange-triggered-job/config.xml
sed -i -e "s%FEM_VERSION%${FEM_VERSION}%g" $EI_SOURCECHANGE_TRIGGERED_JOB_FILE

EI_TESTEXECUTION_TRIGGERED_JOB_FILE=/var/jenkins_home/jobs/ei-testexecution-triggered-job/config.xml
sed -i -e "s%FEM_VERSION%${FEM_VERSION}%g" $EI_TESTEXECUTION_TRIGGERED_JOB_FILE

EVENT_TRIGGERED_JOB_FILE=/var/jenkins_home/jobs/event-triggered-job/config.xml
sed -i -e "s%FEM_VERSION%${FEM_VERSION}%g" $EVENT_TRIGGERED_JOB_FILE

SEND_EIFFEL2_EVENT_FILE=/var/jenkins_home/jobs/send_eiffel2_event/config.xml
sed -i -e "s%FEM_VERSION%${FEM_VERSION}%g" $SEND_EIFFEL2_EVENT_FILE

UPLOAD_ARTIFACT_TO_ARM_CURL_FILE=/var/jenkins_home/jobs/upload_artifact_to_arm_curl/config.xml
sed -i -e "s%FEM_VERSION%${FEM_VERSION}%g" $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE
sed -i -e "s%NEXUS_URL%${NEXUS_URL}%g" $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE
sed -i -e "s%NEXUS_USER%${NEXUS_USER}%g" $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE
sed -i -e "s%NEXUS_PASSWORD%${NEXUS_PASSWORD}%g" $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE


echo Generated FEM and Jenkins job setting files successfully.

cat $FEM_SETTING_FILE
cat $EI_ARTIFACT_TRIGGERED_JOB_FILE
cat $EI_ARTIFACT_TRIGGERED_PARAMETERIZED_JOB_FILE
cat $EI_SOURCECHANGE_TRIGGERED_JOB_FILE
cat $EI_TESTEXECUTION_TRIGGERED_JOB_FILE
cat $EVENT_TRIGGERED_JOB_FILE
cat $SEND_EIFFEL2_EVENT_FILE
cat $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE
