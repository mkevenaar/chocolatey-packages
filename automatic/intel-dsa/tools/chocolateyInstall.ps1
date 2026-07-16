$ErrorActionPreference = 'Stop'
$url         = 'https://dsadata.intel.com/installer/'
$checksum    = 'D6EDB02027C4800F247B1658959272C720B007685FE093FFA899D6E9B06342B1'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  url            = $url
  silentArgs     = '-s -norestart'
  validExitCodes = @(0, 3010, 1641)
  softwareName   = 'Intel® Driver & Support Assistant'
  checksum       = $checksum
  checksumType   = 'sha256'
}

Install-ChocolateyPackage @packageArgs
