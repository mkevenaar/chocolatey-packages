$ErrorActionPreference = 'Stop'
$packageName = 'intel-dsa'
$url         = 'https://dsadata.intel.com/installer/'
$checksum    = '52eaffd149e285a66c469df01882c3e87326808b173551b2090ccbb36f21ecb7'

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
