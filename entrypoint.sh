#!/bin/sh

boot_spigot() {
    java -jar -Xms${SPIGOT_MEM} -Xmx${SPIGOT_MEM} /minecraft/spigot-${SPIGOT_VER}.jar nogui
}

until mysqladmin ping -h ${MYSQL_HOST} -P ${MYSQL_PORT} --silent;
do
    echo "Waiting for database connection..."
    sleep 5
done

$@
