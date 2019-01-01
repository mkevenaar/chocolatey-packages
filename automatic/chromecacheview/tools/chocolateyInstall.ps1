$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://www.nirsoft.net/utils/chromecacheview.zip'
$checksum     = 'b47f4da8a296b18cc681fc656bcfb23ec425d25572eda0ec22fe374517704573'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

# create empty sidecar so shimgen creates shim for GUI rather than console
$installFile = Join-Path -Path $toolsDir `
                         -ChildPath "chromecacheview.exe.gui"
Set-Content -Path $installFile `
            -Value $null
