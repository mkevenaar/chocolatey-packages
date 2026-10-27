$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VBO/v8/VeeamBackupMicrosoft365_8.6.0.5011.iso'
$checksum = '6c189a683833748d2f6fc230f64115e409fb8b1e32b3e0ff5ee4f8ecd072eca3'
$checksumType = 'sha256'

$filename = 'VeeamBackupMicrosoft365_8.6.0.5011.iso'
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
