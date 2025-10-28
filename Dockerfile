# Multi-stage build for Spring Boot application
# Stage 1: Build
FROM maven:3.8.6-openjdk-11 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:resolve dependency:resolve-plugins
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:11-jre-slim
WORKDIR /app
RUN groupadd -r appuser && useradd -r -g appuser appuser
COPY --from=builder /build/target/k8s-*.jar app.jar
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8080
ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxRAMPercentage=75.0"

ENTRYPOINT ["java", "-jar", "app.jar"]

