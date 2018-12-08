$ErrorActionPreference = 'Stop';

$url32          = 'https://downloads.mariadb.org/f/mariadb-10.3.11/win32-packages/mariadb-10.3.11-win32.zip'
$checksum32     = 'f4b4b5580c53d0c936ed0eaf005f55c12be47aad0c8e5ad9029fd1c6ad0e4a3a'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.mariadb.org/f/mariadb-10.3.11/winx64-packages/mariadb-10.3.11-winx64.zip'
$checksum64     = '70766f752019c15e1eb3db292be67f4def0c7a75166283ecffc4dd510e4ddfb2'
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
# shut down service if running
try {
  write-host "Shutting down MySQL if it is running"
  Start-ChocolateyProcessAsAdmin "cmd /c NET STOP MySQL"
  Start-ChocolateyProcessAsAdmin "cmd /c sc delete MySQL"
} catch {
  # no service installed
}

# delete current bin directory contents
if ([System.IO.Directory]::Exists("$installDirBin")) {
  write-host "Clearing out the contents of `'$installDirBin`'."
  start-sleep 3
  [System.IO.Directory]::Delete($installDirBin,$true)
}

# copy the installed directory into the current dir
Write-host "Copying contents of `'$installedContentsDir`' to `'$($installDir)\current`'."
[System.IO.Directory]::CreateDirectory("$installDirBin") | Out-Null
Copy-Item "$($installedContentsDir)\*" "$($installDir)\current" -Force -Recurse

# initialize everything
Write-Host "Initializing MariaDB if it hasn't already been initialized."

try {
  $defaultDataDir='C:\ProgramData\MariaDB\data'
  if (![System.IO.Directory]::Exists($defaultDataDir)) {[System.IO.Directory]::CreateDirectory($defaultDataDir) | Out-Null}
  Start-ChocolateyProcessAsAdmin "cmd /c '$($installDirBin)\mysql_install_db.exe --datadir=$($defaultDataDir) --service=MySQL'"
} catch {
  write-host "MariaDB has already been initialized"
}

# turn on the service
Start-ChocolateyProcessAsAdmin "cmd /c NET START MySQL"
