$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_4_6_4.exe'
$checksum32     = 'd0ed570cdfc97fc3b91dc262ee9c74a4e325f6bed8ca85fa917dabae1a5b5acb'
$checksumType32 = 'sha256'
$url64          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_4_6_4_x64.exe'
$checksum64     = '001163e4322435e2fb4aae703776c491f6c0a0fb24f21c895ade1ea15d5e5948'
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
  softwareName   = 'OpenFire*'
  silentArgs     = '-q'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
