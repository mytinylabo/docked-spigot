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

    spigot_cmd="java -jar -Xms${SPIGOT_MEM} -Xmx${SPIGOT_MEM} /minecraft/spigot-${SPIGOT_VER}.jar nogui"
    # FIXME: Piping seems to clog logs probably because of buffering
    screen -AmdS $SPIGOT_SCNAME sh -c "$spigot_cmd | tee `tty`"

    while check_spigot_screen;
    do
        sleep 5
    done
    exit 0
fi

if [ " $@" = " sh" ]; then
    exec /bin/sh
fi

echo 'Nothing to do for "'"$@"'"'
