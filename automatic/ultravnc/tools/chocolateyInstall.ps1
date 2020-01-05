$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.uvnc.eu/download/1230/UltraVNC_1_2_30_X86_Setup.exe'
$checksum32     = '21d4d4a35cb7111b273b18b67db8cf5b8e12e44178796034519eed0479039c72'
$checksumType32 = 'sha256'
$url64          = 'https://www.uvnc.eu/download/1230/UltraVNC_1_2_30_X64_Setup.exe'
$checksum64     = ''
$checksumType64 = ''

$options = @{
  Headers = @{
    Referer = 'https://www.uvnc.com/';
  }
}


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
  options        = $options
  validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs

