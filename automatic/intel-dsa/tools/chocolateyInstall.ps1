$ErrorActionPreference = 'Stop'
$packageName = 'intel-dsa'
$url         = 'https://dsadata.intel.com/installer/'
$checksum    = 'c8257bd8a8a7e63d927492858e29a50decf0938ad724e584cc840a40025591aa'

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'EXE'
  url            = $url
  silentArgs     = '-s -norestart'
  validExitCodes = @(0, 3010, 1641)
  softwareName   = 'Intel® Driver & Support Assistant'
  checksum       = $checksum
  checksumType   = 'sha256'
}

Install-ChocolateyPackage @packageArgs
