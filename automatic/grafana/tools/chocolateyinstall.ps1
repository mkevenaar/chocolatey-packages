$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.grafana.com/oss/release/grafana-7.0.3.windows-amd64.zip'
$checksum     = '90f6c74233f009571ac5c1e785c0994bc0aeee82864322775a5e57645ce81cd0'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

