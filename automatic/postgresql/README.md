# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@146ea9a4b2fdab35e5de69a738307afe89969e9b/icons/postgresql.png" width="48" height="48"/> [![](https://img.shields.io/chocolatey/v/postgresql.svg?color=red&label=postgresql)](https://community.chocolatey.org/packages/postgresql) [![](https://img.shields.io/chocolatey/v/postgresql14.svg?color=red&label=postgresql14)](https://community.chocolatey.org/packages/postgresql14) [![](https://img.shields.io/chocolatey/v/postgresql13.svg?color=red&label=postgresql13)](https://community.chocolatey.org/packages/postgresql13) [![](https://img.shields.io/chocolatey/v/postgresql12.svg?color=red&label=postgresql12)](https://community.chocolatey.org/packages/postgresql12) [![](https://img.shields.io/chocolatey/v/postgresql11.svg?color=red&label=postgresql11)](https://community.chocolatey.org/packages/postgresql11) [![](https://img.shields.io/chocolatey/v/postgresql10.svg?color=red&label=postgresql10)](https://community.chocolatey.org/packages/postgresql10) [![](https://img.shields.io/chocolatey/v/postgresql9.svg?color=red&label=postgresql9)](https://community.chocolatey.org/packages/postgresql9)

**PostgreSQL** is a powerful, open-source **object-relational database management system (ORDBMS)**, developed at the **University of California, Berkeley**.
It extends the POSTGRES project and pioneered features later adopted by other commercial systems.

PostgreSQL is **free to use, modify, and distribute** for private, commercial, or academic purposes.

## Features

- See the [Feature Matrix](https://www.postgresql.org/about/featurematrix)

## Package parameters

| Parameter | Description |
|------------|--------------|
| `/AllowRemote` | Enables remote connections (adds entries to `pg_hba.conf`). |
| `/Password` | Sets password for `postgres` user. If omitted, one is generated. Ignored if PostgreSQL already exists. |
| `/Port` | Database server port. Defaults to `5432` or next available port. |
| `/NoPath` | Prevents adding PostgreSQL `bin` directory to `PATH`. |

Other parameters could be set via `--ia` argument, example:

```powershell
choco install postgresql13 --params '/Password:test /Port:5433' --ia '--enable-components server,commandlinetools'
```

Check all [installer](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads) options by adding `--help` as command line argument.

## Notes

- Test installation (specify your password):
`$Env:PGPASSWORD='test'; '\conninfo' | psql -Upostgres`
This should output:
`You are connected to database "postgres" as user "postgres" on host "localhost" at port "5432"`
- This package will install PostgreSQL to `$Env:ProgramFiles\PostgreSQL\[MajorVersion]`.
- If you have problems during installation see [troubleshooting page](https://wiki.postgresql.org/wiki/Troubleshooting_Installation).
- If you didn't specify password during setup and didn't record the generated one, you need manually reset it using the following steps:
  - Open file `data\pg_hba.conf` in PostgreSql installation directory
  - Change `METHOD` to `trust` and restart service with `Restart-Service postgresql*`
  - Execute `"alter user postgres with password '[my password]';" | psql -Upostgres`
  - Revert back `data\pg_hba.conf` to METHOD `md5` and restart service

### Virtual package

Each major version has its own package: `postgresql<Version>`

**Virtual package** [postgresql](https://community.chocolatey.org/packages/postgresql) also contains all versions that depend on adequate major version, but using it without problems require some special choco parameters.

To propagate package parameters to dependencies use `--params-global` choco install parameter with virtual package `postgresql`. Assuming latest version is 12, to provide password the following two examples result in identical installation:

```sh
choco install postgresql --params '/Password:test' --params-global
choco install postgresql12 --params '/Password:test'
```

To uninstall dependent package use `--force-dependencies`:

```sh
# The following two examples are identical
choco uninstall postgresql --force-dependencies
choco uninstall postgresql12 postgresql

# This example uninstalls only postgresql virtual package and not postgresql12
choco uninstall postgresql
```

To force reinstallation via virtual package use `--force-dependencies`:

```sh
# The following two examples are identical
choco install postgresql --force --force-dependencies
choco install postgresql12 --force --force-dependencies

# This will reinstall only postgresql virtual package and not its dependency postgresql12
choco install postgresql -force

# This one is different then the first one as vcredist140 dependency is not reinstalled
choco install postgresql12 --force
```

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
