$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.uvnc.eu/download/1224/UltraVNC_1_2_24_X86_Setup.exe'
$checksum32     = 'd55dbaa0c4db03dfce5a98c681a86c31b3524945b1b3aee73f59e3a5501102c0'
$checksumType32 = 'sha256'
$url64          = 'https://www.uvnc.eu/download/1224/UltraVNC_1_2_24_X64_Setup.exe'
$checksum64     = 'e71d6164defea59f8d44a43542bc642461b184ae751ec29b06dfc46aa22bc148'
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

