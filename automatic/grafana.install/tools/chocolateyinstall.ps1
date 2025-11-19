$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://dl.grafana.com/oss/release/grafana-12.3.0.windows-amd64.msi'
$checksum64 = '208fb406c00e6f35be28e5e9f7b81552c883f0ec4ae0b151008cd3d52097f0b6'
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
