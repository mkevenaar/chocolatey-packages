$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/kibana/kibana-7.15.2-windows-x86_64.zip'
$checksum     = '207412619bafc08bd9e25fce1406d38e9e30a3e893398e32e8feacea7e5e14d8'
$checksumType = 'sha256'
$version      = "7.15.2"

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
