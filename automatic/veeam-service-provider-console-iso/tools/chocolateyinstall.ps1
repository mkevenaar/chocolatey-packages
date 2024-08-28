$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VSPC/v8/VeeamServiceProviderConsole_8.1.0.21377_20240820.iso'
$checksum = '98f9128d68c4a2e52a8d5926e4ec971cc90517632cb06c7136f62980082d8018'
$checksumType = 'sha256'

$filename = 'VeeamServiceProviderConsole_8.1.0.21377_20240820.iso'
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
