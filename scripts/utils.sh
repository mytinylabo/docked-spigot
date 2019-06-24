
# TODO: Just return a value, assert function takes charge of printing error messages
check_spigot_screen() {
    if [ -z "$SPIGOT_SCNAME" ]; then
        echo '$SPIGOT_SCNAME must be set to specify the session.'
        return 1
    fi

    if ! screen -S $SPIGOT_SCNAME -Q select .; then
        echo "Screen $SPIGOT_SCNAME doesn't exist."
        return 2
    fi

    return 0
}

assert_spigot_screen() {
    check_spigot_screen || exit 1
}
