$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.writage.com/Writage-3.4.1.msi'
$checksum32     = '11472271ddf8273d30a988afb4374fd12ab8d77f6122b0837109e3334042c774'
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

