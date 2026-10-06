$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/kibana/kibana-9.5.5-windows-x86_64.zip'
$checksum     = '4fe269ee064f225fc04486af5b4151e08718e0b9d5940fc8ee4273e3fa218fc9'
$checksumType = 'sha256'
$version      = "9.5.5"

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
