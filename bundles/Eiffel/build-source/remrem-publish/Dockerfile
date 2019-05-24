FROM tomcat:8.0-jre8
LABEL maintainer michael.frick@ericsson.com
ARG REMREM_PUBLISH_VERSION
RUN echo ${REMREM_PUBLISH_VERSION}
RUN ["rm", "-fr", "/usr/local/tomcat/webapps/ROOT"]
ADD ./remrem-publish/start-service.sh /eiffel/start-service.sh
ADD https://jitpack.io/com/github/Ericsson/eiffel-remrem-publish/publish-service/${REMREM_PUBLISH_VERSION}/publish-service-${REMREM_PUBLISH_VERSION}.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["/eiffel/start-service.sh"]
