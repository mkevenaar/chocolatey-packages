$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$SettingsXmlPath = Join-Path $toolsDir 'VSPCSettings.xml'
$SettingsXmlIsoPath = 'Setup\VSPCSettings.xml'

$url = 'https://download2.veeam.com/VSPC/v9/VeeamServiceProviderConsole_9.3.0.35706_20260901.iso'
$checksum = '931553a86de4478a726ac0e59313d894bb21fa7b35817b1c1873eab099f8887b'
$checksumType = 'sha256'

$filename = 'VeeamServiceProviderConsole_9.3.0.35706_20260901.iso'
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
