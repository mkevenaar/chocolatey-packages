$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x86.msi'
$checksum32     = 'B240CB0BC52CDB766F892E365960CC55BBA920E3390FD2A82121FFCDE9A98CFA'
$checksumType32 = 'sha256'
$url64          = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x64.msi'
$checksum64     = '12253e00554889061beae00fec4551c8d4b50b802c45116c1cc0d103b0a6962d'
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
