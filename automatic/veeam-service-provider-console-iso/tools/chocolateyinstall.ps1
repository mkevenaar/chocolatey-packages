$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VSPC/v9/VeeamServiceProviderConsole_9.0.0.29555.iso'
$checksum = '93027bb04e51416020fe0bc53b2fac5408947cc9707ab8b709c3a8a277f44e8a'
$checksumType = 'sha256'

$filename = 'VeeamServiceProviderConsole_9.0.0.29555.iso'
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
