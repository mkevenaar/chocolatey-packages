$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x86.msi'
$checksum32     = '70685580735254E9F7F3502981F1354A4BDEE35536735C5964A260011D4454C1'
$checksumType32 = 'sha256'
$url64          = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x64.msi'
$checksum64     = '88220303617c6eb0c4bc71cf117e65175648c24994c751f7599b142bdb3beba9'
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
