FROM eclipse-temurin:17-jre-alpine
RUN apk upgrade --no-cache
WORKDIR /app
COPY target/demo-workshop-2.1.2.jar /app/sample_app.jar
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "/app/sample_app.jar"]