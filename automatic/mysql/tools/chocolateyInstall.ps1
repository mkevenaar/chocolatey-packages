$ErrorActionPreference = 'Stop';

$url = 'https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.14-winx64.zip'
$checksum = 'f4a114d03e4ddb0260421b67a5fa2817c5c55464b86f63e02057186a1a6dad28'
$checksumType = 'sha256'

$packageName = 'mysql'
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
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

# find the unpack directory
$installedContentsDir = get-childitem $installDir -include 'mysql*' | Sort-Object -Property LastWriteTime -Desc | Select-Object -First 1

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
  Write-Host "Clearing out the contents of `'$installDirBin`'."
  Start-Sleep 3
  [System.IO.Directory]::Delete($installDirBin,$true)
}

# copy the installed directory into the current dir
Write-host "Copying contents of `'$installedContentsDir`' to `'$($installDir)\current`'."
[System.IO.Directory]::CreateDirectory("$installDirBin") | Out-Null
Copy-Item "$($installedContentsDir)\*" "$($installDir)\current" -Force -Recurse

$iniFileDest = "$($installDir)\current\my.ini"
if (!(Test-Path($iniFileDest))) {
  Write-Host "No existing my.ini. Creating default '$iniFileDest' with default locations for datadir."

@"
[mysqld]
basedir=$($installDir.Replace("\","\\"))\\current
datadir=C:\\ProgramData\\MySQL\\data
"@ | Out-File $iniFileDest -Force -Encoding ASCII
}

# initialize everything
# https://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization-mysqld.html
Write-Host "Initializing MySQL if it hasn't already been initialized."
try {

  $defaultDataDir='C:\ProgramData\MySQL\data'
  if (![System.IO.Directory]::Exists($defaultDataDir)) {[System.IO.Directory]::CreateDirectory($defaultDataDir) | Out-Null}
  Start-ChocolateyProcessAsAdmin "cmd /c '$($installDirBin)\mysqld' --defaults-file=$iniFileDest --initialize-insecure"
} catch {
  write-host "MySQL has already been initialized"
}

# install the service itself
write-host "Installing the mysql service"
Start-ChocolateyProcessAsAdmin "cmd /c '$($installDirBin)\mysqld' --install"
# turn on the service
Start-ChocolateyProcessAsAdmin "cmd /c NET START MySQL"

