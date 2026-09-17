# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@1c483c548298106c6f452822150342deee69eccb/icons/psql.png" width="32" height="32"/> [![PostgreSQL CLI client](https://img.shields.io/chocolatey/v/psql.svg?label=PostgreSQL+CLI+client)](https://community.chocolatey.org/packages/psql) [![PostgreSQL CLI client](https://img.shields.io/chocolatey/dt/psql.svg)](https://community.chocolatey.org/packages/psql)

## Usage

To install PostgreSQL CLI client, run the following command from the command line or from PowerShell:

```powershell
choco install psql
```

To upgrade PostgreSQL CLI client, run the following command from the command line or from PowerShell:

```powershell
choco upgrade psql
```

To uninstall PostgreSQL CLI client, run the following command from the command line or from PowerShell:

```powershell
choco uninstall psql
```

## Description

psql is a terminal-based front-end to PostgreSQL. It enables you to type in queries interactively, issue them to PostgreSQL, and see the query results. Alternatively, input can be from a file or from command line arguments. In addition, psql provides a number of meta-commands and various shell-like features to facilitate writing scripts and automating a wide variety of tasks.

This package provides the 64-bit Windows commands `psql`, `pg_dump`, `pg_dumpall`, and `pg_restore`, with their required runtime libraries. It does not install a PostgreSQL server or create a database service.

## Versioned packages

Each supported PostgreSQL major has its own client package, named `psql<major>`. Install and upgrade `psql18` to stay on PostgreSQL 18:

```powershell
choco install psql18
choco upgrade psql18
choco uninstall psql18
```

## Virtual package

The `psql` package depends on the exact corresponding version of `psql<major>`. Its newest release follows the newest supported stable PostgreSQL major; upgrading it can therefore install a new major version.

```powershell
choco install psql
choco upgrade psql
choco uninstall psql --force-dependencies
```

Uninstalling `psql` without `--force-dependencies` removes only the virtual package. A previous major package may remain installed after a major upgrade; uninstall it separately when it is no longer needed.

The client commands use Chocolatey's standard executable shims. If multiple major packages are installed, the command on `PATH` follows the shim most recently installed. Use the executable in the required package's `tools` directory to select a particular major explicitly.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/psql)

[Software Site](https://www.postgresql.org)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/psql)
