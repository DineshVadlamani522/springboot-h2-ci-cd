# Use OpenJDK 17 as the base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the application JAR file into the container
COPY target/springboot-h2-ci-cd-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]