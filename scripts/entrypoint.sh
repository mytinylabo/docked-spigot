#!/bin/sh

if [ " $@" = " spigot" ]; then
    until mysqladmin ping -h $MYSQL_HOST -P $MYSQL_PORT --silent;
    do
        echo "Waiting for database connection..."
        sleep 5
    done

    screen -AS $SPIGOT_SCNAME java -jar -Xms${SPIGOT_MEM} -Xmx${SPIGOT_MEM} /minecraft/spigot-${SPIGOT_VER}.jar nogui
    exit 0
fi

echo 'Nothing to do for "'"$@"'"'
