$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32 = 'https://dl.grafana.com/oss/release/grafana-12.2.0.windows-amd64.zip'
$checksum32 = 'e5d1bde97dd6f0920398c5cc3f03eebe314dcb6f20f04b0a94dcdea744b76780'
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
