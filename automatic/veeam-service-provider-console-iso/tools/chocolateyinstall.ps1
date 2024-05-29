$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$headers = @{
  "User-Agent" = "Chocolatey Installation. https://chocolatey.org"
}

$options =
@{
  Headers = $headers
}

$url = 'https://download2.veeam.com/VSPC/v8/VeeamServiceProviderConsole_8.0.0.19236_20240426.iso'
$checksum = '227c23193f2c6eda03c5521eaef8bc74da62bae165c030423d70ad88360173fa'
$checksumType = 'sha256'

$filename = 'VeeamServiceProviderConsole_8.0.0.19236_20240426.iso'
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
  Options      = $options
}

Get-ChocolateyWebFile @packageArgs
