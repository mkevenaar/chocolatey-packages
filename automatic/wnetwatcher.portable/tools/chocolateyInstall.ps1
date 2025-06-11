$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://www.nirsoft.net/utils/wnetwatcher.zip'
$checksum     = '7f9c1e46f0f80ad6e41430f129db1482356e633d00a522441e16d1c9d18bfac5'
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
                         -ChildPath "wnetwatcher.exe.gui"
Set-Content -Path $installFile `
            -Value $null
