$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.uvnc.eu/download/1224/UltraVNC_1_2_24_X86_Setup.exe'
$checksum32     = 'b0c6b307c35f87c738c29f38ad6a33355a186002f5b94b57e54d94d83381c0db'
$checksumType32 = 'sha256'
$url64          = 'https://www.uvnc.eu/download/1224/UltraVNC_1_2_24_X64_Setup.exe'
$checksum64     = 'f8ce2e5633c8c5413cb73fcfc78ab0b631f929d29d5632a57480b17714f6c0a5'
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

