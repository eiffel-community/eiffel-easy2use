#!/bin/bash

echo Preparing Jenkins job directories
mkdir -p /var/jenkins_home/jobs/upload_artifact_to_arm_curl
mkdir -p /var/jenkins_home/jobs/send_eiffel2_event

echo Copy setting template files to correct path and with correct file names.
cp /var/jenkins_home/jobs/send_eiffel2_event/config.xml.template /var/jenkins_home/jobs/send_eiffel2_event/config.xml
cp /var/jenkins_home/jobs/upload_artifact_to_arm_curl/config.xml.template /var/jenkins_home/jobs/upload_artifact_to_arm_curl/config.xml



echo Generating xml config file based on provided Jenkins job cofigurations.

SEND_EIFFEL2_EVENT_FILE=/var/jenkins_home/jobs/send_eiffel2_event/config.xml
sed -i -e "s%REMREM_PUBLISH_URL%${REMREM_PUBLISH_URL}%g" $SEND_EIFFEL2_EVENT_FILE

UPLOAD_ARTIFACT_TO_ARM_CURL_FILE=/var/jenkins_home/jobs/upload_artifact_to_arm_curl/config.xml
sed -i -e "s%NEXUS_URL%${NEXUS_URL}%g" $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE
sed -i -e "s%NEXUS_USER%${NEXUS_USER}%g" $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE
sed -i -e "s%NEXUS_PASSWORD%${NEXUS_PASSWORD}%g" $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE
sed -i -e "s%REMREM_PUBLISH_URL%${REMREM_PUBLISH_URL}%g" $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE

echo Generated Jenkins settings files successfully.

echo Settings that has been generated:

cat $SEND_EIFFEL2_EVENT_FILE
cat $UPLOAD_ARTIFACT_TO_ARM_CURL_FILE
