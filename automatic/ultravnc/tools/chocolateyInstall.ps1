$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.uvnc.eu/download/1230/UltraVNC_1_2_30_X86_Setup.exe'
$checksum32     = '77da28b1bc36edb769bf0e09494bcc465c2689dc3dd82da1902bc06e0ef03581'
$checksumType32 = 'sha256'
$url64          = 'https://www.uvnc.eu/download/1230/UltraVNC_1_2_30_X64_Setup.exe'
$checksum64     = 'fe3d1135ae0e7b72394a6f3cc137282cb5e6382a55b5ceee72140d28f5ffe961'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'UltraVnc*'
  silentArgs    = '/VERYSILENT /NORESTART /RESTARTEXITCODE=3010 /SP- /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS'
  validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs

