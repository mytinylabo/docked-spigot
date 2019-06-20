ARG spigot_ver=1.14.2
ARG spigot_mem=4G

FROM openjdk:8-jdk-alpine AS build-env
ARG spigot_ver
ENV SPIGOT_VER ${spigot_ver}

WORKDIR /build
RUN apk --no-cache add git && \
  wget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastBuild/artifact/target/BuildTools.jar" -O BuildTools.jar && \
  java -jar BuildTools.jar --rev ${SPIGOT_VER} && \
  mkdir minecraft && \
  mv spigot-${SPIGOT_VER}.jar ./minecraft && \
  mkdir data && \
  echo "eula=true" > ./data/eula.txt

FROM openjdk:8-jre-alpine
ARG spigot_ver
ARG spigot_mem
ENV SPIGOT_VER ${spigot_ver}
ENV SPIGOT_MEM ${spigot_mem}

WORKDIR /data
COPY --from=build-env /build/minecraft /minecraft
COPY --from=build-env /build/data /data

VOLUME [ "/data" ]
EXPOSE 25565
ENTRYPOINT java -jar -Xms${SPIGOT_MEM} -Xmx${SPIGOT_MEM} /minecraft/spigot-${SPIGOT_VER}.jar nogui
