$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$SettingsXmlPath = Join-Path $toolsDir 'VSPCSettings.xml'
$SettingsXmlIsoPath = 'Setup\VSPCSettings.xml'

$url = 'https://download2.veeam.com/VSPC/v9/VeeamServiceProviderConsole_9.3.0.35057_20260726.iso'
$checksum = 'c2b0ce5b3b537912656a861044caa46eaae0a3df50fab585bf3a4bbaae656f13'
$checksumType = 'sha256'

$filename = 'VeeamServiceProviderConsole_9.3.0.35057_20260726.iso'
$packagePath = $(Split-Path -parent $toolsDir)
$installPath = Join-Path $packagePath $filename

#cleanup any old ISO files from previous versions
Get-ChildItem $packagePath\*.iso | Where-Object Name -NotMatch $filename | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

$packageArgs = @{
  PackageName  = $env:ChocolateyPackageName
  FileFullPath = $installPath
  Url          = $url
  Checksum     = $checksum
  ChecksumType = $checksumType
}

Get-ChocolateyWebFile @packageArgs

#Extract the settings XML from the ISO for later use
$settingsArgs = @{
  isoFile     = $installPath
  filePath    = $SettingsXmlIsoPath
  destination = $SettingsXmlPath
  packageName = $env:ChocolateyPackageName
}

Get-ChocolateyIsoFile @settingsArgs
