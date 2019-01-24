$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.uvnc.eu/download/1223/UltraVNC_1_2_23_X86_Setup.exe'
$checksum32     = '15c86e6fe3adae58c588ca9d1685145c0b0e5a3dd096288085c1010f3156ef16'
$checksumType32 = 'sha256'
$url64          = 'https://www.uvnc.eu/download/1223/UltraVNC_1_2_23_X64_Setup.exe'
$checksum64     = 'c1e18360a1f0130f9a909169e3d7b0ac89e73fe328b3404c7109aa36982135da'
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

