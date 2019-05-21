FROM tomcat:8.0-jre8
LABEL maintainer michael.frick@ericsson.com
USER root
ARG EIFFEL_INTELLIGENCE_FRONTEND_VERSION

RUN echo ${EIFFEL_INTELLIGENCE_FRONTEND_VERSION}

RUN ["rm", "-fr", "/usr/local/tomcat/webapps/ROOT"]

ADD https://jitpack.io/com/github/eiffel-community/eiffel-intelligence-frontend/${EIFFEL_INTELLIGENCE_FRONTEND_VERSION}/eiffel-intelligence-frontend-${EIFFEL_INTELLIGENCE_FRONTEND_VERSION}.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
