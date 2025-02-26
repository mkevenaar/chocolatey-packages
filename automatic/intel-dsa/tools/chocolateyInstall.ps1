$ErrorActionPreference = 'Stop'
$packageName = 'intel-dsa'
$url         = 'https://dsadata.intel.com/installer/'
$checksum    = 'eb0f64839742edf69a72ea0c9c8106cd66eff7dfe9bf2f8edb6f789de90db9fe'

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
