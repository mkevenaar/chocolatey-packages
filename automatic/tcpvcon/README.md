# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@063ff9b74c2db9c04d9fd1fb9a239adbea3c0d71/icons/tcpvcon.png" width="48" height="48"/> [tcpvcon](https://community.chocolatey.org/packages/tcpvcon)


TCPVcon will show you detailed listings of all TCP and UDP endpoints on your system, including the local and remote addresses and state of TCP connections. On Windows Server 2008, Vista, and XP, TCPVcon also reports the name of the process that owns the endpoint. TCPVcon provides a more informative and conveniently presented subset of the Netstat program that ships with Windows.

#### Command line usage

Tcpvcon usage is similar to that of the built-in Windows netstat utility:

__tcpvcon__ [__-a__] [__-c__] [__-n__] [[process name] [PID]]

__-a__  Show all endpoints (default is to show established TCP connections)

__-c__  Print output as CSV

__-n__  Don't resolve addresses

