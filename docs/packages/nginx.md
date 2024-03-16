# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@ac7471b84549c0aaa0dc646044435bdcf692305e/icons/nginx.png" width="32" height="32"/> [![nginx](https://img.shields.io/chocolatey/v/nginx.svg?label=nginx)](https://community.chocolatey.org/packages/nginx) [![nginx](https://img.shields.io/chocolatey/dt/nginx.svg)](https://community.chocolatey.org/packages/nginx)

## Usage

To install nginx, run the following command from the command line or from PowerShell:

```powershell
choco install nginx
```

To upgrade nginx, run the following command from the command line or from PowerShell:

```powershell
choco upgrade nginx
```

To uninstall nginx, run the following command from the command line or from PowerShell:

```powershell
choco uninstall nginx
```

## Description

nginx [engine x] is an HTTP and reverse proxy server, a mail proxy server, a generic TCP/UDP proxy server, as well as a load balancer and an HTTP cache.

## Package Parameters

* `/installLocation` - Intstall to a different destination folder. Default: `$Env:ChocolateyToolsLocation\Nginx*`
* `/serviceName` - The name of the windows service which will be create. Default: `nginx`
* `/port` - The port Nginx will listen to. Default: `80`
* `/noService` - Don't install the nginx windows service
* `/serviceAccount` - account to run Windows Service. One of `System`, `LocalService` or `NetworkService`. Default: `System`

Example: `choco install nginx --params '"/installLocation:C:\nginx /port:433"'`

## Notes

* This package will install the latest Nginx binaries
* The complete path of the package will be `$Env:ChocolateyToolsLocation\Nginx*`
* Nginx will be installed as a service under the default name 'Nginx' (can be disabled with the `/noService` install parameter)

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/nginx)

[Software Site](http://nginx.org)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/nginx)

