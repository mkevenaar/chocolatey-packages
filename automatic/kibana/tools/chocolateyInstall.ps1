$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/kibana/kibana-8.19.20-windows-x86_64.zip'
$checksum     = '48308ef3eb6b0482855fad52c0f06ce070ad73de239b7f9357a8e3dafb66d67d'
$checksumType = 'sha256'
$version      = "8.19.20"

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
