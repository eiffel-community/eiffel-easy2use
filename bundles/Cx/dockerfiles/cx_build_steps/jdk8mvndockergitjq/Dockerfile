FROM alpine:3.9
LABEL maintainer michael.frick@ericsson.com

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

ENV JAVA_VERSION 8u212
ENV JAVA_ALPINE_VERSION 8.212.04-r0
ENV DOCKER_COMPOSE_VERSION 1.11.1


# Install openjdk8, jq, git, Docker etc
RUN apk --update --no-cache \
    add curl device-mapper py-pip iptables openjdk8="$JAVA_ALPINE_VERSION" jq git docker && \
    rm -rf /var/cache/apk/* && \    
    pip install docker-compose==${DOCKER_COMPOSE_VERSION}

# Install kubectl (kubernetes)
ENV runDependencies curl jq bash
ENV kubectlURL https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl

# install Maven
ENV MAVEN_VERSION 3.3.9
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $PATH:$MAVEN_HOME/bin

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:$JAVA_HOME/bin:/usr/lib/jvm/java-1.8-openjdk/bin
RUN export JAVA_HOME

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn 


RUN apk --no-cache add ${runDependencies}; \
    curl -L -o /usr/local/bin/kubectl \
        ${kubectlURL}; \
    chmod +x /usr/local/bin/kubectl

ENTRYPOINT [ \
	"switch", \
		"shell=/bin/sh", "--", \
	"codep", \
		"/bin/docker dockerd" \
]