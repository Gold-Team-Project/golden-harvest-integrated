# === 1단계: Build ===
FROM amazoncorretto:21-alpine AS builder
ARG SERVICE_NAME
WORKDIR /build

# 소스 전체 복사
COPY . .

# 서비스 디렉토리로 이동
WORKDIR /build/apps/${SERVICE_NAME}

# Gradle 빌드
RUN chmod +x ./gradlew
RUN ./gradlew bootJar -x test

# === 2단계: Run ===
FROM amazoncorretto:21-alpine
ARG SERVICE_NAME
WORKDIR /app

# 빌드된 JAR 복사
COPY --from=builder /build/apps/${SERVICE_NAME}/build/libs/*.jar app.jar

# 컨테이너 내부 포트
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
