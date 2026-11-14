$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  url           = 'https://github.com/balena-io/etcher/releases/download/v2.1.9/balenaEtcher-2.1.9.Setup.exe'
  checksum      = '3fa63ea453e75c0338f8f1444b511f38decdd002e17922a910aec5e29b85b751'
  checksumType  = 'sha256'
  silentArgs    = '/S'
  softwareName  = 'etcher*'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
