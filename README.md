# PyDrivingSim
Minimal driving simulator for testing high level and low levl control, 
in the contex of aunomous driving

## Setup on windows
1. Follow the visual studio code guide for setup python on windows (up to the "Install and use packages" section)
2. Execute:
    - Go the project folder
    - Create the virtual env: `py -3 -m venv .venv`
    - enable the environment: `. .venv\scripts\activate`
    - Install packages: `pip install -r requirements.txt`
3. Open the file simulator.py
4. Run the simulator: `python simulator.py`

## Setup on Linux or Windows WLS
1. Open a shell and execute:
    - Go the project folder
    - Install python and pip 
    - Install virtual env: `sudo apt-get install python3-venv`
    - Create the virtual env: `python3 -m venv .venv`
    - enable the environment: `source .venv/bin/activate`
    - Install packages: `pip install -r requirements.txt`
2. Open the file simulator.py
3. Run the simulator: `python simulator.py`

### Problem on WLS Windows 10:
People that have installed WSL on Windows 10 have this error: 
`pygame.error: No available video device`

To solve it follow this procedure (https://techcommunity.microsoft.com/t5/windows-dev-appconsult/running-wsl-gui-apps-on-windows-10/ba-p/1493242):
1. Install XLaunch and set "Disable access control", then save this configuration in %AppData%\Microsoft\Windows\Start Menu\Programs\Startup folder to avoid to open XLaunch each time the PC is restarted 
2. Set the DISPLAY environment variable on Linux to use the Windows host's IP address. In the terminal run:
   
   <code>export DISPLAY="\`grep nameserver /etc/resolv.conf | sed 's/nameserver //'\`:0"</code>

3. It is possible to see that the $DISPLAY environment variable now has the Windows Host’s IP set running the following command: echo $DISPLAY 
4. To avoid having to run that command every time that WSL is launched, you can paste the command (export DISPLAY..) at the end of the /etc/bash.bashrc file, running: nano ~/.bashrc or gedit ~/.bashrc 
5. It is also necessary to create a .xsession file in the user's home directory:
  `echo xfce4-session > ~/.xsession`
6. Finally run: `sudo apt-get update`