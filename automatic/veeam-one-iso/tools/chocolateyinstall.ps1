$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$SettingsXmlPath = Join-Path $toolsDir 'VOSettings.xml'
$SettingsXmlIsoPath = 'Setup\VOSettings.xml'

$url = 'https://download2.veeam.com/VONE/v13/VeeamONE_13.1.0.7940.iso'
$checksum = '1c97a15ea413378a852b8de2b5c4a5e0256c622d5a7c6315119a8f1698b53d74'
$checksumType = 'sha256'

$filename = 'VeeamONE_13.1.0.7940.iso'
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
