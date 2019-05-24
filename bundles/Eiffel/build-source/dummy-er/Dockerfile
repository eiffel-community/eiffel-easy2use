FROM fabric8/java-jboss-openjdk8-jdk:1.2
LABEL maintainer michael.frick@ericsson.com
USER root
ARG DUMMY_ER_VERSION
RUN echo ${DUMMY_ER_VERSION}
ENV JAVA_APP_DIR=/deployments
ENV JAVA_APP_JAR=eiffel-event-repository-${DUMMY_ER_VERSION}.jar
EXPOSE 8081 8778 9779
ADD https://jitpack.io/com/github/ericsson/eiffel-event-repository/${DUMMY_ER_VERSION}/eiffel-event-repository-${DUMMY_ER_VERSION}.jar /deployments/eiffel-event-repository-${DUMMY_ER_VERSION}.jar


