$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VeeamONE.10.0.0.750.iso'
$checksum = '447321fe1f4017d305793c3bfcdf30af0b7d4a655148926bb85e9af1b11b3e53'
$checksumType = 'sha256'

$filename = 'VeeamONE.10.0.0.750.iso'
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
