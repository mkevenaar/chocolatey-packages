$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VSPC/v7/VeeamServiceProviderConsole_7.0.0.12777_20230123.iso'
$checksum = 'cc1a68ba4173c42f5636d46ddd55bd0fd13d9bc8e96a028907d5fcf0eb866985'
$checksumType = 'sha256'

$filename = 'VeeamServiceProviderConsole_7.0.0.12777_20230123.iso'
$packagePath = $(Split-Path -parent $toolsDir)
$installPath = Join-Path $packagePath $filename

#cleanup any old ISO files from previous versions
Get-ChildItem $packagePath\*.iso | Where-Object Name -NotMatch $filename | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = $installPath
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Get-ChocolateyWebFile @packageArgs
