$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32 = 'https://dl.grafana.com/oss/release/grafana-12.2.5.windows-amd64.zip'
$checksum32 = '3b34dfc983e056299e5a740abca3732c925055d474388d686fba8fa3dda6886c'
$checksumType32 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'zip'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
}

Install-ChocolateyZipPackage @packageArgs
