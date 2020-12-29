$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.writage.com/Writage-2.5.1.msi'
$checksum32     = 'bbdf2deb0f4d92279f9a0f37c14f9f8a3d11682421fa62725b362ef226278d07'
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

