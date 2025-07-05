$ErrorActionPreference = 'Stop'
$packageName = 'intel-dsa'
$url         = 'https://dsadata.intel.com/installer/'
$checksum    = '39E8CAF7D6E3F2DC312D62F3393DF44B067C7ED2B7E32EFD222FEF3C9A54E170'

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
