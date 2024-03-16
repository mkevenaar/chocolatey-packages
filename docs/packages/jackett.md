# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@034cf0e5675ac21113c0baf00a8618a105bd47ef/icons/jackett.png" width="32" height="32"/> [![Jackett](https://img.shields.io/chocolatey/v/jackett.svg?label=Jackett)](https://community.chocolatey.org/packages/jackett) [![Jackett](https://img.shields.io/chocolatey/dt/jackett.svg)](https://community.chocolatey.org/packages/jackett)

## Usage

To install Jackett, run the following command from the command line or from PowerShell:

```powershell
choco install jackett
```

To upgrade Jackett, run the following command from the command line or from PowerShell:

```powershell
choco upgrade jackett
```

To uninstall Jackett, run the following command from the command line or from PowerShell:

```powershell
choco uninstall jackett
```

## Description

Jackett works as a proxy server: it translates queries from apps ([Sonarr](https://github.com/Sonarr/Sonarr), [Radarr](https://github.com/Radarr/Radarr), [SickRage](https://sickrage.github.io/), [CouchPotato](https://couchpota.to/), [Mylar](https://github.com/evilhero/mylar), etc) into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. This allows for getting recent uploads (like RSS) and performing searches. Jackett is a single repository of maintained indexer scraping and translation logic - removing the burden from other apps.

## Features

- [Supported Public Trackers](https://github.com/Jackett/Jackett/blob/master/README.md#supported-public-trackers)
- [Supported Semi-Private Trackers](https://github.com/Jackett/Jackett/blob/master/README.md#supported-semi-private-trackers)
- [Supported Private Trackers](https://github.com/Jackett/Jackett/blob/master/README.md#supported-private-trackers)

## Notes

Installs as a service, to get to Jackett open any web browser and go to [localhost]:9117/UI/Dashboard (remove the brackets)

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/jackett)

[Software Site](https://github.com/Jackett/Jackett)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/jackett)

