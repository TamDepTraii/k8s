# Multi-stage build for Spring Boot application
# Stage 1: Build
FROM maven:3.8.6-openjdk-11 AS builder
WORKDIR /build

# Copy pom.xml
COPY pom.xml .

# Download dependencies
RUN mvn dependency:resolve dependency:resolve-plugins

# Copy source code
COPY src ./src

# Build application
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:11-jre-slim
WORKDIR /app

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy JAR from builder stage
COPY --from=builder /build/target/k8s-*.jar app.jar

# Set ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD java -cp app.jar org.springframework.boot.loader.JarLauncher \
    && curl -f http://localhost:8080/actuator/health || exit 1

# Expose port
EXPOSE 8080

# Set environment
ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=25.0 -XX:MinRAMPercentage=12.5"

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]

