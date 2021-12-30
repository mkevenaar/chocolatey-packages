$ErrorActionPreference = 'Stop';
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-5.2.0-rc3-signed.msi'
$checksum64     = '1c9ac933f453d5a0cc093c7cf6a30bd64e34af7e3b54c31d8de251f030388ded'
$checksumType64 = 'sha256'
$silentArgs     = 'ADDLOCAL="ServerService,Server,ProductFeature,Client,Router,MiscellaneousTools" /qn /norestart'
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
