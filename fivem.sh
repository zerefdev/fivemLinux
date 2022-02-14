#!/bin/bash
# if you have any suggestions or improvements, don't hesitate to send your pull requests
# https://github.com/zerefdev/fivemLinux

### Start variables
# Version
currentVersion="2.0"

# Colors functions
function defaultMsg() {
  echo -e "\\e[0m${*}\\e[0m"
}
function greenMsg() {
  echo -e "\\e[0;32m${*}\\e[0m"
}
function redMsg() {
  echo -e "\\e[0;31m${*}\\e[0m"
}
function yellowMsg() {
  echo -e "\\e[0;33m${*}\\e[0m"
}
function cyanMsg() {
  echo -e "\\e[0;36m${*}\\e[0m"
}

# Restart message
  restartMsg="Server Restart in $2 seconds!"

# Countdown function
function countdown () {
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
		yellowMsg "What do you want to name the screen session?"
		cyanMsg "Example: fivem"
    read input1
	  screenName=$input1
    sed -i "48s@none@$screenName@" $0
	fi

# Server Path
	if [ "$fivemPath" = "none" ]; then
		yellowMsg "Enter your FiveM Server Files Path and press [ENTER]"
		cyanMsg "Example: /home/username/server"
    read input2
	  fmp=$input2
    sed -i "44s@none@$fmp@" $0
	fi

# Data Path
	if [ "$dataPath" = "none" ]; then
		yellowMsg "Enter your FiveM Server Data Path and press [ENTER]"
		cyanMsg "Example: /home/username/server-data"
    read input3
	  dap=$input3
    sed -i "45s@none@$dap@" $0
		greenMsg "Done."
		echo '##############################
###
# Usage:
# - ./fivem.sh update (updates fivemLinux to latest version)
# - ./fivem.sh start (starts the server in silent mode)
# - ./fivem.sh stop (stops the server)
# - ./fivem.sh restart X (restarts the server after X seconds)
# - ./fivem.sh cmd (allows you to send commands via the console)
# - ./fivem.sh debug (starts the server in debug mode)
###
##############################'
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
# Update
update)
	latestVersion=$(wget --no-check-certificate --timeout=60 -qO - https://raw.githubusercontent.com/zerefdev/fivemLinux/master/fivem.sh | grep -Po '(?<=currentVersion=")([0-9]\.[0-9]+)')

	if [ "$(printf "${latestVersion}\\n${currentVersion}" | sort -V | tail -n 1)" != "$currentVersion" ]; then
		if isOn; then
			redMsg "You are using an outdated version ${currentVersion}"
			sleep 1
			yellowMsg "You need to stop the server before upgrading to fivemLinux ${latestVersion}"
		else
			redMsg "You are using an outdated version ${currentVersion}"
			sleep 1
			yellowMsg "Please wait! Currently upgrading fivemLinux..."
			sleep 1
			mv $file $file.save
			greenMsg "Backup saved (fivem.sh.save)"
			sleep 1
			wget https://raw.githubusercontent.com/zerefdev/fivemLinux/master/fivem.sh
			sleep 2
			if [ -f "fivem.sh" ]; then
				dos2unix fivem.sh
				sleep 1
				chmod +x fivem.sh
				mv fivem.sh $filePath
				greenMsg "Done."
				sleep 1
				bash $filePath/fivem.sh
			else
				redMsg "Something went wrong."
			fi
		fi
		else
			sleep 1
			greenMsg "You are using the latest fivemLinux version ${latestVersion}"
	fi
	;;

# Start
start)
	if isOn; then
	redMsg "Server already started"
	else
		yellowMsg "Server is starting..."
		screen -dmS $screen $fivemPath/run.sh +exec server.cfg
		sleep 1
		greenMsg "Server started."
	fi
  ;;
# Stop
  stop)
	if isOn; then
		screen -S $screen -X quit
		sleep 1
		redMsg "Server stopped."
		sleep 1
		yellowMsg "Deleting the cache..."
		if [ -d "$dataPath/cache" ]; then
			rm -Rf $dataPath/cache/
			sleep 2
			greenMsg "Cache deleted."
		else
		redMsg "Cache directory not found."
		fi
	else
		redMsg "Server not started."
		yellowMsg "Use : $0 start/debug (to start the server)"
	fi
  ;;

# Restart
  restart)
	if isOn; then
		if [ -z "$2" ]; then
			screen -S $screen -X quit
			sleep 1
			cyanMsg "Server stopped."
			sleep 1
			yellowMsg "Server is starting..."
			screen -dmS $screen $fivemPath/run.sh +exec server.cfg
			sleep 2
			greenMsg "Server started."
		else
			screen -S $screen -X stuff "\r\rsay $restartMsg\rsay $restartMsg\rsay $restartMsg\r";
			yellowMsg "[CTRL+C] to cancel"
			countdown $2
			screen -S $screen -X quit
			sleep 1
			cyanMsg "Server stopped."
			sleep 1
			yellowMsg "Server is starting..."
			screen -dmS $screen $fivemPath/run.sh +exec server.cfg
			sleep 2
			greenMsg "Server started"
		fi
	else
		redMsg "Server not started"
		yellowMsg "Use : $0 start/debug (to start the server)"
	fi
	;;

# Status
	status)
	if isOn; then
		greenMsg "Server is running"
	else
		redMsg "Server is not running."
	fi
	;;

# Command
	cmd)
	if isOn; then
		if [ -z "$2" ]; then
			yellowMsg "Usage: $0 cmd \"command to run\"."
			read -r -p "Do you want to reattach to the screen instead? [y/N]" useScreen
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
		redMsg "Server is not running."
	fi
  ;;

# Start in debug mode
	debug)
	if isOn; then
		redMsg "Server is already started"
	else
		yellowMsg "Server is starting in debug mode..."
		screen -S $screen $fivemPath/run.sh +exec server.cfg
	fi
  ;;
	*)
	yellowMsg "Usage: $0 {update|start|stop|restart|status|cmd|debug}"
  exit 1
  ;;
esac
exit 0
