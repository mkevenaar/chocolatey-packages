$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/kibana/kibana-9.4.3-windows-x86_64.zip'
$checksum     = 'e307db329d156f2c0193f4012879ba6ff92a8adf3c99d5f1ac5d9c6275fc85e2'
$checksumType = 'sha256'
$version      = "9.4.3"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

$kibanaDir = Join-Path $toolsDir "kibana-$($version)"

Get-ChildItem -Path $kibanaDir -Recurse -Filter '*.exe' |
  Where-Object { -not $_.PSIsContainer } |
  ForEach-Object { Set-Content "$($_.FullName).ignore" }

$binPath = Join-Path $toolsDir "kibana-$($version)\bin"

Install-ChocolateyPath $binPath 'Machine'

$ServiceName = 'kibana-service'

Write-Host "Installing service"

# Temp fallback as chocolateyBeforeModify is added in a recent release
try {
  write-host "Shutting down Kibana if it is running"
  Start-ChocolateyProcessAsAdmin "cmd /c NET STOP $($ServiceName)"
  Start-ChocolateyProcessAsAdmin "cmd /c sc delete $($ServiceName)"
} catch {
  # no service installed
}
nssm install $ServiceName $(Join-Path $toolsDir "kibana-$($version)\bin\kibana.bat")
nssm set $ServiceName Start SERVICE_DEMAND_START
