#/usr/bin

usage() {
  echo "Usage: "
  echo "  $0 <command> [instance]" 
  echo "Commands"
  echo "  show             : Show running Vault servers and environment variables"
  echo "  start <instance> : Start vault instance* if not already started; set env vars to this instance."
  echo "  stop  <instance> : Stop vault instance* if it is running."
  echo "  set   <instance> : Set variables to the instance."
  echo '*Note: Instance name "dev" is special, causing vault to start in dev mode.'
  echo '       Other instance names have corresponding directory with name = "instance_<instance-name>, '
  echo "       containing configuration, etc."
}

show() {
  echo " "
  echo "Environment Variables:"
  echo "  VAULT_ADDRESS: $VAULT_ADDRESS"
  echo "  VAULT_TOKEN:   $VAULT_TOKEN   (Probably best if this is not set)"

  local_servers
}

local_servers() {
  echo " "
  echo "Running Vault servers:"

  # Get all vault process pids
  VAULT_PS_PIDS=$(ps | grep 'vault' | grep 'server' | grep -v $0 | awk '{print $1}' )
  
  # Loop over each process, pull out instance name 
  for pid in $VAULT_PS_PIDS; do
    echo $pid
    executable=$(ps -p $pid | awk 'NR>1 {print $4}')  
    first_arg=$(ps -p  $pid | awk 'NR>1 {print $5}')
    second_arg=$(ps -p $pid | awk 'NR>1 {print $6}')
    third_arg=$(ps -p $pid | awk 'NR>1 {print $7}')
    if [[ "$executable" == "vault" && "$first_arg" == "server" ]]; then 
      echo "  $second_arg $third_arg (PID $pid)"
    fi
  done 
}

start() {
  
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
    show
  else
    usage
  fi
elif [ $# -eq 2 ]; then
  INSTANCE_ARG=$2
  if [[ "$1" == "start" ]]; then
    start
  elif [[ "stop" == "$1" ]]; then 
    stop
  elif [[ "setvars" == "$1" ]]; then 
    setvars
  else 
    usage
  fi
else
  usage
fi

