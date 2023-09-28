$ErrorActionPreference = 'Stop';
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-7.1.0-rc4-signed.msi'
$checksum64     = 'adc483a404d5675bc0ba3c03e9646b22801d50d8d28e0eea9b008492a665d02c'
$checksumType64 = 'sha256'
$silentArgs     = 'ADDLOCAL="ServerService,Server,ProductFeature,Router,MiscellaneousTools" /qn /norestart'
$dataPath       = "$env:PROGRAMDATA\MongoDB\data\db"
$logPath        = "$env:PROGRAMDATA\MongoDB\log"

$WindowsVersion=[Environment]::OSVersion.Version
if ($WindowsVersion.Major -ne "10") {
  throw "This package requires Windows 10 or Windows Server 2016."
}

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
