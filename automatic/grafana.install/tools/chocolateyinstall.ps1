$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://dl.grafana.com/oss/release/grafana-13.1.3.windows-amd64.msi'
$checksum64 = '799eb217f307d0cc804029fdc90b51d1ca4ed36489c3e590db1a70844a0feaea'
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
