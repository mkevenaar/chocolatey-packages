$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/kibana/kibana-7.15.0-windows-x86_64.zip'
$checksum     = 'd5bcc668cb48b7574d012610ed210b726cdca2ccfbc3893c48379ea20b7c31c5'
$checksumType = 'sha256'
$version      = "7.15.0"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

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
nssm install $ServiceName $(Join-Path $toolsDir "kibana-$($version)-windows-x86_64\bin\kibana.bat")
nssm set $ServiceName Start SERVICE_DEMAND_START
