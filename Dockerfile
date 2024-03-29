FROM openjdk:8-jdk-alpine AS build-env
ARG spigot_ver=latest
ENV SPIGOT_VER ${spigot_ver}

WORKDIR /build
RUN apk --update --no-cache add git
RUN wget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastBuild/artifact/target/BuildTools.jar" -O BuildTools.jar && \
    java -Xmx1024M -jar BuildTools.jar --rev ${SPIGOT_VER}
RUN mkdir minecraft && mv spigot-${SPIGOT_VER}.jar ./minecraft

FROM openjdk:8-jre-alpine
ARG spigot_ver=latest
ENV SPIGOT_VER ${spigot_ver}
ENV SPIGOT_SCNAME spigot

# NOTE: Need to sync mariadb-client's version with the server?
RUN apk --update --no-cache add mariadb-client screen file tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata

WORKDIR /data
COPY --from=build-env /build/minecraft /minecraft

COPY ./scripts/* /scripts/
RUN chmod +x /scripts/*
ENV PATH ${PATH}:/scripts

VOLUME [ "/data" ]
VOLUME [ "/push_src" ]
EXPOSE 25565
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "spigot" ]
