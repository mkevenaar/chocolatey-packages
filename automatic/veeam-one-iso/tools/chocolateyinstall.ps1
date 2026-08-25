$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$SettingsXmlPath = Join-Path $toolsDir 'VOSettings.xml'
$SettingsXmlIsoPath = 'Setup\VOSettings.xml'

$url = 'https://download2.veeam.com/VONE/v13/VeeamONE_13.1.0.7233_20260821.iso'
$checksum = '935b10c7afbda04d776092e56ef36cfc544b1fe791b9645cae13d69aa44aa150'
$checksumType = 'sha256'

$filename = 'VeeamONE_13.1.0.7233_20260821.iso'
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
