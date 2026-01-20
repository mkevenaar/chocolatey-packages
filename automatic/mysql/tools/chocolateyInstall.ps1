$ErrorActionPreference = 'Stop';

$url = 'https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.8-winx64.zip'
$checksum = '53685bb61a1efc5ecc1b35c1b6bd0d30ba799f4943a1ef2c34df464f5a774c7f'
$checksumType = 'sha256'

$pp = Get-PackageParameters

$packageName = 'mysql'
$binRoot = if ($pp.installLocation) { $pp.installLocation } else { Get-ToolsLocation }
$installDir = Join-Path $binRoot "$packageName"
$installDirBin = "$($installDir)\current\bin"
Write-Host "Adding `'$installDirBin`' to the path and the current shell path"
Install-ChocolateyPath "$installDirBin"
$env:Path = "$($env:Path);$($installDirBin)"
$port = if ($pp.Port) { $pp.Port } else { 3306 }
$serviceName = if ($pp.serviceName) { $pp.serviceName } else { "MySQL" }
$dataDir = if ($pp.dataLocation) { Join-Path $pp.dataLocation "$packageName" } else { "C:\ProgramData\MySQL" }

if (![System.IO.Directory]::Exists($installDir)) { [System.IO.Directory]::CreateDirectory($installDir) | Out-Null }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $installDir
  url64          = $url
  checksum64     = $checksum
  checksumType64 = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

# find the unpack directory
$installedContentsDir = get-childitem $installDir -include 'mysql*' | Sort-Object -Property LastWriteTime -Desc | Select-Object -First 1

# shut down service if running
try {
  write-host "Shutting down MySQL if it is running"
  Start-ChocolateyProcessAsAdmin "cmd /c NET STOP $serviceName"
  Start-ChocolateyProcessAsAdmin "cmd /c sc delete $serviceName"
}
catch {
  # no service installed
}

# delete current bin directory contents
if ([System.IO.Directory]::Exists("$installDirBin")) {
  Write-Host "Clearing out the contents of `'$installDirBin`'."
  Start-Sleep 3
  [System.IO.Directory]::Delete($installDirBin, $true)
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
datadir=$($dataDir.Replace("\","\\"))\\data
port=$port
"@ | Out-File $iniFileDest -Force -Encoding ASCII
}

# initialize everything
# https://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization-mysqld.html
Write-Host "Initializing MySQL if it hasn't already been initialized."
try {

  $defaultDataDir = Join-Path $dataDir "data"
  if (![System.IO.Directory]::Exists($defaultDataDir)) { [System.IO.Directory]::CreateDirectory($defaultDataDir) | Out-Null }
  Start-ChocolateyProcessAsAdmin "cmd /c '$($installDirBin)\mysqld' --defaults-file='$iniFileDest' --initialize-insecure"
}
catch {
  write-host "MySQL has already been initialized"
}

# install the service itself
write-host "Installing the mysql service"
Start-ChocolateyProcessAsAdmin "cmd /c '$($installDirBin)\mysqld' --install $serviceName"
# turn on the service
Start-ChocolateyProcessAsAdmin "cmd /c NET START $serviceName"
