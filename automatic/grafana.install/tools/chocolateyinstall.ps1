$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://dl.grafana.com/oss/release/grafana-13.1.2.windows-amd64.msi'
$checksum64 = '646f4a9edba55b5a1b06c07664b0eda7d477011e83ab5f7f83cf7e212744c346'
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
