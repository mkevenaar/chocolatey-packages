$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://download.aida64.com/aida64business675.zip'
$checksum     = 'f93a05eaa13ed570c3fcc58bf417b48ea91987b0dbc627421e94a9ff3def2c9c'
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
                         -ChildPath "aida64.exe.gui"
Set-Content -Path $installFile `
            -Value $null
