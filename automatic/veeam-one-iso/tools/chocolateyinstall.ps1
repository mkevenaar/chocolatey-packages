$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$SettingsXmlPath = Join-Path $toolsDir 'VOSettings.xml'
$SettingsXmlIsoPath = 'Setup\VOSettings.xml'

$url = 'https://download2.veeam.com/VONE/v13/VeeamONE_13.1.0.7034_20260723.iso'
$checksum = 'ea38fc44c166253c91af57504c5967799d545393e85cdcb32754bdf87f7ed75a'
$checksumType = 'sha256'

$filename = 'VeeamONE_13.1.0.7034_20260723.iso'
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
