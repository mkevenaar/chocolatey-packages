$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VONE/v12/VeeamONE_12.0.1.2591_20230314.iso'
$checksum = '95ba710a14ae792e16fe0f336aa4830b82974f697ad3140081106533f216e0ad'
$checksumType = 'sha256'

$filename = 'VeeamONE_12.0.1.2591_20230314.iso'
$packagePath = $(Split-Path -parent $toolsDir)
$installPath = Join-Path $packagePath $filename

#cleanup any old ISO files from previous versions
Get-ChildItem $packagePath\*.iso | Where-Object Name -NotMatch $filename | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileFullPath = $installPath
  url          = $url
  checksum     = $checksum
  checksumType = $checksumType
}

Get-ChocolateyWebFile @packageArgs
