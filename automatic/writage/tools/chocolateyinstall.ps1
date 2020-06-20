$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.writage.com/Writage-1.12.2.msi'
$checksum32     = '5be64c7e70d998ee9db36191b9238dd1d4eb3a626c7c30448f704876cf0ab762'
$checksumType32 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Writage*'
  fileType      = 'msi'
  silentArgs    = "ALLUSERS=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs

