$ErrorActionPreference = 'Stop'
$url         = 'https://dsadata.intel.com/installer'
$checksum    = '2FD7C01B67F8EF9D7C7687591CB651C80542F9C62FE9D41C3FAE359C532BD59D'

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
