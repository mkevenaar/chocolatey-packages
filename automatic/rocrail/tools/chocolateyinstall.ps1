$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-14563-win32.exe'
$checksum32     = '54ebf15c885d37506cd69abb550455cf7e712481403c48c372a7d0a39023bf09'
$checksumType32 = 'sha256'
$url64          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-14563-win64.exe'
$checksum64     = 'c8ae159f4bd26655b872fb10bc64ee36f5463063d28a8f6d002df47226876e9d'
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

