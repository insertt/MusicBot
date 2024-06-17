FROM maven:3.9.3-eclipse-temurin-20 AS builder

ADD . /build

WORKDIR /build

RUN mvn clean
RUN mvn package -Daether.dependencyCollector.impl=bf

FROM ubuntu:22.04 as base

COPY --from=builder /build/target/JMusicBot-Snapshot-All.jar /app/JMusicBot.jar

RUN apt update && apt upgrade -y
RUN apt install -y apt-transport-https bash openjdk-17-jdk
WORKDIR /app

CMD ["/usr/bin/java", "-Dnogui=true", "-Dconfig.override_with_env_vars=true", "-Djmusicbot.persistent_config=false", "-jar", "/app/JMusicBot.jar"]