FROM openjdk:11.0.7-jre-slim-buster

LABEL base-image="openjdk:11.0.7-jre-slim-buster" \
      java-version="11.0.7" \
      purpose="Hello World with SSL, Java and Dockerfile"

MAINTAINER Muhammad Edwin < edwin at redhat dot com >

# set working directory at /deployments
WORKDIR /deployments

# copy my jar file
COPY target/*.jar app.jar

# gives uid
USER 185

EXPOSE 8443

# run it
CMD ["java", "-jar","app.jar"]