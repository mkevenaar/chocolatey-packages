$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://downloadmirror.intel.com/29205/eng/Intel%20SSD%20Toolbox%20-%20v3.5.12.exe'
$checksum     = '36864e8842dca7641bd5707309085588aeafb47ad52f41c9ac4bb90b333e4908'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'Intel SSD*'
  silentArgs    = "/s"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
