$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VeeamBackup&Replication_9.5.4.2753.Update4a.iso'
$checksum = '2511ec6916a859171f1dd10738c4f8ecae2bb816de06bc338e533dec52593d4e'
$checksumType = 'sha256'

$filename = 'VeeamBackup&Replication_9.5.4.2753.Update4a.iso'
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
