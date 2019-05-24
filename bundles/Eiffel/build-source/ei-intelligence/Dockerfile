FROM tomcat:8.0-jre8
LABEL maintainer michael.frick@ericsson.com

ARG EIFFEL_INTELLIGENCE_VERSION
RUN echo ${EIFFEL_INTELLIGENCE_VERSION}


RUN ["rm", "-fr", "/usr/local/tomcat/webapps/ROOT"]

COPY ./scripts/health-check.sh /eiffel/health-check.sh
COPY ./ei-intelligence/start-service.sh /eiffel/start-service.sh
ADD https://jitpack.io/com/github/eiffel-community/eiffel-intelligence/${EIFFEL_INTELLIGENCE_VERSION}/eiffel-intelligence-${EIFFEL_INTELLIGENCE_VERSION}.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["/eiffel/start-service.sh"]
