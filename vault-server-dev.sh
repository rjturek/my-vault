#/usr/bin

usage() {
    echo "Usage $0 [start|stop]"
    echo "  No args: show running dev server and env vars"
    echo "  start: Start vault in dev mode if not already started.  Set env vars"
    echo "  stop:  Stop vault server running in dev mode if it's running.  Clear env vars"
}

show_current() {
    PS_RESULT=$(ps -ef | grep 'vault' | grep 'server' | grep '\-dev' | grep -v $0)
    if [ $? -ne 0 ]; then
        echo "Server not running in dev mode."
    else
        export PID=$(echo $PS_RESULT | awk '{print $2}' )
        echo "Server is running in dev mode.  Process PID: $PID"
    fi
}

start() {
    show_current
    if [[ "$PID" != "" ]]; then
        echo "Skipping start."
    else 
        echo "Starting vault in dev mode ..."
        vault server -dev > $START_INFO_FILE
        sleep 3
        show_current
    fi
}

stop() {
    show_current
    if [[ "$PID" == "" ]]; then
        echo "Skipping stop."
    else 
        echo "Stopping vault running in dev mode ..."
        kill $PID
    fi
}

DATE=$(date "+%Y-%m-%d_%H:%M:%S")
START_INFO_FILE="/tmp/vault-$DATE"
PID=""

if [ $# -eq 0 ]; then
    show_current
elif [ $# -ne 1 ]; then
    usage
elif [[ "start" == "$1" ]]; then 
    start
elif [[ "stop" == "$1" ]]; then 
    stop
else 
    usage
fi


