#/usr/bin

usage() {
  echo "Usage: "
  echo "  $0 show " 
  echo "  $0 start   <instance>"
  echo "  $0 stop    <instance>"
  echo "  $0 setvars <instance>" 
  echo "  show             : Show running Vault servers and environment variables"
  echo "  start <instance> : Start vault instance* if not already started; set env vars to this instance."
  echo "  stop  <instance> : Stop vault instance* if it is running."
  echo '*Note: Instance name "dev" is special, causing vault tp start in dev mode.'
  echo "       Other instance names have a corresponding directory containing configuration, etc."
}

show() {
  echo " "
  echo " "
  
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

####### Script entry 

# DATE=$(date "+%Y-%m-%d_%H:%M:%S")
# START_INFO_FILE="/tmp/vault-$DATE"

PID=""
INSTANCE_ARG="unset"

if [ $# -eq 0 ]; then
  usage
elif [ $# -eq 1 ]; then
  if [[ "$1" == "show" ]]; then 
  
  usage
elif [[ "start" == "$1" ]]; then 
  start
elif [[ "stop" == "$1" ]]; then 
  stop
else 
  usage
fi

