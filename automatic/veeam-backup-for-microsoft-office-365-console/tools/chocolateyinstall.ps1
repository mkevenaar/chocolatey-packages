$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VBO/v5/GA/VeeamBackupOffice365_5.0.0.1070.zip'
$checksum = 'fc864e73061b4e8d1a326eab8842061b9942d2d9d9fd476483822e37d969b8d2'
$checksumType = 'sha256'
$version = '5.0.0.1070'

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

$fileLocation = Get-ChildItem $toolsDir\Veeam.Backup365*.msi

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Veeam Backup for Microsoft Office 365*'
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs    = "/qn /norestart ADDLOCAL=$($silent) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.msi | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
