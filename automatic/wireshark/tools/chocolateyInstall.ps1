$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.wireshark.org/download/win32/all-versions/Wireshark-win32-3.0.0.exe'
$checksum32     = 'ca59a35866b5837578070ae064bb099d7a50b81be6b86884679aa86ef08ea89f'
$checksumType32 = 'sha256'
$url64          = 'https://www.wireshark.org/download/win64/all-versions/Wireshark-win64-3.0.0.exe'
$checksum64     = 'b5d30a9c0b2835a41e8132b1d9246a01ad6f1461a4de14fa3ccbdf4919c70eac'
$checksumType64 = 'sha256'


$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url32
  checksum       = $checksum32
  checksumType   = $checksumType32
  url64          = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
  silentArgs     = '/S /quicklaunchicon=no'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

