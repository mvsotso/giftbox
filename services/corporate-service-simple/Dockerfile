# Use Maven with OpenJDK 17 as base image
FROM maven:3.9.6-eclipse-temurin-17-alpine

# Set working directory
WORKDIR /app

# Copy pom.xml first for better caching
COPY pom.xml .

# Copy source code
COPY src src

# Build the application
RUN mvn clean package -DskipTests

# Use OpenJDK 17 runtime image
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=0 /app/target/corporate-service-simple-1.0.0.jar app.jar

# Expose port
EXPOSE 8086

# Run the application
CMD ["java", "-jar", "app.jar"]
