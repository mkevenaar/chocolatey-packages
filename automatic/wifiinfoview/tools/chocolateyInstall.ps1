$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://www.nirsoft.net/utils/wifiinfoview.zip'
$checksum     = 'c0f2cb0c839afec602a798d60f9bdb38c8d5ba9b91e69ce05be0c51532909a9c'
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
                         -ChildPath "wifiinfoview.exe.gui"
Set-Content -Path $installFile `
            -Value $null
