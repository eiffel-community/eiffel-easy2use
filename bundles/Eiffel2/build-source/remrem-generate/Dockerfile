FROM tomcat:8.0-jre8
LABEL maintainer michael.frick@ericsson.com
ARG REMREM_GENERATE_VERSION
RUN echo ${REMREM_GENERATE_VERSION}
RUN ["rm", "-fr", "/usr/local/tomcat/webapps/ROOT"]
ADD https://jitpack.io/com/github/Ericsson/eiffel-remrem-generate/generate-service/${REMREM_GENERATE_VERSION}/generate-service-${REMREM_GENERATE_VERSION}.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
