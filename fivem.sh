#!/bin/bash

### Start variables
# Colors
	default='\e[0m'
	red='\e[0;31m'
	green='\e[0;32m'
	yellow='\e[0;33m'
	cyan='\e[0;36m'


# Server Path
	fivemPath="none"
	if [ "$fivemPath" = "none" ]; then
    echo -e "Enter FiveM Server$cyan Files Path$default and press [ENTER]\nExample:$yellow /home/username/server$default"
    read input1
	  fmp=$input1
    sed -i "13s@none@$fmp@" $0
	fi 
# Data Path
	dataPath="none"
	if [ "$dataPath" = "none" ]; then
    echo -e "Enter FiveM Server$cyan Data Path$default and press [ENTER]\nExample:$yellow /home/username/server-data$default"
    read input2
	  dap=$input2
    sed -i "21s@none@$dap@" $0
	  echo -e "$green\rDone.$default\nUsage: $yellow$0$default {start|stop|status|restart|cmd}"
	  exit 0
	fi 

# Text
  restartMsg="Server Restart in $2 seconds!"

# screen name
  screen="$USER"

### End variables

### Start countdown function
countdown () {
	cd=$1 # seconds
	until [ $cd -lt 1 ]; do
		printf "$cd "
		sleep 1
		((cd--))
	done
}
### End countdown function

### Start main script
# Check if a server with same screen name is already running
cd $dataPath
isOn(){
	screen -S "$screen" -X select ; return $?
}

# Start
case "$1" in
  start)
	if isOn; then
		echo -e "$red\rServer already started. $default"
	else
		echo -e "$yellow\rServer is starting... $default"
		screen -dmS $screen bash $fivemPath/run.sh +exec server.cfg
		sleep 2
		echo -e "$green\rServer started.$default"
	fi
  ;;

# Stop
  stop)
	if isOn; then
		screen -S $screen -X quit
		sleep 1
    	echo -e "$red\rServer stopped.$default"
		sleep 1
    	echo -e "$yellow\rDeleteing the cache...$default"
		if [ -d "$dataPath/cache" ]; then
			rm -Rf $dataPath/cache/
			sleep 2
			echo -e "$green\rCache deleted.$default"
		else 
			echo -e "$red\rCache directory not found.$default"
		fi
	else
	  echo -e "$red\rServer not started.$default"
	fi
  ;;

# Restart
  restart)
	if isOn; then
		if [ -z "$2" ]; then
			screen -S $screen -X quit
			sleep 1
			echo -e "$red\rServer stopped.$default"
			sleep 1
			echo -e "$yellow\rServer is starting... $default"
			screen -dmS $screen bash $fivemPath/run.sh +exec server.cfg
			sleep 2
			echo -e "$green\rServer started.$default"

		else
			screen -S $screen -X stuff "\r\rsay $restartMsg\r";
			echo -e "$yellow[CTRL+C]$default to cancel"
			countdown $2
			screen -S $screen -X quit
			sleep 1
			echo -e "$red\rServer stopped.$default"
			sleep 1
			echo -e "$yellow\rServer is starting... $default"
			screen -dmS $screen bash $fivemPath/run.sh +exec server.cfg
			sleep 2
			echo -e "$green\rServer started.$default"
		fi
	else
    	echo -e "$red\rServer not started.$default use: $yellow$0 start$default"
	fi
	;;

# Status
	status)
	if isOn; then
    echo -e "$green\rServer is running.$default"
	else
    echo -e "$red\rServer is not running.$default"
	fi
	;;

# Command
	cmd)
	if isOn; then
		if [ -z "$2" ]; then
			echo -e "Usage: $yellow$0 cmd \"command to run\".$default"
		else
			screen -S $screen -X stuff "\r\r$2\r";
		fi
	else
	 	sleep 1
		echo -e "$red\rServer is not running.$default"
	fi
  ;;
	*)
    echo -e "Usage: $yellow$0$default {start|stop|status|restart|cmd}"
    exit 1
  ;;
esac
exit 0