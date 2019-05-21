FROM fabric8/java-jboss-openjdk8-jdk:1.2
LABEL maintainer michael.frick@ericsson.com
USER root
ARG EIFFEL_VICI_VERSION
RUN echo ${EIFFEL_VICI_VERSION}
ENV JAVA_APP_DIR=/deployments
ENV JAVA_APP_JAR=eiffel-vici-${EIFFEL_VICI_VERSION}.jar
EXPOSE 8080 8778 9779
ADD https://jitpack.io/com/github/eiffel-community/eiffel-vici/${EIFFEL_VICI_VERSION}/eiffel-vici-${EIFFEL_VICI_VERSION}.jar /deployments/eiffel-vici-${EIFFEL_VICI_VERSION}.jar

COPY ./scripts/health-check.sh /eiffel/health-check.sh
COPY ./eiffel-vici/start-service.sh /eiffel/start-service.sh

CMD /eiffel/start-service.sh

