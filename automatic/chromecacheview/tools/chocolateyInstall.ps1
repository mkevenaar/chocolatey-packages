$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://www.nirsoft.net/utils/chromecacheview.zip'
$checksum     = '7a62aedff0fa03342b1386b6122bbc5a83dddd0d21fec02f87dd1635a507fcff'
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
