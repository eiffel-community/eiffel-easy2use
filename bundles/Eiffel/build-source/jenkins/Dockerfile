ARG JENKINS_VERSION
FROM jenkins/jenkins:${JENKINS_VERSION}
LABEL maintainer Michael Frick <michael.frick@ericsson.com>
RUN echo "Building image based on Jenkins Version: ${JENKINS_VERSION}\n"
#get rid of admin password setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
COPY ./jenkins/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
EXPOSE 8080 50000
USER root

# ADD config template files
ADD ./jenkins/log.properties /var/jenkins_home/log.properties
ADD ./jenkins/ei-artifact-triggered-job.xml.template /var/jenkins_home/jobs/ei-artifact-triggered-job/config.xml
ADD ./jenkins/ei-artifact-triggered-parameterized-job.xml.template /var/jenkins_home/jobs/ei-artifact-triggered-parameterized-job/config.xml
ADD ./jenkins/ei-sourcechange-triggered-job.xml.template /var/jenkins_home/jobs/ei-sourcechange-triggered-job/config.xml
ADD ./jenkins/ei-testexecution-triggered-job.xml.template /var/jenkins_home/jobs/ei-testexecution-triggered-job/config.xml
ADD ./jenkins/send_eiffel2_event.xml.template /var/jenkins_home/jobs/send_eiffel2_event/config.xml.template
ADD ./jenkins/upload_artifact_to_arm_curl.xml.template /var/jenkins_home/jobs/upload_artifact_to_arm_curl/config.xml.template
ADD ./jenkins/generate-settings.sh /tmp/generate-settings.sh

# Installing specified plugins
COPY ./jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

CMD /bin/bash -c "/tmp/generate-settings.sh && /usr/local/bin/jenkins.sh"
