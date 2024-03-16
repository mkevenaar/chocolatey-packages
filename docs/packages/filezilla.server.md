# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@715a1639b4122317e68f360d5e48f89ead28698e/icons/filezilla.server.png" width="32" height="32"/> [![FileZilla Server](https://img.shields.io/chocolatey/v/filezilla.server.svg?label=FileZilla+Server)](https://community.chocolatey.org/packages/filezilla.server) [![FileZilla Server](https://img.shields.io/chocolatey/dt/filezilla.server.svg)](https://community.chocolatey.org/packages/filezilla.server)

## Usage

To install FileZilla Server, run the following command from the command line or from PowerShell:

```powershell
choco install filezilla.server
```

To upgrade FileZilla Server, run the following command from the command line or from PowerShell:

```powershell
choco upgrade filezilla.server
```

To uninstall FileZilla Server, run the following command from the command line or from PowerShell:

```powershell
choco uninstall filezilla.server
```

## Description

FileZilla Server is a server that supports FTP and FTP over TLS which provides secure encrypted connections to the server.

FileZilla supports TLS, the same level of encryption supported by your web browser, to protect your data. When using TLS your data is encrypted so that prying eyes cannot see it, and your confidential information is protected. It also supports on-the-fly data compression, which can improve the transfer rates.

Unfortunately, the compression setting can have mixed results, so it is advised to use it with care. It is possible for files that are already compressed to be transferred over the network using more than their original data size.

Support for SFTP (SSH File Transfer Protocol) is not implemented in Filezilla Server.

## Package Parameters

* `/ftproot` - Set the FTP Document root. The directory will be created if it does not exists. Default: `C:\temp\ftproot`

Example: `choco install filezilla.server --params '"/ftproot:C:\ftpRoot"'`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/filezilla.server)

[Software Site](http://filezilla-project.org)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/filezilla.server)

