# Description
fivemLinux is a bash tool that lets you administrate your FiveM server in a easy way using the command line.

**PLEASE WATCH THE VIDEO BELOW**

# Installation
1. connect to your virtual server  
2. download the tool using *wget*  
`wget https://raw.githubusercontent.com/Zerefdev/fivemLinux/master/fivem.sh`
3. convert the file to unix format if needed and give it execution permission  
`apt install dos2unix`  
 `dos2unix fivem.sh`  
 `chmod +x fivem.sh`  
4. start the installation process and follow the instructions  
`./fivem.sh`  
5. done!

# Usage
* .**/fivem.sh start**  
starts the server
* .**/fivem.sh stop**  
stops the server
* .**/fivem.sh restart X**  
starts the server after X seconds  
if X not  given, it will restart instantly
* .**/fivem.sh status** 
returns if server is running or not
* .**/fivem.sh cmd "Command"** 
allows you to send commands via the console (*restart a resource..etc*)

# Demo video

[![IYoutube Video](http://img.youtube.com/vi/_g7CxD-Lj64/0.jpg)](http://www.youtube.com/watch?v=_g7CxD-Lj64)

# TODO
* improve cmd case  
* better path saving method  
* add confirmation for input path and cmd  
