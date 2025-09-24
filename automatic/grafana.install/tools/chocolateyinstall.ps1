$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://dl.grafana.com/oss/release/grafana-12.2.0.windows-amd64.msi'
$checksum64 = 'b5b9daeec3aa14a38c1385cc813ee1be2fef6cdadf3e6808ff12f387a69b538b'
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
