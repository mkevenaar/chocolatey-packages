$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VeeamKB/4158/VeeamBackupOffice365_5.0.1.252_KB4158.zip'
$checksum = 'd3eba9b999d39c9118881ff3d74b582b1be0e9ffb24c43f152905bb15e036b2f'
$checksumType = 'sha256'
$version = '5.0.1.252'

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
