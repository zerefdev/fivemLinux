#!/bin/bash

# Colors functions
function Message() {
  echo -e "\\e[0m[FiveM] ${*}\\e[0m"
}
function Success() {
  echo -e "\\e[0;32m[FiveM] ${*}\\e[0m"
}
function Error() {
  echo -e "\\e[0;31m[FiveM] ${*}\\e[0m"
}
function Warning() {
  echo -e "\\e[0;33m[FiveM] ${*}\\e[0m"
}

# Restart message
restartMsg="Server Restart in $2 seconds!"

# Countdown function
function countdown() {
	cd=$1 # seconds
	until [ $cd -lt 1 ]; do
		printf "$cd "
		sleep 1
		((cd--))
	done
	echo -e "\r"
}	

# Paths
file=$(readlink -f "$0")
filePath=$(dirname $(readlink -f "$0"))
fivemPath="none"
dataPath="none"

# Screen name
screen="none"

# Screen
if [ "$screen" = "none" ]; then
	Message "What's the name of the server? [PRESS ENTER]"
	Message "Example: fivem-server"
	read input1
	screenName=$input1
	sed -i "34s@none@$screenName@" $0
fi 

# Screen
if [ "$fivemPath" = "none" ]; then
	Message "What's the name of the server? [PRESS ENTER]"
	Message "Example: fivem-server"
	read input2
	fmp=$input2
	sed -i "35s@none@$fmp@" $0
fi 

# Data Path 
if [ "$dataPath" = "none" ]; then
	Message "What's the path of server-data? [PRESS ENTER]"
	Message "Example: /home/username/server-data"
	read input3
	dap=$input3
	sed -i "38s@none@$dap@" $0
	Success "Done."
	echo   '#################################################################
			# Usage: 														#
			# - fivem start 	( Starts the server in silent mode.		)	#
			# - fivem stop  	( Stops the server.						)	#
			# - fivem restart	( Restarts the server.					)	#
			# - fivem console 	( Sends you to console.					)	#
			# - fivem debug 	( Starts the server in debug mode.		)	#
			#################################################################'
	exit 0
fi

# Check if a server with same screen name is already running
cd $dataPath
isOn() {
	screen -S "$screen" -X select ; return $?
}
### End variables

### Start main script

case "$1" in
# Start  
start)
	if isOn; then
		Error "Server already started"
	else
		Message "Server is starting..."
		screen -dmS $screen $fivemPath/run.sh +exec server.cfg
		sleep 1
		Success "Server started."
	fi
;;
# Stop
stop)
	if isOn; then
		screen -S $screen -X quit
		sleep 1
		Success "Server stopped."
		sleep 1
		Message "Deleting the cache..."
		
		if [ -d "$dataPath/cache" ]; then
			rm -Rf $dataPath/cache/
			sleep 2
			Success "Cache deleted."
		else 
			Warning "Cache directory not found."
		fi
	else
		Error "Server not started."
		Warning "Use : $0 start/debug (to start the server)"
	fi
;;

# Restart
restart)
	if isOn; then
		if [ -z "$2" ]; then
			screen -S $screen -X quit
			sleep 1
			Success "Server stopped."
			sleep 1
			Message "Server is starting..."
			screen -dmS $screen $fivemPath/run.sh +exec server.cfg
			sleep 2
			Success "Server started."
		else
			screen -S $screen -X stuff "\r\rsay $restartMsg\rsay $restartMsg\rsay $restartMsg\r";
			Warning "[CTRL+C] to cancel"
			countdown $2
			screen -S $screen -X quit
			sleep 1
			Success "Server stopped."
			sleep 1
			Message "Server is starting..."
			screen -dmS $screen $fivemPath/run.sh +exec server.cfg
			sleep 2
			Success "Server started"
		fi
	else
		Error "Server not started"
		Warning "Use : $0 start/debug (to start the server)"
	fi
;;

# Status
status)
	if isOn; then
		Message "Server is running."
	else
		Message "Server is not running."
	fi
;;

# Console
console)
	if isOn; then
		if [ -z "$2" ]; then
			read -r -p "Do you want to reattach to the screen instead? [y/n]" useScreen
			case $useScreen in
				[yY])
				screen -dr $screen
				echo -e "\r\r"
				;;
				*)
				echo "Abort"
				exit 1
				;;
			esac
		else
			screen -S $screen -X stuff "\r\r$2\r";
		fi
	else
	 	sleep 1
		Error "Server is not running."
	fi
;;
	
# Start in debug mode
debug)
	if isOn; then
		Error "Server is already started."
	else
		Warning "Server is starting in debug mode..."
		screen -S $screen $fivemPath/run.sh +exec server.cfg
	fi
  ;;
	*)
	Warning "Usage: fivem {update|start|stop|restart|status|console|debug}"
  exit 1
  ;;
esac
exit 0
