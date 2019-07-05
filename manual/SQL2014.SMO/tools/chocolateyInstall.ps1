$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

#Based on Msi
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Microsoft SQL Server 2014 Management Objects*'
  fileType      = 'msi'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
  url           = "http://download.microsoft.com/download/1/3/0/13089488-91FC-4E22-AD68-5BE58BD5C014/ENU/x86/SharedManagementObjects.msi"
  checksum      = 'A44DE01F0554962C2D9E80C947FF3918FADD2E5F4B9C5D1AFA523D6E84A37332'
  checksumType  = 'sha256'
  url64bit      = "http://download.microsoft.com/download/1/3/0/13089488-91FC-4E22-AD68-5BE58BD5C014/ENU/x64/SharedManagementObjects.msi"
  checksum64    = 'A44DE01F0554962C2D9E80C947FF3918FADD2E5F4B9C5D1AFA523D6E84A37332'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs

  # install both x86 and x64 editions of SMO since x64 supports both
  # to install both variants of powershell, both variants of SMO must be present
  $IsSytem32Bit = (($Env:PROCESSOR_ARCHITECTURE -eq 'x86') -and `
    ($null -eq $Env:PROCESSOR_ARCHITEW6432))

  if (!$IsSytem32Bit)
  {
    $packageArgs.url64bit = $packageArgs.url
    $packageArgs.checksum64 = $packageArgs.checksum
    $packageArgs.checksumType64 = $packageArgs.checksumType
    Install-ChocolateyPackage @packageArgs
  }
