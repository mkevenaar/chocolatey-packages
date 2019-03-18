$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.writage.com/Writage-1.12.msi'
$checksum32     = '5bd606a69f0c27cc02164e1295047bc77365867d9237d00c9880b9684aa80d48'
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

