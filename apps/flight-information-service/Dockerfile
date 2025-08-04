FROM openjdk:17-jdk-slim

WORKDIR /app

COPY gradle gradle
COPY gradlew build.gradle.kts ./
COPY src src

RUN chmod +x gradlew
RUN ./gradlew build -x test

# Verify the JAR file exists and list contents
RUN ls -la build/libs/

EXPOSE 9000

CMD ["java", "-jar", "build/libs/app-1.0.0.jar"]