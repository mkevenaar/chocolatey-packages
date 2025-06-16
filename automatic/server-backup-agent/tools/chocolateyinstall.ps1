$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x86.msi'
$checksum32     = '3CD527543938B74EB81E3172F74E90CF07D1729979911EFCE99D5A6227C88A05'
$checksumType32 = 'sha256'
$url64          = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x64.msi'
$checksum64     = '62797d52376016d26790651c459798faa8612c7f6cd0966b1b220bd5d8b986e7'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url32
  checksum       = $checksum32
  checksumType   = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName   = 'Server Backup Agent*'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs
