$ErrorActionPreference = 'Stop'
$url         = 'https://dsadata.intel.com/installer/'
$checksum    = '5B4957C11B7370CBC2A0EE0F5AFDC3DFCA3BC624A9165EB0BC0A8FE3C7AEEE5E'

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
