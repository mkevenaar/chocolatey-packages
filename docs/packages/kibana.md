# Kibana

<img
  src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@27d92fa2fac6f589a8872281166f3020c60d6152/icons/kibana.svg"
  alt="Package icon"
  width="32" height="32"/>

[![Chocolatey version][choco-docs-version]][choco-docs-package]
[![Chocolatey downloads][choco-docs-downloads]][choco-docs-package]

[choco-docs-version]: <https://img.shields.io/chocolatey/v/kibana.svg?label=Kibana>
[choco-docs-downloads]: <https://img.shields.io/chocolatey/dt/kibana.svg>
[choco-docs-package]: <https://community.chocolatey.org/packages/kibana>

## Usage

To install Kibana, run the following command:

```powershell
choco install kibana
```

To upgrade Kibana, run the following command:

```powershell
choco upgrade kibana
```

To uninstall Kibana, run the following command:

```powershell
choco uninstall kibana
```

## Description

Kibana is an open source data visualization platform that allows you to interact
with your data through stunning, powerful graphics that can be combined into
custom dashboards that help you share insights from your data far and wide.

Kibana will be installed in %ChocolateyInstall%\lib\Kibana and add a service
called "kibana-service".

The Kibana service is set to manually start by default. It can be set to
automatically start by changing the service properties.

This is an automatic package.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/kibana)

[Software Site](https://www.elastic.co/kibana/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/kibana)
