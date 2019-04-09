#/usr/bin

usage() {
    echo "Usage $0 [start|stop]"
    echo "  No args: show running dev server and env vars"
    echo "  start: Start vault in dev mode if not already started.  Set env vars"
    echo "  stop:  Stop vault server running in dev mode if it's running.  Clear env vars"
}

ps -ef | grep 'vault' | grep 'server' | grep '\-dev' | grep -v $0

echo $?

