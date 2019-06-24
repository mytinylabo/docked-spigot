#!/bin/sh
source utils.sh

trap_TERM() {
    echo "SIGTERM accepted. Shutdown Spigot server gracefully..."
    spigot-cmd stop

    while check_spigot_screen;
    do
        sleep 1
    done
    exit 0
}

if [ " $@" = " spigot" ]; then
    if [ $$ != 1 ]; then
        echo "You can start Spigot server only via ENTRYPOINT."
        exit 1
    fi

    until mysqladmin ping -h $MYSQL_HOST -P $MYSQL_PORT --silent;
    do
        echo "Waiting for database connection..."
        sleep 5
    done

    trap "trap_TERM" TERM

    # TODO: Pull out spigot's logs to my STDOUT so as to be read via "docker logs"
    screen -AmdS $SPIGOT_SCNAME java -jar -Xms${SPIGOT_MEM} -Xmx${SPIGOT_MEM} /minecraft/spigot-${SPIGOT_VER}.jar nogui

    while check_spigot_screen;
    do
        sleep 5
    done
    exit 0
fi

echo 'Nothing to do for "'"$@"'"'
