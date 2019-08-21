FROM openjdk:11-jre-slim
ENV PORT 9000
EXPOSE 9000
COPY app.jar /opt/target
WORKDIR /opt/target
CMD ["/bin/bash", "-c", "find -type f -name '*.jar' | xargs java -jar"]