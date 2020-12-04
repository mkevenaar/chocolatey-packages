$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VBO/v5/GA/VeeamBackupOffice365_5.0.0.1061.zip'
$checksum = '0be53a85cfa1b8938c5fb8406e994226f0d059de2319f0ff01cfe0fb7a920fc3'
$checksumType = 'sha256'
$version = '5.0.0.1063'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage @packageArgs

$fileLocation = Get-ChildItem $toolsDir\VeeamExplorerForSharePoint*.msi

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Veeam Explorer for Microsoft SharePoint*'
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs     = "ACCEPT_EULA=1 ACCEPT_THIRDPARTY_LICENSES=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.msi | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
