$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

#Based on Msi
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Microsoft System CLR Types for SQL Server 2014*'
  fileType      = 'msi'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
  url           = "https://download.microsoft.com/download/F/E/E/FEE62C90-E5A9-4746-8478-11980609E5C2/ENU/x86/SQLSysClrTypes.msi"
  checksum      = 'E592C97417B8102AA1AFF72A28012AB8BF122E02CB9C23C692B76E1D1EA9B47E'
  checksumType  = 'sha256'
  url64bit      = "https://download.microsoft.com/download/F/E/E/FEE62C90-E5A9-4746-8478-11980609E5C2/ENU/x64/SQLSysClrTypes.msi"
  checksum64    = 'D264B0B4D8E503C2638C18F09FF74F895DA92A9984D2B7C5D6192A6A22FA3C41'
  checksumType64= 'sha256'
  destination   = $toolsDir
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
