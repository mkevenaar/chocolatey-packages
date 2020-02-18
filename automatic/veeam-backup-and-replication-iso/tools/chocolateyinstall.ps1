$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VeeamBackup&Replication_10.0.0.4461.iso'
$checksum = '26ddcc3df046af1ca1458b3040fc9024b4361ae1e51e1cf4516afe53fb024650'
$checksumType = 'sha256'

$filename = 'VeeamBackup&Replication_10.0.0.4461.iso'
$packagePath = $(Split-Path -parent $toolsDir)
$installPath = Join-Path $packagePath $filename

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = $installPath
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Get-ChocolateyWebFile @packageArgs
