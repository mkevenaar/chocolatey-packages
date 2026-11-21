# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@146ea9a4b2fdab35e5de69a738307afe89969e9b/icons/postgresql.png" width="48" height="48"/> [![](https://img.shields.io/chocolatey/v/postgresql.svg?color=red&label=postgresql)](https://community.chocolatey.org/packages/postgresql) [![](https://img.shields.io/chocolatey/v/postgresql14.svg?color=red&label=postgresql14)](https://community.chocolatey.org/packages/postgresql14) [![](https://img.shields.io/chocolatey/v/postgresql13.svg?color=red&label=postgresql13)](https://community.chocolatey.org/packages/postgresql13) [![](https://img.shields.io/chocolatey/v/postgresql12.svg?color=red&label=postgresql12)](https://community.chocolatey.org/packages/postgresql12) [![](https://img.shields.io/chocolatey/v/postgresql11.svg?color=red&label=postgresql11)](https://community.chocolatey.org/packages/postgresql11) [![](https://img.shields.io/chocolatey/v/postgresql10.svg?color=red&label=postgresql10)](https://community.chocolatey.org/packages/postgresql10) [![](https://img.shields.io/chocolatey/v/postgresql9.svg?color=red&label=postgresql9)](https://community.chocolatey.org/packages/postgresql9)

**PostgreSQL** is a free, open-source object-relational database management system.
It may be used, modified, and distributed for private, commercial, or academic purposes.

## Features

- See the [Feature Matrix](https://www.postgresql.org/about/featurematrix)

## Package parameters

| Parameter | Description |
|------------|--------------|
| `/AllowRemote` | Enables remote connections (adds entries to `pg_hba.conf`). |
| `/Password` | Sets password for `postgres` user. If omitted, one is generated. Ignored if PostgreSQL already exists. |
| `/Port` | Database server port. Defaults to `5432` or next available port. |
| `/NoPath` | Prevents adding PostgreSQL `bin` directory to `PATH`. |

Pass other installer options with `--ia`:

```powershell
choco install postgresql13 --params '/Password:test /Port:5433' --ia '--enable-components server,commandlinetools'
```

Run the [installer](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads) with `--help` for all options.

## Troubleshooting

### Installation through SSH or remote automation

The EDB installer can exit with code `1` after a successful download and checksum
check, reporting:

```text
Error writing file .../postgresql_installer_<id>/temp_check_comspec.bat
```

The [upstream issue](https://github.com/EnterpriseDB/edb-installers/issues/336)
reports this failure in remote sessions and a successful install through RDP.
An [investigation](https://github.com/EnterpriseDB/edb-installers/issues/336#issuecomment-3440350270)
traces it to `USERDOMAIN` being `WORKGROUP` in some SSH sessions, causing invalid
temporary-directory permissions. This error can also have other causes.

Compare these values in the failing session:

```powershell
[System.Security.Principal.WindowsIdentity]::GetCurrent().Name
"$env:USERDOMAIN\$env:USERNAME"
```

For local accounts, `<computername>\<username>` versus `WORKGROUP\<username>`
indicates a mismatch. Check the session's temporary `installbuilder_installer_*.log`
for `Invalid account`. Retry in an elevated console or RDP PowerShell window.
Report persistent failures with the installer log and account comparison.

## Notes

- Test installation (specify your password):
`$Env:PGPASSWORD='test'; '\conninfo' | psql -Upostgres`
This should report a connection to the `postgres` database on port `5432`.
- This package will install PostgreSQL to `$Env:ProgramFiles\PostgreSQL\[MajorVersion]`.
- If you have problems during installation see [troubleshooting page](https://wiki.postgresql.org/wiki/Troubleshooting_Installation).
- To reset a generated password you did not record:
  - Open file `data\pg_hba.conf` in PostgreSql installation directory
  - Change `METHOD` to `trust` and restart service with `Restart-Service postgresql*`
  - Execute `"alter user postgres with password '[my password]';" | psql -Upostgres`
  - Revert back `data\pg_hba.conf` to METHOD `md5` and restart service

### Virtual package

Each major version has a `postgresql<Version>` package. The virtual
[postgresql](https://community.chocolatey.org/packages/postgresql) package depends on it.
Forward parameters with `--params-global`; use `--force-dependencies` to uninstall
or forcibly reinstall dependencies:

```powershell
choco install postgresql --params '/Password:test' --params-global
choco uninstall postgresql --force-dependencies
choco install postgresql --force --force-dependencies
```

Without `--force-dependencies`, uninstall and forced reinstall affect only the
virtual package.
Forcing dependencies also reinstalls packages such as `vcredist140`.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
