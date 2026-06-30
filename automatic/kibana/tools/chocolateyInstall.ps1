$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/kibana/kibana-9.3.7-windows-x86_64.zip'
$checksum     = '8f8081930d8d6c1e3828bb77936fa2524ba99157d46958afe1c1bcd9d4ebb05c'
$checksumType = 'sha256'
$version      = "9.3.7"

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
