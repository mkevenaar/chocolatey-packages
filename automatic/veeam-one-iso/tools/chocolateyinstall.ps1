$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VONE/v12/VeeamONE_12.1.0.3208_20231130.iso'
$checksum = '25a2b78ad0a046e7314294171f54166955d9a2172de5353593975a27c5f878f3'
$checksumType = 'sha256'

$filename = 'VeeamONE_12.1.0.3208_20231130.iso'
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
