$ErrorActionPreference = 'Stop';

$url32          = 'https://downloads.mariadb.org/f/mariadb-10.4.10/win32-packages/mariadb-10.4.10-win32.zip'
$checksum32     = '2af6d7473d597125c6b88a73eca511fb3117a37505fd7d7890e426ff7aa6faf0'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.mariadb.org/f/mariadb-10.4.10/winx64-packages/mariadb-10.4.10-winx64.zip'
$checksum64     = 'ad05ef829fb377d9a6b464f741bccec0ada2d8e2ab8d4236315637d46df4fd12'
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
