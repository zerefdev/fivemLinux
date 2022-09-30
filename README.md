# Description

fivemLinux is a bash tool that lets you manage your FiveM server in a easy way using the command line.  
If you have any suggestions or improvements, don't hesitate to send your pull requests

# Installation

1. connect to your virtual server
2. download the tool using _wget_  
   `wget https://raw.githubusercontent.com/zerefdev/fivemLinux/master/fivem.sh`
3. Convert the file to unix format if needed and give it execution permission  
   3.1. Install dos2unix  
    `sudo apt install dos2unix`  
   3.2. Convert the file to unix format  
    `dos2unix fivem.sh`  
   3.3. Give it permission to "execute"  
    `chmod +x fivem.sh`
4. Start the installation process and follow the instructions  
   `./fivem.sh`
5. Done!

# Usage

-   .**/fivem.sh update**  
    updates fivemLinux to the latest version
-   .**/fivem.sh start**  
    starts the server in silent mode
-   .**/fivem.sh stop**  
    stops the server
-   .**/fivem.sh restart X**  
    restarts the server after X seconds  
    if **X** is not given, the server will be **instantly** restarted
-   .**/fivem.sh status**  
    returns if server is running or not
-   .**/fivem.sh cmd "command arg"**  
    allows you to send commands via the console (_restart a resource..etc_)
-   .**/fivem.sh debug**  
    starts the server in debug mode (it will output the start process)

# TODO

-   ~~improve cmd case~~
-   ~~better path saving method~~ Using the best method so far
-   ~~add confirmation for input~~ path ~~and cmd~~
-   daily auto-restart (refresh RAM, reset players IDs)
-   option to set restart timer to minute insteads of seconds
-   ~~duplicate restartMsg so players will see it 100%~~

# Changelog

## [2.0] - 29.05.2019

-   global improvement and organisation
-   color variables removed, replaced with functions
-   _cmd_ prompts a confirmation text if no command was given
-   _debug_ added to see starting process output (for errors)
-   _update_ added

## [1.0] - 27.05.2019

-   initial release
-   basic functions
