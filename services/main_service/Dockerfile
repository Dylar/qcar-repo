FROM openjdk:11-jre-slim-buster
ARG JAR_FILE
ARG CREDENTIALS_FILE
COPY ${JAR_FILE} /app.jar
COPY ${CREDENTIALS_FILE} /credentials.json
ENTRYPOINT ["java", "-jar", "/app.jar"]