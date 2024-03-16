# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@4106c5776d3ca53c63912a20b56fc3b41a535a43/icons/mongodb.png" width="32" height="32"/> [![MongoDB](https://img.shields.io/chocolatey/v/mongodb.svg?label=MongoDB)](https://community.chocolatey.org/packages/mongodb) [![MongoDB](https://img.shields.io/chocolatey/dt/mongodb.svg)](https://community.chocolatey.org/packages/mongodb)

## Usage

To install MongoDB, run the following command from the command line or from PowerShell:

```powershell
choco install mongodb
```

To upgrade MongoDB, run the following command from the command line or from PowerShell:

```powershell
choco upgrade mongodb
```

To uninstall MongoDB, run the following command from the command line or from PowerShell:

```powershell
choco uninstall mongodb
```

## Description

MongoDB (from "humongous") is a scalable, high-performance, open source NoSQL database written in C++.

MongoDB stores data using a flexible document data model that is similar to JSON. Documents contain one or more fields, including arrays, binary data and sub-documents. Fields can vary from document to document. This flexibility allows development teams to evolve the data model rapidly as their application requirements change.

Developers access documents through rich, idiomatic drivers available in all popular programming languages. Documents map naturally to the objects in modern languages, which allows developers to be extremely productive. Typically, there’s no need for an ORM layer.

#### Package Parameters

The following package parameters can be set:

* `/dataPath:` - where MongoDB stores its database files - defaults to "$env:ProgramData\MongoDB\data\db"
* `/logPath:` - where MongoDB stores its logs - defaults to "$env:ProgramData\MongoDB\log"

To pass parameters, use `--params "''"` (e.g. `choco install packageID [other options] --params="'/ITEM:value /ITEM2:value2 /FLAG_BOOLEAN'"`).
To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.



## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/mongodb)

[Software Site](http://www.mongodb.org)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/mongodb)

