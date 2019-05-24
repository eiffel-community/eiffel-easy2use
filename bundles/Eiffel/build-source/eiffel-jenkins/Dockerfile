ARG JENKINS_VERSION
FROM jenkins/jenkins:${JENKINS_VERSION}
LABEL maintainer Michael Frick <michael.frick@ericsson.com>
ARG FEM_PLUGIN_VERSION
RUN echo "Building image based on Jenkins Version: ${JENKINS_VERSION}\nand FEM Plugin version: ${FEM_PLUGIN_VERSION}"
#get rid of admin password setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
COPY ./eiffel-jenkins/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
EXPOSE 8080 50000
USER root

# ADD config template files
ADD ./eiffel-jenkins/log.properties /var/jenkins_home/log.properties
ADD ./eiffel-jenkins/generate-fem-settings.sh /tmp/generate-fem-settings.sh
ADD ./eiffel-jenkins/com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration.xml.template /var/jenkins_home/com.ericsson.eiffel.fem.config.EiffelJenkinsGlobalConfiguration.xml.template
ADD ./eiffel-jenkins/ei-artifact-triggered-job.xml.template /var/jenkins_home/jobs/ei-artifact-triggered-job/config.xml.template
ADD ./eiffel-jenkins/ei-artifact-triggered-parameterized-job.xml.template /var/jenkins_home/jobs/ei-artifact-triggered-parameterized-job/config.xml.template
ADD ./eiffel-jenkins/ei-sourcechange-triggered-job.xml.template /var/jenkins_home/jobs/ei-sourcechange-triggered-job/config.xml.template
ADD ./eiffel-jenkins/ei-testexecution-triggered-job.xml.template /var/jenkins_home/jobs/ei-testexecution-triggered-job/config.xml.template
ADD ./eiffel-jenkins/event-triggered-job.xml.template /var/jenkins_home/jobs/event-triggered-job/config.xml.template
ADD ./eiffel-jenkins/send_eiffel2_event.xml.template /var/jenkins_home/jobs/send_eiffel2_event/config.xml.template
ADD ./eiffel-jenkins/upload_artifact_to_arm_curl.xml.template /var/jenkins_home/jobs/upload_artifact_to_arm_curl/config.xml.template

ADD ./eiffel-jenkins/start-service.sh /eiffel/start-service.sh
ADD ./scripts/health-check.sh /eiffel/health-check.sh

# Install FEM plugin
# Download Fem plugin
ADD https://eiffel.lmera.ericsson.se/nexus/content/repositories/releases/com/ericsson/eiffel/eiffel-fem/${FEM_PLUGIN_VERSION}/eiffel-fem-${FEM_PLUGIN_VERSION}.hpi /usr/share/jenkins/ref/plugins/eiffel-fem-${FEM_PLUGIN_VERSION}.hpi
RUN chmod 777 /usr/share/jenkins/ref/plugins/eiffel-fem-${FEM_PLUGIN_VERSION}.hpi
# Installing specified plugins
COPY ./eiffel-jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

CMD /eiffel/start-service.sh
