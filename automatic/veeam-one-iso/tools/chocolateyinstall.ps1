$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VONE/v12/VeeamONE_12.2.0.4093.iso'
$checksum = '51a5a2d0196aedf7fbdc7396811116b089a33025d02e692a51e5eb6ec0af7127'
$checksumType = 'sha256'

$filename = 'VeeamONE_12.2.0.4093.iso'
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
