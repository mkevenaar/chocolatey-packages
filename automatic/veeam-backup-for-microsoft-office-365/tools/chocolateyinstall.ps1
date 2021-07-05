$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VBO/v5/VeeamBackupOffice365_5.0.2.22.zip'
$checksum = '64b5da0e271013b06f133b8e28cb267ce019185641939da4a0b3c866c48420c1'
$checksumType = 'sha256'
$version = '5.0.2.22'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

$pp = Get-PackageParameters

[System.Collections.ArrayList]$silentArgs = @()

if ($pp.server) {
  $silentArgs.Add('BR_OFFICE365')
}

if ($pp.console) {
  $silentArgs.Add('CONSOLE_OFFICE365')
}

if ($pp.powershell) {
  $silentArgs.Add('PS_OFFICE365')
}

if ($silentArgs.Count -eq 0) {
  $silentArgs.Add('BR_OFFICE365')
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
