
check_spigot_screen() {
    test -n "$SPIGOT_SCNAME" || return 11
    screen -S $SPIGOT_SCNAME -Q select . || return 12
    return 0
}

assert_spigot_screen() {
    check_spigot_screen
    ret=$?
    case $ret in
        11) echo '$SPIGOT_SCNAME must be set to specify the session.'
            exit $ret ;;
        12) echo "Screen $SPIGOT_SCNAME doesn't exist."
            exit $ret ;;
    esac
}
