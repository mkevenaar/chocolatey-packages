$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'https://download.microsoft.com/download/F/E/E/FEE62C90-E5A9-4746-8478-11980609E5C2/ENU/x86/SQLSysClrTypes.msi'
$checksum32     = '5CA2CC72AA5B9D02014958A8BF664676672DE7D10EF4F4BD2658301210541867'
$checksumType32 = 'sha256'
$url64          = 'https://download.microsoft.com/download/F/E/E/FEE62C90-E5A9-4746-8478-11980609E5C2/ENU/x64/SQLSysClrTypes.msi'
$checksum64     = '74cb1bc8216b24acfbc643ea7555fc7d6067dfd39b7316e79203552c36282c8f'
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
  softwareName  = 'Microsoft System CLR Types for SQL Server 2014*'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs

# http://forums.iis.net/p/1174672/1968094.aspx
# it turns out that even on x64, x86 clr types should also be installed
# or SMO breaks
$IsSytem32Bit = (($Env:PROCESSOR_ARCHITECTURE -eq 'x86') -and `
  ($null -eq $Env:PROCESSOR_ARCHITEW6432))
if (!$IsSytem32Bit)
{
  $packageArgs.url64bit = $packageArgs.url
  $packageArgs.checksum64 = $packageArgs.checksum
  $packageArgs.checksumType64 = $packageArgs.checksumType
  Install-ChocolateyPackage @packageArgs
}
