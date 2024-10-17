$ErrorActionPreference = 'Stop'
$packageName = 'intel-dsa'
$url         = 'https://dsadata.intel.com/installer/'
$checksum    = 'A64BAA1195DBFD4A462D1D2854F40CE293E08C999F91235D4134CCA75021A0E0'

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
