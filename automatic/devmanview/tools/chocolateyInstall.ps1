$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.nirsoft.net/utils/devmanview.zip'
$checksum32     = '13b882a7aed945ba4a2f303122c36f6b7a1dd6c68f6c14cb086172677c9f8243'
$checksumType32 = 'sha256'
$url64          = 'http://www.nirsoft.net/utils/devmanview-x64.zip'
$checksum64     = '5afa7d229c6b892fa25fdfd2fdd12cc4eee8cdc7a8fda4106ad97fbb8b8a5ad6'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url            = $url32
  checksum       = $checksum32
  checksumType   = $checksumType32
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
}

Install-ChocolateyZipPackage  @packageArgs

# create empty sidecar so shimgen creates shim for GUI rather than console
$installFile = Join-Path -Path $toolsDir `
                         -ChildPath "devmanview.exe.gui"
Set-Content -Path $installFile `
            -Value $null
