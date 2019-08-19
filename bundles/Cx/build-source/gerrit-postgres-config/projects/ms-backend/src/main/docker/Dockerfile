
### Arguments with default values
ARG POM_PATH=pom.xml

### Build - Used from skaffold and pipeline if no ARM binary used
FROM maven:3-jdk-11 as build

WORKDIR /build
COPY ${POM_PATH} .
RUN mvn dependency:go-offline

COPY src/ /build/src/
RUN mvn --batch-mode -f pom.xml install -DskipTests=true -Dmaven.javadoc.skip=true -B -V


### Deployment
FROM openjdk:11-jre-slim
ENV PORT 9000
EXPOSE 9000
COPY --from=build /build/target /opt/target

WORKDIR /opt/target

CMD ["/bin/bash", "-c", "find -type f -name '*.jar' | xargs java -jar"]