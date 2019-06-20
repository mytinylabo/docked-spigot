FROM openjdk:8-jdk-alpine

ENV SPIGOT_VER 1.14.2

WORKDIR /minecraft
RUN apk --no-cache add git && \
  wget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastBuild/artifact/target/BuildTools.jar" -O BuildTools.jar && \
  java -jar BuildTools.jar --rev ${SPIGOT_VER}

WORKDIR /data
RUN echo "eula=true" > ./eula.txt

EXPOSE 25565
ENTRYPOINT java -jar /minecraft/spigot-${SPIGOT_VER}.jar nogui
