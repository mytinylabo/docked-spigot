FROM openjdk:8-jdk-alpine AS build-env
ARG spigot_ver=latest
ENV SPIGOT_VER ${spigot_ver}

WORKDIR /build
RUN apk --no-cache add git
RUN wget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastBuild/artifact/target/BuildTools.jar" -O BuildTools.jar && \
    java -Xmx1024M -jar BuildTools.jar --rev ${SPIGOT_VER}
RUN mkdir minecraft && mv spigot-${SPIGOT_VER}.jar ./minecraft
RUN mkdir data && echo "eula=true" > ./data/eula.txt

FROM openjdk:8-jre-alpine
ARG spigot_ver=latest
ENV SPIGOT_VER ${spigot_ver}
ENV SPIGOT_SCNAME spigot

# NOTE: Need to sync mariadb-client's version with the server?
RUN apk --no-cache add mariadb-client screen

WORKDIR /data
COPY --from=build-env /build/minecraft /minecraft
COPY --from=build-env /build/data /data

# TODO: Pull plugins in Dockerfile
COPY ./plugin_jars/* /data/plugins/

# TODO: Make helper script to push config files to the container
COPY ./config/spigot/* /data/
COPY ./config/plugins/coreprotect.yml /data/plugins/CoreProtect/config.yml
COPY ./config/plugins/luckperms.yml /data/plugins/LuckPerms/config.yml

COPY ./scripts/* /scripts/
RUN chmod +x /scripts/*
ENV PATH ${PATH}:/scripts

VOLUME [ "/data" ]
EXPOSE 25565
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "spigot" ]
