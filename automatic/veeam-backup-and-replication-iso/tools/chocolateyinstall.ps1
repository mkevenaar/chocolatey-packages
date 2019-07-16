$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VeeamBackup&Replication_9.5.4.2866.Update4b.iso'
$checksum = 'f6530003df11dc9389410aedcf9d2cfa143d5244ccd4d4c30de5c0f637be7116'
$checksumType = 'sha256'

$filename = 'VeeamBackup&Replication_9.5.4.2866.Update4b.iso'
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
