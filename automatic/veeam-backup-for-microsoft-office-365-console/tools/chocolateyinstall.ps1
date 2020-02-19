$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VeeamBackupOffice365_4.0.0.2516.zip'
$checksum = '71300aa032b544d0a080682e40da243b363e607745157a1d1e6754fa1b321b87'
$checksumType = 'sha256'
$version = '4.0.0.2516'
$fileLocation = Join-Path $toolsDir "Veeam.Backup365_$($version).msi"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

$pp = Get-PackageParameters

[System.Collections.ArrayList]$silentArgs = @()

if ($pp.console) {
  $silentArgs.Add('CONSOLE_OFFICE365')
}

if ($pp.powershell) {
  $silentArgs.Add('PS_OFFICE365')
}

if ($silentArgs.Count -eq 0) {
  $silentArgs.Add('CONSOLE_OFFICE365')
  $silentArgs.Add('PS_OFFICE365')
}

$silent = $silentArgs -join ','

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Veeam Backup for Microsoft Office 365*'
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs    = "/qn /norestart ADDLOCAL=$($silent) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyInstallPackage @packageArgs
