$ErrorActionPreference = 'Stop';
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-4.0.11-signed.msi'
$checksum64     = '0147ca4aae70b6563b6703b720d982bf3b85533f9fb4e42e0d7f14cf690ba271'
$checksumType64 = 'sha256'
$silentArgs     = 'ADDLOCAL="Server,ServerService,Router,Client,MonitoringTools,ImportExportTools,MiscellaneousTools" /qn /norestart'
$dataPath       = "$env:PROGRAMDATA\MongoDB\data\db"
$logPath        = "$env:PROGRAMDATA\MongoDB\log"

# Allow the user to specify the data and log path, falling back to sensible defaults
$pp = Get-PackageParameters

if($pp.dataPath) {
    $dataPath = $pp.dataPath
}
if($pp.logPath) {
    $logPath = $pp.logPath
}

# Create directories
New-Item -ItemType Directory $dataPath -ErrorAction SilentlyContinue
New-Item -ItemType Directory $logPath -ErrorAction SilentlyContinue

$silentArgs += " MONGO_DATA_PATH=`"$dataPath`" "
$silentArgs += " MONGO_LOG_PATH=`"$logPath`" "

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName   = 'MongoDB *'
  silentArgs     = $silentArgs
  validExitCodes = @(0,3010)
}

Install-ChocolateyPackage @packageArgs

# start the service
Start-Service -Name MongoDB -ErrorAction SilentlyContinue

# service status
if((Get-Service -Name MongoDB).Status -ne "Running") {
  Write-Warning "  * MongoDB service is currenty not running, this could be due to an required reboot of one of the dependencies"
}
