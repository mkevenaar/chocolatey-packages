$ErrorActionPreference = 'Stop';

$url32          = 'https://downloads.mariadb.org/f/mariadb-10.5.1/win32-packages/mariadb-10.5.1-win32.zip'
$checksum32     = '4ffa688159253db1864d0c8b14e98fbc0a530c8cf5c0fd23515e64575205b361'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.mariadb.org/f/mariadb-10.5.1/winx64-packages/mariadb-10.5.1-winx64.zip'
$checksum64     = 'de7941fad5eeabe3cc23a0befbada76c0abe2c115fb4ede2dbf5fca551b2a053'
$checksumType64 = 'sha256'

$packageName = 'mariadb'
$binRoot = Get-ToolsLocation
$installDir = Join-Path $binRoot "$packageName"
$installDirBin = "$($installDir)\current\bin"
Write-Host "Adding `'$installDirBin`' to the path and the current shell path"
Install-ChocolateyPath "$installDirBin"
$env:Path = "$($env:Path);$($installDirBin)"

if (![System.IO.Directory]::Exists($installDir)) {[System.IO.Directory]::CreateDirectory($installDir) | Out-Null}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $installDir
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
}

Install-ChocolateyZipPackage  @packageArgs

# find the unpack directory
$installedContentsDir = Get-ChildItem $installDir -include 'mariadb*' | Sort-Object -Property LastWriteTime -Desc | Select-Object -First 1

# delete current bin directory contents
if ([System.IO.Directory]::Exists("$installDirBin")) {
  Write-Host "Clearing out the contents of `'$installDirBin`'."
  Start-Sleep 3
  [System.IO.Directory]::Delete($installDirBin,$true)
}

# copy the installed directory into the current dir
Write-host "Copying contents of `'$installedContentsDir`' to `'$($installDir)\current`'."
[System.IO.Directory]::CreateDirectory("$installDirBin") | Out-Null
Copy-Item "$($installedContentsDir)\*" "$($installDir)\current" -Force -Recurse

# initialize everything
Write-Host "Initializing MariaDB if it hasn't already been initialized."

$defaultDataDir='C:\ProgramData\MariaDB\data'
if (![System.IO.Directory]::Exists($defaultDataDir)) {
  [System.IO.Directory]::CreateDirectory($defaultDataDir) | Out-Null
}

Start-Process $installDirBin\mysql_install_db.exe --datadir=$defaultDataDir
