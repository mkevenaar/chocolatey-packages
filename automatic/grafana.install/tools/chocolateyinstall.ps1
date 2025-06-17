$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://dl.grafana.com/oss/release/grafana-12.0.2.windows-amd64.msi'
$checksum64 = '2c38f0abbbd5abd577dde74b8df5883f565cdfb24f54b65c5d5fbeca2a6f30b1'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url64          = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
  softwareName   = 'GrafanaOSS*'
  silentArgs     = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0, 1641, 3010)
}

Write-Verbose "Downloading and installing program..."
Install-ChocolateyPackage @packageArgs
