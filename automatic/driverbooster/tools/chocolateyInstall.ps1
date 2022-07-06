$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://cdn.iobit.com/dl/driver_booster_setup.exe'
$checksum     = '3E9174398C15451B5D083E65402247DA438B4048C1151FBCB69041EE20FAAEC5'

$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Driver Booster*'
  fileType      = 'exe'
  silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes= @(0,3010)
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
