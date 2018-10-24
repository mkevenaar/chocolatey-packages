$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://wiki.rocrail.net/rocrail-snapshot/rocrail-14507-win32.exe'
$checksum32     = '8e2b0fd83d24a78914a2dfa37cbbb7bdd2b1b320203fa51be498c41268a3e65f'
$checksumType32 = 'sha256'
$url64          = 'https://wiki.rocrail.net/rocrail-snapshot/rocrail-14507-win64.exe'
$checksum64     = '94a10a8a32ee279e5ad9f867edb79b5f66b43e5d67209e8592acaf7ba6fdc769'
$checksumType64 = 'sha256'


#Based on InnoSetup
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = 'sha256'
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= 'sha256'
  softwareName  = 'Rocrail*'
  silentArgs    = "/VERYSILENT /NORESTART /RESTARTEXITCODE=3010 /SP- /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS"
  validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs

